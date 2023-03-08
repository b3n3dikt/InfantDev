site=$1
sub=$2
session=$3
path2add2json=$4
pushd /site-${site}/sub-${sub}/ses-${session}
fileLength=$(wc -l sub-${sub}_ses-${session}_T1w.json | cut -d' ' -f1);
head -$((fileLength-1)) sub-${sub}_ses-${session}_T1w.json > temp.json
endvar=`tail -n 1 temp.json
sed -i -e "s|${endvar}|${endvar},|g" temp.json
cat temp.json ${path2add2json}/add2json.json > final.json
mv final.json sub-${sub}_ses-${session}_T1w.json
rm temp.json
popd