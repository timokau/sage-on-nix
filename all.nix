let pkgs = import <nixpkgs> {};
    texlive = (pkgs.texlive.combine { inherit (pkgs.texlive)
          scheme-basic
          collection
          times
          stmaryrd
          babel
          ;
        });
    callPackage = pkgs.newScope (self
      // { inherit (pkgs) fetchurl stdenv unzip perl python gfortran autoreconfHook gettext hevea which; }
      // { inherit texlive; }
      );
    self = {
      unpacked_sage = callPackage ./unpacked_sage.nix {};
      fetchspkg = callPackage ./fetchspkg.nix {};
      alabaster = callPackage ./spkgs/alabaster.nix {};
  appnope = callPackage ./spkgs/appnope.nix {};
  arb = callPackage ./spkgs/arb.nix {};
  babel = callPackage ./spkgs/babel.nix {};
  backports_abc = callPackage ./spkgs/backports_abc.nix {};
  backports_shutil_get_terminal_size = callPackage ./spkgs/backports_shutil_get_terminal_size.nix {};
  backports_ssl_match_hostname = callPackage ./spkgs/backports_ssl_match_hostname.nix {};
  boost_cropped = callPackage ./spkgs/boost_cropped.nix {};
  brial = callPackage ./spkgs/brial.nix {};
  bzip2 = callPackage ./spkgs/bzip2.nix {};
  cddlib = callPackage ./spkgs/cddlib.nix {};
  cephes = callPackage ./spkgs/cephes.nix {};
  certifi = callPackage ./spkgs/certifi.nix {};
  cliquer = callPackage ./spkgs/cliquer.nix {};
  combinatorial_designs = callPackage ./spkgs/combinatorial_designs.nix {};
  configparser = callPackage ./spkgs/configparser.nix {};
  conway_polynomials = callPackage ./spkgs/conway_polynomials.nix {};
  curl = callPackage ./spkgs/curl.nix {};
  cvxopt = callPackage ./spkgs/cvxopt.nix {};
  cycler = callPackage ./spkgs/cycler.nix {};
  cypari = callPackage ./spkgs/cypari.nix {};
  cysignals = callPackage ./spkgs/cysignals.nix {};
  cython = callPackage ./spkgs/cython.nix {};
  dateutil = callPackage ./spkgs/dateutil.nix {};
  decorator = callPackage ./spkgs/decorator.nix {};
  docutils = callPackage ./spkgs/docutils.nix {};
  ecl = callPackage ./spkgs/ecl.nix {};
  eclib = callPackage ./spkgs/eclib.nix {};
  ecm = callPackage ./spkgs/ecm.nix {};
  elliptic_curves = callPackage ./spkgs/elliptic_curves.nix {};
  entrypoints = callPackage ./spkgs/entrypoints.nix {};
  enum34 = callPackage ./spkgs/enum34.nix {};
  fflas_ffpack = callPackage ./spkgs/fflas_ffpack.nix {};
  flask = callPackage ./spkgs/flask.nix {};
  flask_autoindex = callPackage ./spkgs/flask_autoindex.nix {};
  flask_babel = callPackage ./spkgs/flask_babel.nix {};
  flask_oldsessions = callPackage ./spkgs/flask_oldsessions.nix {};
  flask_openid = callPackage ./spkgs/flask_openid.nix {};
  flask_silk = callPackage ./spkgs/flask_silk.nix {};
  flint = callPackage ./spkgs/flint.nix {};
  flintqs = callPackage ./spkgs/flintqs.nix {};
  fplll = callPackage ./spkgs/fplll.nix {};
  fpylll = callPackage ./spkgs/fpylll.nix {};
  freetype = callPackage ./spkgs/freetype.nix {};
  functools32 = callPackage ./spkgs/functools32.nix {};
  future = callPackage ./spkgs/future.nix {};
  gap = callPackage ./spkgs/gap.nix {};
  gc = callPackage ./spkgs/gc.nix {};
  gcc = callPackage ./spkgs/gcc.nix {};
  gf2x = callPackage ./spkgs/gf2x.nix {};
  gfan = callPackage ./spkgs/gfan.nix {};
  giac = callPackage ./spkgs/giac.nix {};
  git = callPackage ./spkgs/git.nix {};
  givaro = callPackage ./spkgs/givaro.nix {};
  glpk = callPackage ./spkgs/glpk.nix {};
  graphs = callPackage ./spkgs/graphs.nix {};
  gsl = callPackage ./spkgs/gsl.nix {};
  iconv = callPackage ./spkgs/iconv.nix {};
  imagesize = callPackage ./spkgs/imagesize.nix {};
  iml = callPackage ./spkgs/iml.nix {};
  ipykernel = callPackage ./spkgs/ipykernel.nix {};
  ipython = callPackage ./spkgs/ipython.nix {};
  ipython_genutils = callPackage ./spkgs/ipython_genutils.nix {};
  ipywidgets = callPackage ./spkgs/ipywidgets.nix {};
  itsdangerous = callPackage ./spkgs/itsdangerous.nix {};
  jinja2 = callPackage ./spkgs/jinja2.nix {};
  jmol = callPackage ./spkgs/jmol.nix {};
  jsonschema = callPackage ./spkgs/jsonschema.nix {};
  jupyter_client = callPackage ./spkgs/jupyter_client.nix {};
  jupyter_core = callPackage ./spkgs/jupyter_core.nix {};
  lcalc = callPackage ./spkgs/lcalc.nix {};
  libgap = callPackage ./spkgs/libgap.nix {};
  libgd = callPackage ./spkgs/libgd.nix {};
  libpng = callPackage ./spkgs/libpng.nix {};
  linbox = callPackage ./spkgs/linbox.nix {};
  lrcalc = callPackage ./spkgs/lrcalc.nix {};
  m4ri = callPackage ./spkgs/m4ri.nix {};
  m4rie = callPackage ./spkgs/m4rie.nix {};
  markupsafe = callPackage ./spkgs/markupsafe.nix {};
  mathjax = callPackage ./spkgs/mathjax.nix {};
  matplotlib = callPackage ./spkgs/matplotlib.nix {};
  maxima = callPackage ./spkgs/maxima.nix {};
  mistune = callPackage ./spkgs/mistune.nix {};
  mpc = callPackage ./spkgs/mpc.nix {};
  mpfi = callPackage ./spkgs/mpfi.nix {};
  mpfr = callPackage ./spkgs/mpfr.nix {};
  mpmath = callPackage ./spkgs/mpmath.nix {};
  nauty = callPackage ./spkgs/nauty.nix {};
  nbconvert = callPackage ./spkgs/nbconvert.nix {};
  nbformat = callPackage ./spkgs/nbformat.nix {};
  ncurses = callPackage ./spkgs/ncurses.nix {};
  networkx = callPackage ./spkgs/networkx.nix {};
  notebook = callPackage ./spkgs/notebook.nix {};
  ntl = callPackage ./spkgs/ntl.nix {};
  numpy = callPackage ./spkgs/numpy.nix {};
  openblas = callPackage ./spkgs/openblas.nix {};
  palp = callPackage ./spkgs/palp.nix {};
  pari = callPackage ./spkgs/pari.nix {};
  pari_galdata = callPackage ./spkgs/pari_galdata.nix {};
  pari_seadata_small = callPackage ./spkgs/pari_seadata_small.nix {};
  patch = callPackage ./spkgs/patch.nix {};
  pathlib2 = callPackage ./spkgs/pathlib2.nix {};
  pathpy = callPackage ./spkgs/pathpy.nix {};
  pcre = callPackage ./spkgs/pcre.nix {};
  pexpect = callPackage ./spkgs/pexpect.nix {};
  pickleshare = callPackage ./spkgs/pickleshare.nix {};
  pillow = callPackage ./spkgs/pillow.nix {};
  pip = callPackage ./spkgs/pip.nix {};
  pkgconf = callPackage ./spkgs/pkgconf.nix {};
  pkgconfig = callPackage ./spkgs/pkgconfig.nix {};
  planarity = callPackage ./spkgs/planarity.nix {};
  polytopes_db = callPackage ./spkgs/polytopes_db.nix {};
  ppl = callPackage ./spkgs/ppl.nix {};
  prompt_toolkit = callPackage ./spkgs/prompt_toolkit.nix {};
  psutil = callPackage ./spkgs/psutil.nix {};
  ptyprocess = callPackage ./spkgs/ptyprocess.nix {};
  pycrypto = callPackage ./spkgs/pycrypto.nix {};
  pygments = callPackage ./spkgs/pygments.nix {};
  pynac = callPackage ./spkgs/pynac.nix {};
  pyparsing = callPackage ./spkgs/pyparsing.nix {};
  python3 = callPackage ./spkgs/python3.nix {};
  python_openid = callPackage ./spkgs/python_openid.nix {};
  pytz = callPackage ./spkgs/pytz.nix {};
  pyzmq = callPackage ./spkgs/pyzmq.nix {};
  r = callPackage ./spkgs/r.nix {};
  ratpoints = callPackage ./spkgs/ratpoints.nix {};
  readline = callPackage ./spkgs/readline.nix {};
  requests = callPackage ./spkgs/requests.nix {};
  rpy2 = callPackage ./spkgs/rpy2.nix {};
  rubiks = callPackage ./spkgs/rubiks.nix {};
  rw = callPackage ./spkgs/rw.nix {};
  sagenb = callPackage ./spkgs/sagenb.nix {};
  sagenb_export = callPackage ./spkgs/sagenb_export.nix {};
  sagetex = callPackage ./spkgs/sagetex.nix {};
  scipy = callPackage ./spkgs/scipy.nix {};
  setuptools = callPackage ./spkgs/setuptools.nix {};
  setuptools_scm = callPackage ./spkgs/setuptools_scm.nix {};
  simplegeneric = callPackage ./spkgs/simplegeneric.nix {};
  singledispatch = callPackage ./spkgs/singledispatch.nix {};
  singular = callPackage ./spkgs/singular.nix {};
  six = callPackage ./spkgs/six.nix {};
  snowballstemmer = callPackage ./spkgs/snowballstemmer.nix {};
  speaklater = callPackage ./spkgs/speaklater.nix {};
  sphinx = callPackage ./spkgs/sphinx.nix {};
  sqlite = callPackage ./spkgs/sqlite.nix {};
  symmetrica = callPackage ./spkgs/symmetrica.nix {};
  sympow = callPackage ./spkgs/sympow.nix {};
  sympy = callPackage ./spkgs/sympy.nix {};
  tachyon = callPackage ./spkgs/tachyon.nix {};
  terminado = callPackage ./spkgs/terminado.nix {};
  thebe = callPackage ./spkgs/thebe.nix {};
  threejs = callPackage ./spkgs/threejs.nix {};
  tornado = callPackage ./spkgs/tornado.nix {};
  traitlets = callPackage ./spkgs/traitlets.nix {};
  twisted = callPackage ./spkgs/twisted.nix {};
  typing = callPackage ./spkgs/typing.nix {};
  vcversioner = callPackage ./spkgs/vcversioner.nix {};
  wcwidth = callPackage ./spkgs/wcwidth.nix {};
  werkzeug = callPackage ./spkgs/werkzeug.nix {};
  widgetsnbextension = callPackage ./spkgs/widgetsnbextension.nix {};
  xz = callPackage ./spkgs/xz.nix {};
  yasm = callPackage ./spkgs/yasm.nix {};
  zeromq = callPackage ./spkgs/zeromq.nix {};
  zlib = callPackage ./spkgs/zlib.nix {};
  zn_poly = callPackage ./spkgs/zn_poly.nix {};
  zope_interface = callPackage ./spkgs/zope_interface.nix {};
};
    in
    self