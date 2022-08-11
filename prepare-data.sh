#!/usr/bin/env bash

# The URL to the tar file
DATAURL="https://ftp.ncbi.nlm.nih.gov/geo/series/GSE139nnn/GSE139555/suppl/GSE139555_RAW.tar"
DATASHA="8aebf418433603d710df0c3652c616719f8d21c0"
DATAFILE="prepared-data/GSE139555.tar"

echo "- Make the directory for prepared data ..."
mkdir -p prepared-data

echo "- Download the data if needed ..."
if [ ! -e $DATAFILE ] || [ "$(shasum $DATAFILE)" != "$DATASHA" ]; then
    wget -O $DATAFILE $DATAURL
fi

echo "- Extract the data ..."
tar -xvf $DATAFILE --directory=./prepared-data

echo "- Separate desired samples ..."
for sample in lt1 lt2 lt3 lt4 lt5 lt6 ln1 ln2 ln3 ln4 ln5 ln6; do
    mkdir -p prepared-data/${sample^^}
    mv prepared-data/*-$sample.*.gz prepared-data/${sample^^}/
done

echo "- Remove unnecessary files ..."
rm -rf prepared-data/*.gz

echo "- Done!"
