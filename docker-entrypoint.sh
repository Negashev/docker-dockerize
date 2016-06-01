#!/bin/sh
# temp string
TEMP=""

mkdir $VOLUME
for_download() {
    appendHost=""
    if [ -n "${3}" ]; then
        appendHost="$3/"
    fi
    arr=$(echo $2 | tr ";" "\n")
    for x in $arr
    do
        # source filename without params
        source_filename_with_params=$(basename "$x")
        source_filename="${source_filename_with_params%%\?*}"
        # create exec string for download
        wget_cmd="wget -q --no-check-certificate -O /tmp/$1/$source_filename $appendHost$x"
        status=0
        for i in `seq 1 5`
        do
            echo $wget_cmd
            # run download
            `$wget_cmd`
            # check download
            if [ $? -ne 0 ]; then
                echo "try $i download template $appendHost$x"
                status=1
                continue
            else
                status=0
                break
            fi
        done
        if [ $status -ne 0 ]; then
            echo "can't download template $appendHost$x"
            exit 1
        fi
        # get generated file name
        filename=`echo "$source_filename" | sed -e 's/\(.tmpl\)*$//g'`
        # add to templates for dockerize
        TEMP="-template /tmp/$1/$source_filename:$1/$filename $TEMP"
    done
}

if [ -n "${DOCKERIZE_GET}" ]; then
    echo 'use $DOCKERIZE_GET'
    # get array from $DOCKERIZE_GET
    for_download $VOLUME $DOCKERIZE_GET
fi

arrE=$(echo `printenv | grep '^DH_'` | tr ";" "\n")
for e in $arrE
do
    # get folder=domainName for create
    folder_host="${e:3}"
    # get folder name
    folder="${folder_host%%\=*}"
    # get host
    host="${folder_host#$folder=}"
    # find folder=files for this folder
    f=`printenv | grep "DF_$folder="`
    # get folder=files for create
    folder_files="${f:3}"
    # get string 'file;file;file'
    files="${folder_files#$folder=}"
    # create folder
    this_foulder="$VOLUME/$folder"
    mkdir $this_foulder /tmp/$this_foulder
    # run download
    for_download $this_foulder $files $host
done
echo "$TEMP"
if [ "$TEMP" == "" ]; then
	echo "templates not ready or download"
	exit 1
fi
dockerize $TEMP $@
