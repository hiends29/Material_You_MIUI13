#!/bin/bash

recp="java -jar bin/apktool.jar"

if [[ -d apk_out ]]; then
	rm -rf apk_out/*
else mkdir apk_out
fi

$recp if bin/*apk

for i in $(ls source); do
	echo "Recomplie : $i"
	$recp b source/$i -o "apk_out/$i.apk"
	if [[ -f "apk_out/$i.apk" ]]; then
		echo "Signing : $i"
		apksigner sign --ks bin/miuivs --ks-pass pass:linkcute "apk_out/$i.apk"
		rm -rf "apk_out/$i.apk.idsig"
	else
		echo "$i : Failure"
	fi
done

if [ -z "$(ls -A apk_out)" ]; then
   echo "Empty output"
else
   echo "Making magisk module"
   sudo chmod -R 755 module/system/product/overlay/
   sudo cp -rf apk_out/. module/system/product/overlay/
   sudo sed -i "s@abcxyz@$(date +"%H%M%d%m")@g" module/module.prop
   sudo 7za a -tzip "$1_$(date +"%H%M%d%m")_MTYM13.zip" module/.
fi


