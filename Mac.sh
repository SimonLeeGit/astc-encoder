#!/bin/bash

SOURCE_LOCATION=`cd $(pwd); pwd`
BUILD_LOCATION="$(pwd)/build_mac"

rm -rf $BUILD_LOCATION
mkdir $BUILD_LOCATION
pushd $BUILD_LOCATION


echo Configuring Release build
cmake -G "Unix Makefiles" $SOURCE_LOCATION -DASTCENC_CLI=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15

echo Building for Release...
cmake --build ./ --target astcenc

LIB_LOCATION="$SOURCE_LOCATION/bin/Mac/Release"
rm -rf $LIB_LOCATION
mkdir -p $LIB_LOCATION

echo Copying astcenc to $LIB_LOCATION
cp -f $BUILD_LOCATION/Source/astcenc $LIB_LOCATION
cp -f $BUILD_LOCATION/Source/astcenc-* $LIB_LOCATION


echo Configuring Debug build
cmake -G "Unix Makefiles" $SOURCE_LOCATION -DASTCENC_CLI=ON -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15

echo Building for Debug...
cmake --build ./ --target astcenc

LIB_LOCATION="$SOURCE_LOCATION/bin/Mac/Debug"
rm -rf $LIB_LOCATION
mkdir -p $LIB_LOCATION

echo Copying astcenc to $LIB_LOCATION
cp -f $BUILD_LOCATION/Source/astcenc $LIB_LOCATION
cp -f $BUILD_LOCATION/Source/astcenc-* $LIB_LOCATION

popd

rm -rf $BUILD_LOCATION

echo Done.