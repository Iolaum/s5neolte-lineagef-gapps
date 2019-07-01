#!/bin/bash

# Custom pre-build script.

# Make changes necessary to include opengapps in image


file1="/srv/src/LINEAGE_15_1/device/samsung/s5neolte/device.mk"
#file1="/xtras/$USER/Repositories/zl1_custom_lineage/test.md"

if [ -f $file1 ]; then

    echo "Found $file1 file!"

    # bash, echo at file start: https://superuser.com/a/246841/644963
    echo 'GAPPS_VARIANT := nano' | cat - $file1 > $file1.tmp
    mv $file1.tmp $file1

    echo "\$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)" >> $file1
    echo "$file1 has been edited"

    else
    echo "Error: $file1 not found!"
    exit 1

fi
