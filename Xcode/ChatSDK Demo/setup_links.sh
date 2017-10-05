#!/bin/bash
echo "Enter the path to the ChatSDK folder or leave blank to use the default path (../../)"
read path

adapterDir="ChatSDKFirebaseAdapter"
chatDir="ChatSDK"
firebaseModulesDir="ChatSDKFirebase"
modulesDir="ChatSDKModules"

adapterPath="$chatDir/$adapterDir/Classes"

rm $adapterDir

if [$path -eq ""] 
then
  path="../../"
fi
chatPath="$path$adapterPath"
firebaseModulesPath="$path$firebaseModulesDir"
modulesPath="$path$modulesDir"

echo "Creating simlink to $chatPath"
ln -s $chatPath ChatSDKFirebaseAdapter

# Create a simlink to the Firebase modules path
echo "Creating simlink to $firebaseModulesPath"
ln -s $firebaseModulesPath ChatSDKFirebase

# Create a simlink to the modules path
echo "Creating simlink to $modulesPath"
ln -s $modulesPath ChatSDKModules
