#!/bin/bash

# patterns
PTN1="^\."
PTN2="(\.c|\.h)"

# search gpj on ./a
for gpj in $(find ./a -type f | grep "gpj")
do
  # path relative from gpj to pj(./)
  GPJ_RELATIVE_PATH=$(realpath --relative-to=$(dirname ${gpj}) ./)
  echo ${GPJ_RELATIVE_PATH}
  # chk gpj file
  for line in $(cat ${gpj})
  do
    if echo ${line} | grep -Eq ${PTN2}; then :; else echo ${line}" is false"; fi
    echo ${line}
    # search src file on ./b
    file2=$(find ./b -type f | grep ${line##*/})
    echo ${file2}
    echo "### change path to ./b ###"
    echo ${file2} | sed -e 's,${PTN1},${GPJ_RELATIVE_PATH},g'
    echo ${file2//${PTN1}/${GPJ_RELATIVE_PATH}}
  done
done


echo "#######"
x=1234
echo $x | grep -E "^[0-9][0-9]*$" > /dev/null 2>&1
if [ $? -eq 0 ]; then echo "x is number"; else echo "x is not number"; fi
# if [ $? -eq 0 ]; then continue; fi
echo "abcde" | grep -q "abc" && echo "true"


echo "#######"

for file1 in $(find ./a -type f | grep "txt")
do 
  echo ${file1}
  file2=$(find ./b -type f | grep $(echo ${file1} | gawk -F/ '{print $NF}'))
  echo ${file2}
  realpath --relative-to=${file1} ./
done

F1=$(find  $(pwd) -type f -name "aaa.txt")
F2=$(find  $(pwd) -type f -name "bbb.txt")
RELATIVE_PATH=$(realpath --relative-to="$(dirname "$F1")" "$F2")
#RELATIVE_PATH=$(realpath -q $F1 $F2)
echo $RELATIVE_PATH
