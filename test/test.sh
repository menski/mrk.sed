#!/bin/bash

if [ $(basename $(pwd)) != "test" ]; then
  cd test/
fi

for txt in *.txt
do
  filename=$(basename $txt)
  testname=${filename%.*}
  echo "Running test '$testname'"
  ../mrk.sed $testname.txt | diff -y --suppress-common-lines - $testname.html
  if [ $? -eq 0 ]; then
    echo " passed"
  fi
done
