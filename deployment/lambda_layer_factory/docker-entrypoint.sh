#!/bin/bash

echo "================================================================================"
echo "Installing the packages listed in requirements.txt:"
echo "================================================================================"
cat /packages/requirements.txt
pip3.8 install -q -r /packages/requirements.txt -t /packages/lambda_layer-python-3.8/python/lib/python3.8/site-packages
pip3.7 install -q -r /packages/requirements.txt -t /packages/lambda_layer-python-3.7/python/lib/python3.7/site-packages
pip3.6 install -q -r /packages/requirements.txt -t /packages/lambda_layer-python-3.6/python/lib/python3.6/site-packages

echo "================================================================================"
echo "Installing MediaInfo package"
echo "================================================================================"
VERSION="20.09"

echo "MediaInfo latest version = v$VERSION"
URL=https://mediaarea.net/download/binary/libmediainfo0/${VERSION}/MediaInfoLib_DLL_${VERSION}_Lambda.zip
echo "Downloading MediaInfo from $URL"
curl $URL -o mediainfo.zip || exit 1
unzip mediainfo.zip -d mediainfo
echo "Finished downloading MediaInfo library files:"
find ./mediainfo/lib/
cp ./mediainfo/lib/* /packages/lambda_layer-python-3.6/python/ || exit 1
cp ./mediainfo/lib/* /packages/lambda_layer-python-3.7/python/ || exit 1
cp ./mediainfo/lib/* /packages/lambda_layer-python-3.8/python/ || exit 1

echo "================================================================================"
echo "Creating zip files for Lambda layers"
echo "================================================================================"
cd /packages/lambda_layer-python-3.8/
zip -q -r /packages/lambda_layer-python3.8.zip .
cd /packages/lambda_layer-python-3.7/
zip -q -r /packages/lambda_layer-python3.7.zip .
cd /packages/lambda_layer-python-3.6/
zip -q -r /packages/lambda_layer-python3.6.zip .

# Clean up build environment
cd /packages/
rm -rf /packages/pymediainfo-3.7/
rm -rf /packages/pymediainfo-3.8/
rm -rf /packages/lambda_layer-python-3.8/
rm -rf /packages/lambda_layer-python-3.7/
rm -rf /packages/lambda_layer-python-3.6/

echo "Zip files have been saved to docker volume /data. You can copy them locally like this:"
echo "docker run --rm -it -v \$(pwd):/packages <docker_image>"
echo "================================================================================"

