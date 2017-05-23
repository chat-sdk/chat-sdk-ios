DIR="FirebaseFrameworks"

mkdir $DIR

touch $DIR/Cartfile
echo 'github "soheilbm/Firebase"' >> $DIR/Cartfile

(cd $DIR; carthage update)

cp -R $DIR/Carthage/Build/iOS/Firebase.framework ChatSDKFirebaseAdapter/Frameworks
cp -R $DIR/Carthage/Checkouts/Firebase/Source/Analytics/. ChatSDKFirebaseAdapter/Frameworks
cp -R $DIR/Carthage/Checkouts/Firebase/Source/Auth/. ChatSDKFirebaseAdapter/Frameworks
cp -R $DIR/Carthage/Checkouts/Firebase/Source/Database/. ChatSDKFirebaseAdapter/Frameworks
cp -R $DIR/Carthage/Checkouts/Firebase/Source/Storage/. ChatSDKFirebaseAdapter/Frameworks
cp -R $DIR/Carthage/Checkouts/Firebase/Source/AdMob/. ChatSDKFirebaseAdapter/Frameworks
#cp -R $DIR/Carthage/Checkouts/Firebase/Source/AppIndexing/. ChatSDKFirebaseAdapter/Frameworks

rm -r $DIR