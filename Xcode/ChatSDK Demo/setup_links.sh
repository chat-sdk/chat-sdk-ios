#!/bin/bash
echo "Enter the relative path to the ChatSDK.podspec or leave blank to use the default path (../../)"
read path

firebaseModulesDir="ChatSDKFirebase"

if [$path -eq ""] 
then
  path="../../"
fi

firebaseModulesPath="$path$firebaseModulesDir"

# Create a simlink to the Firebase modules path
echo "Creating simlink to $firebaseModulesPath"
ln -s $firebaseModulesPath ChatSDKFirebase

