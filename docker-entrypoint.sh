#!/bin/sh
# temp string
TEMP=""
mkdir $VOLUME
if [ -n "${DOCKERIZE_GET}" ]; then
    echo 'use $DOCKERIZE_GET'

    # get array from $DOCKERIZE_GET
    arr=$(echo $DOCKERIZE_GET | tr ";" "\n")
    for x in $arr
    do
        # create exec string for download
        wget_cmd="wget -q --no-check-certificate --directory-prefix=$VOLUME/ $x"

        echo $wget_cmd
        # run download
        `$wget_cmd`
        # get source file name
        source_filename=$(basename "$x")
        # get generated file name
        filename=`echo "$source_filename" | sed -e 's/\(.tmpl\)*$//g'`
        # add to templates for dockerize
        TEMP="-template $VOLUME/$source_filename:$VOLUME/$filename $TEMP"
    done
fi
dockerize $TEMP $@