substituteInPlace spkg-install \
        --replace '--with-zlib="$SAGE_LOCAL"' '--with-zlib="${zlib}' \
        --replace '--with-freetype="$SAGE_LOCAL"' '--with-freetype="${freetype}'
