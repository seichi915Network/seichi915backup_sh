#!/bin/bash

readonly VERSION="1.0.0"

function usage {
cat <<_EOT_

Usage:
  seichi915backup.sh [options]

Options:
  -v    Show version.
  -h    Show help.
  -t    Specify the target directory.
  -d    Specify the destination directory.

_EOT_
}

while getopts vht:d: OPTION
do
  case $OPTION in
    v) 
      echo seichi915backup v$VERSION
      exit 0;;
    h)
      echo "
Usage:
  seichi915backup.sh [options]

Options:
  -v    Show version.
  -h    Show help.
  -t    Specify the target directory.
  -d    Specify the destination directory.

"
      exit 0;;
    t) target=$OPTARG;;
    d) destination=$OPTARG;;
  esac
done

if [ ! "${target:+foo}" ]; then
  echo Please specify the target.
  exit 1
fi

if [ ! "${destination:+foo}" ]; then
  echo Please specify the destination.
  exit 1
fi

if [ ! -d $target ] || [ ! -d $target ]; then
  echo The target does not exist or is not a directory.
  exit 1
fi

if [ ! -d $destination ] || [ ! -d $destination ]; then
  mkdir -p $destination
fi

while [ `ls $destination -1 | wc -l` -ge 15 ]
do
  rm -f $destination/`ls $destination -1 | sort | head -n 1`
done

file_name="$( echo `date "+%Y-%m-%d_%H-%M-%S"` ).tar.gz"

absolute_target_path=$( readlink -f $target )

cd $destination

tar -czvf $file_name `echo "${absolute_target_path}/*"`

