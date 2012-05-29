#!/usr/bin/env bash

perl=perl
$perl -v

rm -rf MANIFEST.bak MANIFEST Makefile.old && \
echo > '_.tar.gz' && \
pod2text perl.pm.PL > README && \
$perl -i -lpne 's{^\s+$}{};s{^    ((?: {8})+)}{" "x(4+length($1)/2)}se;' README && \
$perl Makefile.PL && \
rm *.tar.gz && \
make manifest && \
$perl -i -lne 'print unless /(?:\.tar\.gz$|^.git|^dist|^tmp|uploads\.rdf)/' MANIFEST && \
make clean && \
$perl Makefile.PL && \
make && \
TEST_AUTHOR=1 make test && \
make disttest && \
make dist && \
cp -f *.tar.gz dist/ && \
make clean && \
rm -rf MANIFEST.bak Makefile.old && \
echo "All is OK"
