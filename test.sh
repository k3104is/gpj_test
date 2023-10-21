#!/bin/bash

# comparison dir
DIR1="./a"
DIR2="./b"

# patterns
PTN1="^\."
MATCH_PTN="^.*(\.c|\.h|\.txt) *$"
MISMATCH_PTN="^.*(cfg|integ).*$"

# search gpj on ./a
for gpj in $(find ${DIR1} -type f | grep -E "gpj$")
do
  # create gpj.bak on same dir
  DIR_GPJBAK="${gpj%/*}/gpj.bak"
  rm ${DIR_GPJBAK} > /dev/null 2>&1
  touch ${DIR_GPJBAK}

  # path relative from gpj to pj(./)
  GPJ_RELATIVE_PATH=$(realpath --relative-to=$(dirname ${gpj}) ./)
  echo ${GPJ_RELATIVE_PATH}

  # expand gpj file
  for line in $(cat ${gpj})
  do
    # extract .c/.h/.txt
    # if echo ${line} | grep -Eq ${PTN2}; 
    if [[ ${line} =~ ${MATCH_PTN} && ! ${line} =~ ${MISMATCH_PTN} ]] 
    then
      :
    else
      echo ${line} >> ${DIR_GPJBAK}
      continue
    fi

    # search src file on ./b
    file=$(find ${DIR2} -type f | grep ${line##*/})
    # found
    if [ -n "${file}" ];
    then 
      echo ${file/./${GPJ_RELATIVE_PATH}} >> ${DIR_GPJBAK}
    # not found
    else
      echo "\`${line}\` is not found" >> ${DIR_GPJBAK}
    fi
  done
  echo "### cat ${DIR_GPJBAK} ###"
  cat ${DIR_GPJBAK}
  rm ${DIR_GPJBAK} > /dev/null 2>&1

done
