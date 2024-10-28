#!/bin/bash
# Do everything we need to run mriqc
# 2024-10-25 Nate Vack <njvack@wisc.edu>

set -x

CPUS=4
MEM=16G

S=/staging/groups/waisman_chm/
sub=$1

mkdir -p bids
mkdir -p mriqc
mkdir -p $S/mriqc

echo "Copying..."
cp "$S/bids_subjects/${sub}.tar" .
echo "Untarring ${sub}.tar"
tar xvf "${sub}.tar" -C bids
echo "Unzipping data..."
find bids -name "*gz" -print -exec gunzip {} \;
echo "Deleting DWI scans"
rm -rfv bids/sub*/*/dwi
echo "Removing ${sub}.tar"
rm "${sub}.tar"

mriqc -w tmp/mriqc \
  --nprocs $CPUS \
  --mem $MEM \
  --float32 \
  --notrack \
  bids mriqc participant

echo "Cleaning up tmp..."
rm -r tmp/mriqc*

echo "Cleaning up input..."
rm -r bids

echo "Bundling output..."
tar cvf ${sub}_mriqc.tar -C mriqc .
echo "Moving output to staging..."
mv ${sub}_mriqc.tar $S/mriqc

echo "Cleaning up output..."
rm *tar
rm -r mriqc
