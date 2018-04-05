# Has a cyclic dependency with sage (not expressed here) and is not useful outside of sage
{ stdenv
, fetchpatch
, python
, buildPythonPackage
, fetchFromGitHub
, mathjax
, twisted
, flask
, flask-oldsessions
, flask-openid
, flask-autoindex
, flask-babel
}:

buildPythonPackage rec {
  pname = "sagenb";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sagenb";
    rev = "${version}";
    sha256 = "1yg374fymndqhhv6s0j158v5ggycc9rw6l2fwxwyli5xghxyl7a3";
  };

  propagatedBuildInputs = [
    twisted
    flask
    flask-oldsessions
    flask-openid
    flask-autoindex
    flask-babel
  ];

  # tests depend on sage
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Sage Notebook";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ timokau ];
  };

  patches = [
    ./patches/sagenb/sphinx-1.7.patch

    # Update to newer flask-babel
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/sagemath/sagenb/pull/438.patch";
      sha256 = "17830pzxis5dwakywcar0qcc07m90gmx4614n51i34sbjxbnrclz";
    })
  ];

  # let sagenb use mathjax
  postInstall = ''
    ln -s ${mathjax}/lib/node_modules/mathjax "$out/${python.sitePackages}/mathjax"
  '';
}
