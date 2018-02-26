#! /usr/bin/env python3

import ast
import urllib.request
import os

# TODO checkout need_to_install_spkg
# TODO dependency on git and gcc

# TODO use all
mirrorlist = ast.literal_eval(urllib.request.urlopen('http://www.sagemath.org/mirror_list').read().decode('utf-8'))
MIRROR=mirrorlist[0] + '/spkg/upstream'


def additional_deps(name):
    if name == "curl":
        return ["openssl"]
    elif name == "maxima":
        return [ "python2" ]
    elif name == "gcc": # TODO
        return [ "glibc" ]
    elif name == "libgd":
        return [ "zlib" ]
    return []

def additional_patches(name):
    path='patches/{}'.format(name)
    patches = []
    if os.path.isdir(path):
        for f in os.listdir(path):
            (root, ext) = os.path.splitext(f)
            if ext == '.patch':
                patches += [ f ]
    return patches

def additional_patch_script(name):
    path='patches/{}/'.format(name)
    script = ''
    if os.path.isdir(path):
        for f in os.listdir(path):
            (root, ext) = os.path.splitext(f)
            if ext == '.sh':
                script += '\n' + open(path + f).read()
    return script

DEFAULT_DEPS = [
        'stdenv',
        'perl',
        'gfortran6',
        'autoreconfHook',
        'gettext',
        'hevea'
]

derivation_template = open('spkg-template.nix').read()

# TODO fetch spkg_install and patches and upstream? from SAGE_VERSION repo
def generate_derivation(name, filename, version, url, sha1, patches, spkg_deps):
    patchstr = ""
    for patch in patches:
        patchstr = patchstr + '\n    "${{sage-src}}/build/pkgs/{name}/patches/{patch}"'.format(name = name, patch = patch)
    for patch in additional_patches(name):
        # patchstr = patchstr + '\n    "../patches/{name}/{patch}"'.format(name = name, patch = patch)
        patchstr = patchstr + '\n    ../patches/{name}/{patch}'.format(name = name, patch = patch)
    patchstr += "\n  "
    depstr = ""
    inputstr = ""
    unpack_deps = [ "unzip" ] if filename[-3:] == 'zip' else []
    for dep in DEFAULT_DEPS + spkg_deps + additional_deps(name) + unpack_deps:
        depstr = depstr + ", " + dep
        inputstr = inputstr + " " + dep
    with open("default.nix", 'w') as f:
        return derivation_template.format(
                name = name,
                version = version,
                url = url,
                sha1 = sha1,
                patches = patchstr,
                spkg_deps = depstr,
                build_inputs = inputstr,
                postPatch = additional_patch_script(name),
                download_url = "{}/{}/{}".format(MIRROR, name, filename),
        );

def read_version(spkg_dir):
    version_string = open("{}/package-version.txt".format(spkg_dir), 'r').readline().rstrip()
    # patch
    patch_part = version_string.split('.')[-1]
    if (patch_part[0] == 'p'):
        return (version_string[:-(len(patch_part) + 1)], patch_part[1:])
    else:
        return (version_string, '0')

# determines the type of the given spkg
# type is one of
# - base
# - experimental
# - optional
# - pip
# - standard
def read_type(spkg_dir):
    with open("{}/type".format(spkg_dir), 'r') as f:
        return f.readline()[:-1]

def read_patches(spkg_dir):
    path = '{}/patches'.format(spkg_dir)
    patches = []
    if os.path.isdir(path):
        for patch in os.listdir(path):
            if patch[-6:] == '.patch': # TODO investingate
                patches += [ patch ]
    return patches

def read_tarball(spkg_dir):
    import configparser
    from io import StringIO
    ini_str = '[root]\n' + open('{}/checksums.ini'.format(spkg_dir), 'r').read()
    ini_fp = StringIO(ini_str)
    config = configparser.RawConfigParser()
    config.readfp(ini_fp)
    config = config["root"]
    return (config["tarball"], config["sha1"])

def read_deps(spkg_dir):
    path = "{}/dependencies".format(spkg_dir)
    if not os.path.isfile(path):
        return ([], [])

    deps_line = open(path, 'r').readline().rstrip()
    if deps_line == "# no dependencies":
        return ([], [])
    else:
        deps = deps_line.split()
        split = len(deps)
        # TODO translate:
        # https://groups.google.com/forum/?fromgroups#!searchin/sage-devel/inst_%7Csort:date/sage-devel/nTwhCV89FXE/j8kPmnIsBQAJ
        # $BLAS = openblas or atlas
        for (i, dep) in enumerate(deps):
            if dep == "|":
                split = i
            elif dep == "$(BLAS)":
                deps[i] = "openblas"
            elif dep == "$(PYTHON)":
                deps[i] = "python"
            elif dep[0:7] == "$(inst_":
                deps[i] = dep[7:-1]
            elif dep == "$(MP_LIBRARY)":
                deps[i] = "gmp"
            elif dep == "$(SAGE_MP_LIBRARY)":
                deps[i] = "gmp"
            elif dep == "$(SAGERUNTIME)":
                deps[i] = "" # TODO
        # normal (run), order-only (build)
        return (deps[0:split], deps[split + 1:])


# TODO maybe read description from SPKG.txt

def read_spkg(name, path):
    # print(generate_derivation("zlib", "myurl", "mysha", ["patch1", "patch2"]))
    # print("\n======{}=======".format(name))
    (version, patch) = read_version(path)
    (filename, sha1) = read_tarball(path)
    filename = filename.replace('VERSION', version)
    (runtime, buildtime) = read_deps(path)
    patches = read_patches(path)
    return generate_derivation(name, filename, version, "URL", sha1, patches, runtime + buildtime)

def parse_spkgs(spkgs_path):
    with open("all.nix", 'w') as a:
        a.write("""let pkgs = import <nixpkgs> {};
    texlive = (pkgs.texlive.combine { inherit (pkgs.texlive)
          scheme-basic
          collection
          times
          stmaryrd
          babel
          ;
        });
    callPackage = pkgs.newScope (self
      // { inherit (pkgs) fetchurl stdenv unzip perl python gfortran6 autoreconfHook gettext hevea which; }
      // { inherit texlive; }
      );
    self = {""")
        for spkg in os.listdir(spkgs_path):
            path = "{}/{}".format(spkgs_path, spkg)
            if read_type(path) == 'standard':
                with open("spkgs/{}.nix".format(spkg), 'w') as f:
                    f.write(read_spkg(spkg, path))
                    a.write("  {spkg} = callPackage ./spkgs/{spkg}.nix {{}};\n".format(spkg = spkg))
        a.write("""};
    in
    self""")

parse_spkgs("/home/timo/sage-8.1/build/pkgs")

# read_spkg("zlib") # no deps
# read_spkg("tides") # only normal deps
# read_spkg("werkzeug") # both deps
# TODO checks
