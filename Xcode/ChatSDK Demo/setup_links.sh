#!/bin/bash
echo "Enter the relative path to the ChatSDK.podspec or leave blank to use the default path (../../)"
read path

adapterDir="ChatSDKFirebaseAdapter"
firebaseModulesDir="ChatSDKFirebase"
modulesDir="ChatSDKModules"

adapterPath="$adapterDir/Classes"

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
