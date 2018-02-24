substituteInPlace ./spkg-install \
  --replace '"$SAGE_LOCAL"/include/gmp.h' '"${gmp.dev}/include/gmph.h"' \
  --replace 'cp "$SAGE_ROOT"/config/config.*' '# TODO fix config.guess' \
  --replace '--with-gmp="$SAGE_LOCAL"' '--with-gmp-include="${gmp.dev}" --with-gmp-lib="${gmp}"'
  #--replace '--with-gmp=\"$SAGE_LOCAL\"' '--with-gmp=\"${gmp.dev}\"' \
