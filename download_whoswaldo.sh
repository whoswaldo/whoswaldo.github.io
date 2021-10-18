if [ ! -f ./whoswaldo_signatures.csv ]; then
    echo "whoswaldo_signatures.csv not found in current directory! Please request permission before downloading this dataset."
    exit
fi

# Make parent data directory
mkdir whos_waldo

# Download dataset splits
mkdir whos_waldo/splits
for split in train.txt val.json test.json
    do curl -o whos_waldo/splits/${split} "https://whoswaldo.s3.amazonaws.com/release/splits/${split}"
done

# Download tar archives
while IFS=, read -r i key sig exp;
    do curl -o whos_waldo_${i}.tar "https://whoswaldo.s3.amazonaws.com/release/whos_waldo_${i}.tar?AWSAccessKeyId=${key}&Signature=${sig}&Expires=${exp}";
done < whoswaldo_signatures.csv

# Extract the dataset, deleting archives
for i in {0..5}; do
    tar xf whos_waldo_${i}.tar;
    rm whos_waldo_${i}.tar;
done
