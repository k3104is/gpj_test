#!/bin/bash

# comparison dir
DIR1="./a"
DIR2="./b"

# patterns
PTN1="^\.\/"
MATCH_PTN="^.*(\-I.*)|((\.c|\.h|\.txt) *)$"
MISMATCH_PTN="^.*(cfg|integ).*$"

#func
relative_dir_func() {

  file1=$1
  file2=$2

  # ファイル1とファイル2のディレクトリパスを取得
  file1_dir=$(dirname "$file1")
  file2_dir=$(dirname "$file2")

  # ディレクトリパスが同じ場合
  if [ "$file1_dir" = "$file2_dir" ]; then
      relative_path="./$(basename "$file2")"
  else
      # ファイル2のディレクトリからファイル1のディレクトリへの相対パスを計算
      relative_path=""
      common_part=""
      while [ "${file1_dir#$file2_dir/}" != "$file1_dir" ]; do
          file1_dir="${file1_dir%/*}"
          common_part="${common_part}../"
      done
      relative_path="${common_part}""${file2}"
  fi

  echo ${relative_path}
}

# main
# search gpj on ./a
for gpj in $(find "${DIR1}" -type f | grep -E "gpj$")
do
  # create gpj.bak on same dir
  DIR_GPJBAK="${gpj%/*}/gpj.bak"
  rm "${DIR_GPJBAK}" > /dev/null 2>&1
  touch "${DIR_GPJBAK}"

  # path relative from gpj to pj(./)
  # GPJ_RELATIVE_PATH=$(realpath --relative-to=$(dirname ${gpj}) ./)
  file_dir=$(relative_dir_func "${gpj}" "./")
  GPJ_RELATIVE_PATH="${file_dir%/./}"
  echo ${GPJ_RELATIVE_PATH}
  # expand gpj file
  # for line in $(cat "${gpj}")
  while read line;
  do
    # if include mismatch, skip
    if [[ ! "${line}" =~ ${MATCH_PTN} || "${line}" =~ ${MISMATCH_PTN} ]] 
    then
      echo "${line}" >> ${DIR_GPJBAK}
      continue
    fi

    # create dir
    if [[ "${line}" =~ "-I" ]];
    then
      # :
      echo "${line%%I*}I ${GPJ_RELATIVE_PATH}${DIR2#.}${line#*.}" >> "${DIR_GPJBAK}"
    else
      echo "${GPJ_RELATIVE_PATH}${DIR2#.}${line#.}" >> "${DIR_GPJBAK}"
    fi
    # # search src file on ./b
    # file=$(find ${DIR2} -type f | grep ${line##*/})
    # # found
    # if [ -n "${file}" ];
    # then 
    #   echo ${file/./${GPJ_RELATIVE_PATH}} >> ${DIR_GPJBAK}
    #   echo "${GPJ_RELATIVE_PATH}"${DIR2#.}"${line#.}" >> ${DIR_GPJBAK}
    # # not found
    # else
    #   echo "\`${line}\` is not found" >> ${DIR_GPJBAK}
    # fi
  # done
  done < <(cat "${gpj}")

  echo "### cat ${DIR_GPJBAK} ###"
  cat "${DIR_GPJBAK}"
  rm "${DIR_GPJBAK}" > /dev/null 2>&1

done


