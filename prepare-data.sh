#!/usr/bin/env bash

# get the output directory from $1, if not given, defaults to ./prepared-data
OUTPUT_DIR=${1:-prepared-data}

# The URL to the tar file
DATAURL="https://ftp.ncbi.nlm.nih.gov/geo/series/GSE144nnn/GSE144469/suppl/GSE144469_RAW.tar"
ABTCRURL="https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE144469&format=file&file=GSE144469%5FTCR%5Ffiltered%5Fcontig%5Fannotations%5Fall%2Ecsv%2Egz"
REFURL="https://zenodo.org/records/7779017/files/pbmc_multimodal_2023.rds?download=1"
# DATASHA="8aebf418433603d710df0c3652c616719f8d21c0"
DATAFILE="$OUTPUT_DIR/GSE144469.tar"
ABTCRFILE="$OUTPUT_DIR/abTCR.csv.gz"
SAMPLES="C1 C2 C3 C4 CT1 CT2 CT3 CT4 NC1 NC2 NC3 NC4"

echo "- Making the directory for prepared data ..."
mkdir -p "$OUTPUT_DIR"

echo "- Downloading the data if needed ..."
# if [ ! -e $DATAFILE ] || [ "$(shasum $DATAFILE | cut -d' ' -f1)" != "$DATASHA" ]; then
if [ ! -e "$DATAFILE" ]; then
    wget -q -O "$DATAFILE" $DATAURL
fi

echo "- Extracting the data ..."
tar -xvf "$DATAFILE" --directory="$OUTPUT_DIR"

echo "- Preparing RNA-seq data ..."
# shellcheck disable=SC2045
for file in $(ls -1b "$OUTPUT_DIR"/GSM*CD3-*.tar.gz); do
    sample=$(basename "$file" | cut -d- -f1 | cut -d_ -f2)
    # only keep the samples we are interested in
    # shellcheck disable=SC2076
    if [[ ! " $SAMPLES " =~ " $sample " ]]; then
        continue
    fi
    mkdir -p "$OUTPUT_DIR"/"$sample"
    tar -zxf "$file" -C "$OUTPUT_DIR"/"$sample" --strip-components=2
done

echo "- Downloading alpha-beta TCR-seq data ..."
wget -q -O "$ABTCRFILE" "$ABTCRURL"
for sample in $(zcat "$ABTCRFILE"  | grep -v barcode | cut -d, -f2 | cut -d- -f2 | sort -u); do
    # shellcheck disable=SC2076
    if [[ ! " $SAMPLES " =~ " $sample " ]]; then
        continue
    fi
    zcat "$ABTCRFILE" | head -n1 > "$OUTPUT_DIR"/"$sample"/filtered_contig_annotations.csv
    zcat "$ABTCRFILE" | grep "\-$sample," | sed "s/-$sample,/-1,/" >> "$OUTPUT_DIR"/"$sample"/filtered_contig_annotations.csv
done

echo "- Downloading seurat reference ..."
if [ ! -e "$OUTPUT_DIR"/pbmc_multimodal_2023.rds ]; then
    wget -q --no-check-certificate -O "$OUTPUT_DIR"/pbmc_multimodal_2023.rds "$REFURL"
fi

echo "- Removing unnecessary files ..."
rm -rf "$OUTPUT_DIR"/*.gz

echo "- Done!"
