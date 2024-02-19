#!/bin/bash

grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | sort | uniq | cut -d '"' -f 2 | sed "s#.*/##" | sort > odp.txt

cut -d " " -f 1,7,9 cdlinux.www.log | grep '200$' | sort | uniq | cut -d " " -f 2 | sed "s#.*/##" | sort >> odp.txt

sort -n odp.txt | uniq -c | sort -n | grep '.iso$'
