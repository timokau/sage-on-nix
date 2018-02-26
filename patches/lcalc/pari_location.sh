substituteInPlace src/src/Makefile \
    --replace '$(SAGE_LOCAL)/include/pari' '${pari}/include/pari'
