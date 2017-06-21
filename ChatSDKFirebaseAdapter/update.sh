wget -O Firebase.zip "https://firebase.google.com/download/ios"

unzip Firebase.zip

cp -rf Firebase/AdMob/GoogleMobileAds.framework Frameworks
cp -rf Firebase/Analytics/FirebaseAnalytics.framework Frameworks
cp -rf Firebase/Analytics/FirebaseCore.framework Frameworks
cp -rf Firebase/Analytics/FirebaseInstanceID.framework Frameworks
cp -rf Firebase/Auth/FirebaseAuth.framework Frameworks
cp -rf Firebase/Storage/FirebaseStorage.framework Frameworks
cp -rf Firebase/Messaging/FirebaseMessaging.framework Frameworks
cp -rf Firebase/Messaging/Protobuf.framework Frameworks

rm -rf Firebase
rm Firebase.zip
