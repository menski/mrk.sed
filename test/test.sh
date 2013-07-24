#!/bin/bash

if [ $(basename $(pwd)) != "test" ]; then
  cd test/
fi

if [ -e ../mrk.sed ]; then
  mrk='sed -nf ../mrk.sed'
else
  echo "Unable to find mrk.sed" >&2
  exit 1
fi

for txt in *.txt
do
  filename=$(basename $txt)
  testname=${filename%.*}
  echo "Running test '$testname'"
  $mrk $testname.txt | diff -y --suppress-common-lines - $testname.html
  if [ $? -eq 0 ]; then
    echo " passed"
  fi
done
