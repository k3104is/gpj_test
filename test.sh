#!/bin/bash
for gpj in $(find ./a -type f | grep "gpj")
do
  GPJ_RELATIVE_PATH=$(realpath --relative-to=$(dirname ${gpj}) ./)
  echo ${GPJ_RELATIVE_PATH}
  for line in $(cat ${gpj})
  do
    echo ${line}
    file2=$(find ./b -type f | grep $(echo ${line} | gawk -F/ '{print $NF}'))
    echo ${file2}
  done
done


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
