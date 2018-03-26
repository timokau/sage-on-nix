#! /usr/bin/env python3

import ast
import urllib.request
import os

# TODO checkout need_to_install_spkg
# TODO dependency on git and gcc

# TODO use all
mirrorlist = ast.literal_eval(urllib.request.urlopen('http://www.sagemath.org/mirror_list').read().decode('utf-8'))
MIRROR=mirrorlist[0] + 'spkg/upstream'

def path_fixes(deps):
    if len(deps) == 0:
        return ""
    substr = '    substituteInPlace spkg-install'
    # fix configure arguments in spkg-install
    for dep in deps:
        substr += ' \\\n        --replace \'--with-{dep}="$SAGE_LOCAL"\' \'--with-{dep}="${{{dep}}}"\''.format(dep = dep)
    return substr


def additional_deps(name):
    if name == "curl":
        return ["openssl"]
    elif name == "maxima":
        return [ "python2", "gmp", "gc" ]
    elif name == "gcc": # TODO
        return [ "glibc" ]
    elif name == "libgd":
        return [ "zlib" ]
    elif name == "brial":
        return [ "libgd", "zlib" ]
    elif name == "giac":
        return [ "zlib" ]
    elif name == "libgap":
        return [ "gmp" ]
    elif name == "eclib":
        return [ "gmp", "mpfr" ]
    elif name == "cypari":
        return [ "gmp" ]
    elif name == "linbox":
        return [ "pkgconfig" ]
    elif name == "lcalc":
        return [ "gmp" ]
    elif name == "pynac":
        return [ "mpfr" ] # TODO flint propagates mpfr
    elif name == "fpylll":
        return [ "pkgconfig", "pip", "gmp", "mpfr", "pari" ]
    elif name == "matplotlib":
        return [ "pkgconfig" ]
    elif name == "ipykernel":
        return [ "traitlets", "enum34", "six", "ipython_genutils", "decorator",  "pygments", "pexpect", "ptyprocess", "backports_shutil_get_terminal_size", "pathlib2", "pickleshare", "prompt_toolkit", "wcwidth", "simplegeneric", "pyzmq", "jupyter_core", "dateutil" ]
    elif name == "r":
        return [ "zlib" ]
    elif name == "rpy2":
        return [ "pkgconfig", "readline", "pcre", "bzip2", "xz", "zlib", "icu" ]
    elif name == "widgetsnbextension":
        return [ "traitlets", # TODO propagated by jupyter-core
                 "enum34", # TODO propagated by traitlets
                 "decorator", # TODO propagated by traitlets
                 "six", # TODO propagated by traitlets
                 "ipython_genutils", # TODO propagated by traitlets
                 "terminado", # TODO propagated by notebook
                 "ipykernel", # TODO propagated by notebook
                 "nbconvert", # TODO propagated by notebook
                 "nbformat", # TODO propagated by notebook, nbconvert
                 "jupyter_client", # TODO propagated by notebook, ipykernel
                 "tornado", # TODO propagated by notebook, terminado
                 "jinja2", # TODO propagated by notebook, nbconvert
                 "ptyprocess", # TODO propagated by terminado
                 "ipython", # TODO propagated by ipykernel
                 "entrypoints", # TODO propagated by nbconvert
                 "pygments", # TODO propagated by ipython, nbconvert
                 "mistune", # TODO propagated by nbconvert
                 "jsonschema", # TODO propagated by nbconvert (?)
                 "dateutil", # TODO propagated by jupyter-client
                 "pyzmq", # TODO propagated by jupyter-client
                 "backports_abc", # TODO propagated by tornado
                 "certifi", # TODO propagated by tornado
                 "singledispatch", # TODO propagated by tornado
                 "backports_ssl_match_hostname", # TODO propagated by tornado (?)
                 "markupsafe", # TODO propagated by jinja2
                 "pexpect", # TODO propagated by ipython
                 "pathlib2", # TODO propagated by ipython
                 "backports_shutil_get_terminal_size", # TODO propagated by ipython
                 "prompt_toolkit", # TODO propagated by ipython
                 "simplegeneric", # TODO propagated by ipython
                 "pickleshare", # TODO propagated by ipython
                 "functools32", # TODO propagated by ipython
                 "wcwidth" # TODO propagated by prompt-toolkit
               ]
    elif name == "cvxopt":
        return [ "gmp", "zlib" ]
    elif name == "tachyon":
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
def generate_derivation(name, filename, version, patch_version, url, sha1, patches, spkg_deps):
    patchstr = ""
    for patch in patches:
        patchstr = patchstr + '\n    "${{sage-src}}/build/pkgs/{name}/patches/{patch}"'.format(name = name, patch = patch)
    for patch in additional_patches(name):
        patchstr = patchstr + '\n    ../patches/{name}/{patch}'.format(name = name, patch = patch)
    patchstr += "\n  "
    depstr = ""
    inputstr = ""
    unpack_deps = [ "unzip" ] if filename[-3:] == 'zip' else []
    all_spkg_deps = spkg_deps + additional_deps(name)
    for dep in DEFAULT_DEPS + all_spkg_deps + unpack_deps:
        depstr = depstr + ", " + dep
        inputstr = inputstr + " " + dep

    return derivation_template.format(
            name = name,
            version = version,
            patch_version = patch_version,
            url = url,
            sha1 = sha1,
            patches = patchstr,
            spkg_deps = depstr,
            build_inputs = inputstr,
            postPatch = path_fixes(all_spkg_deps) + additional_patch_script(name),
            download_url = "{}/{}/{}".format(MIRROR, name, filename),
    );

def read_version(spkg_dir):
    version_string = open("{}/package-version.txt".format(spkg_dir), 'r').readline().rstrip()
    # patch
    patch_part = version_string.split('.')[-1]
    if (patch_part[0] == 'p'):
        return (version_string[:-(len(patch_part) + 1)], patch_part)
    else:
        return (version_string, '')

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
            (root, ext) = os.path.splitext(patch)
            if ext == '.patch':
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
                deps[i] = "python2"
            elif dep[0:7] == "$(inst_":
                deps[i] = dep[7:-1]
            elif dep == "$(MP_LIBRARY)":
                deps[i] = "gmp"
            elif dep == "$(SAGE_MP_LIBRARY)":
                deps[i] = "gmp"
            elif dep == "$(SAGERUNTIME)":
                deps[i] = "" # TODO
        # normal (run), order-only (build)
        # TODO
        return (deps[0:split], deps[split + 1:])


# TODO maybe read description from SPKG.txt

def read_spkg(name, path):
    (version, patch) = read_version(path)
    (filename, sha1) = read_tarball(path)
    filename = filename.replace('VERSION', version)
    (runtime, buildtime) = read_deps(path)
    patches = read_patches(path)
    return generate_derivation(name, filename, version, patch, "URL", sha1, patches, runtime + buildtime)

def parse_spkgs(spkgs_path):
    all_template = open('all-template.nix').read()
    spkgs = ''
    for spkg in os.listdir(spkgs_path):
        path = "{}/{}".format(spkgs_path, spkg)
        if read_type(path) == 'standard':
            with open("spkgs/{}.nix".format(spkg), 'w') as f:
                f.write(read_spkg(spkg, path))
                spkgs += "    {spkg} = callPackage ./spkgs/{spkg}.nix {{}};\n".format(spkg = spkg)
    with open("all.nix", 'w') as a:
        a.write(all_template.format(spkgs = spkgs))

# TODO don't hardcode
parse_spkgs("/home/timo/sage-8.1/build/pkgs")
