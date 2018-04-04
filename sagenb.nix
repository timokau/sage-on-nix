# Has a cyclic dependency with sage (not expressed here) and is not useful outside of sage
{ stdenv
, python
, buildPythonPackage
, fetchFromGitHub
, mathjax
, twisted
, flask
, flask_oldsessions
, flask_openid
, flask_autoindex
, flask_babel
, python_openid
, babel
, speaklater
, flask_silk
, future
, pytz
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
    flask_oldsessions
    flask_openid
    flask_autoindex
    flask_babel
    python_openid # FIXME propagated by flask_openid
    babel # FIXME propagated by flask_babel
    speaklater # FIXME propagated by flask_babel
    flask_silk # FIXME propagated by flask_autoindex
    future # FIXME propagated by flask_autoindex
    pytz # FIXME propagated by Babel
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
  ];

  # let sagenb use mathjax
  postInstall = ''
    ln -s ${mathjax}/lib/node_modules/mathjax "$out/${python.sitePackages}/mathjax"
  '';
}
