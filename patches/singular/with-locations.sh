substituteInPlace spkg-install \
	--replace '--with-gmp="$SAGE_LOCAL"' '--with-gmp="${gmp}"' \
	--replace '--with-ntl="$SAGE_LOCAL"' '--with-ntl="${ntl}"' \
	--replace '--with-flint="$SAGE_LOCAL"' '--with-flint="${flint}"' \
