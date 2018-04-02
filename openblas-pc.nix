{ stdenv
, openblas
, writeTextFile
, name
}:

writeTextFile {
  name = "openblas-${name}-pc";
  destination = "/lib/pkgconfig/${name}.pc";
  text = ''
    Name: ${name}
    Version: ${openblas.version}

    Description: ${name} for SageMath, provided by the OpenBLAS package.
    Cflags: -I${openblas}/include
    Libs: -L${openblas}/lib -lopenblas
  '';
}
