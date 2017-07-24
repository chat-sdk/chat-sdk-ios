wget -O Firebase.zip "https://firebase.google.com/download/ios"

unzip Firebase.zip

cp -rf Firebase/AdMob/GoogleMobileAds.framework FirebaseFrameworks
cp -rf Firebase/Analytics/FirebaseAnalytics.framework FirebaseFrameworks
cp -rf Firebase/Analytics/FirebaseCore.framework FirebaseFrameworks
cp -rf Firebase/Analytics/FirebaseInstanceID.framework FirebaseFrameworks
cp -rf Firebase/Auth/FirebaseAuth.framework FirebaseFrameworks
cp -rf Firebase/Storage/FirebaseStorage.framework FirebaseFrameworks
cp -rf Firebase/Messaging/FirebaseMessaging.framework FirebaseFrameworks
cp -rf Firebase/Messaging/Protobuf.framework FirebaseFrameworks

rm -rf Firebase
rm Firebase.zip
