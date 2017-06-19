#!/bin/bash

# ParseUrl Taken/Inspired By: https://stackoverflow.com/a/41161570
ParseUrl() {
    local query1 query2 path1 path2
    # extract the protocol
    proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
    if [[ ! -z $proto ]] ; then
            # remove the protocol
            url="$(echo ${1/$proto/})"
            # extract the user (if any)
            login="$(echo $url | grep @ | cut -d@ -f1)"
            # extract the host
            host="$(echo ${url/$login@/} | cut -d/ -f1)"
            # by request - try to extract the port
            port="$(echo $host | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
            # extract the uri (if any)
            resource="/$(echo $url | grep / | cut -d/ -f2-)"
    else
            url=""
            login=""
            host=""
            port=""
            resource=$1
    fi
    # extract the path (if any)
    path1="$(echo $resource | grep ? | cut -d? -f1 )"
    path2="$(echo $resource | grep \# | cut -d# -f1 )"
    path=$path1
    if [[ -z $path ]] ; then path=$path2 ; fi
    if [[ -z $path ]] ; then path=$resource ; fi
    # extract the query (if any)
    query1="$(echo $resource | grep ? | cut -d? -f2-)"
    query2="$(echo $query1 | grep \# | cut -d\# -f1 )"
    query=$query2
    if [[ -z $query ]] ; then query=$query1 ; fi
    # extract the fragment (if any)
    fragment="$(echo $resource | grep \# | cut -d\# -f2 )"
    # Globals
    # $url,$proto, $login, $host, $port, $resource, $path, $query, $fragment
}

# Main Mounter Logic
while IFS='' read -r line || [[ -n "$line" ]]; do
    ParseUrl $line
    up=`ping -c 1 $host | grep icmp* | wc -l`
    if [ $up = 1 ]; then
        mount=`mount | grep $resource | awk '{print $3}'`
        if [ "$mount" != "/Volumes${resource}" ]; then
            echo 'mount volume "'${line}'"'
            osascript -e 'mount volume "'${line}'"'
            echo "Mounted share ${resource}"
        fi
    else
        echo "Unable to mount share ${resource}"
    fi
done < "$HOME/.drive_mounter.conf"