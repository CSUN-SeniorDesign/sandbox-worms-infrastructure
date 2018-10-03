#!/bin/bash
PWD=/home/packages
file="/home/packages/latestbuild.txt"
echo $PWD
if [ -f "$file" ]
then
        echo "$file found."
    aws s3api get-object --bucket sandboxworms-packages-92618 --key staging/latestbuild.txt mylatestbuild.txt
    result=$(diff latestbuild.txt mylatestbuild.txt)
    if [ $? -eq 0 ]
    then
            echo "files are the same"
            exit 1
    else
            echo "files are different"
            value=$(<mylatestbuild.txt)
            echo "$value"
            aws s3api get-object --bucket sandboxworms-packages-92618 --key staging/"$value" "$value"
            rm latestbuild.txt
            mv mylatestbuild.txt latestbuild.txt
    fi
else
        aws s3api get-object --bucket sandboxworms-packages-92618 --key staging/latestbuild.txt latestbuild.txt
        value=$(<latestbuild.txt)
        echo "$value"
        aws s3api get-object --bucket sandboxworms-packages-92618 --key staging/"$value" "$value"
fi

sudo tar -xzf "$value" -C /var/www/vhosts/staging_sandboxworms
