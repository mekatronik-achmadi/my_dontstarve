#!/bin/bash

cd mod_publish_data_file/
ls > ../filelist.txt

cd ..
mkdir -vp correctfolder/
for i in `cat filelist.txt`;do
	install -vDm644 mod_publish_data_file/$i correctfolder/$(echo $i  | tr '\\' '/')
done

rm -vf filelist.txt
