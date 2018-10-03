#!/bin/bash
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
PWD=/home/packages
file="/home/packages/prodlatestbuild.txt"
echo $PWD
if [ -f "$file" ]
then
        echo "$file found."
    aws s3api get-object --bucket sandboxworms-packages-92618 --key staging/latestbuild.txt myprodlatestbuild.txt
    result=$(diff prodlatestbuild.txt myprodlatestbuild.txt)
    if [ $? -eq 0 ]
    then
            echo "files are the same"
            exit 1
    else
            echo "files are different"
            value=$(<myprodlatestbuild.txt)
            echo "$value"
            aws s3api get-object --bucket sandboxworms-packages-92618 --key staging/"$value" "$value"
            rm prodlatestbuild.txt
            mv myprodlatestbuild.txt prodlatestbuild.txt
    fi
else
        aws s3api get-object --bucket sandboxworms-packages-92618 --key staging/latestbuild.txt prodlatestbuild.txt
        value=$(<prodlatestbuild.txt)
        echo "$value"
        aws s3api get-object --bucket sandboxworms-packages-92618 --key staging/"$value" "$value"
fi

sudo tar -xzf "$value" -C /var/www/vhosts/prod_sandboxworms
