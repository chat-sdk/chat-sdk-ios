firebasePath="../../ChatSDK/ChatSDKFirebase"
modulePath="../../ChatSDK/ChatSDKModules"

rm "ChatSDKFirebase/AudioMessage"
rm "ChatSDKFirebase/Blocking"
rm "ChatSDKFirebase/Broadcast"
rm "ChatSDKFirebase/ContactBook"
rm "ChatSDKFirebase/NearbyUsers"
rm "ChatSDKFirebase/ReadReceipts"
rm "ChatSDKFirebase/FirebaseSocialLogin"
rm "ChatSDKFirebase/TypingIndicator"
rm "ChatSDKFirebase/VideoMessage"

# rm "ChatSDKModules/KeyboardOverlayOptions"
# rm "ChatSDKModules/StickerMessages"

#rm "ChatSDKFirebase/FileStorage"
#rm "ChatSDKFirebase/PushNotifications"
#rm "ChatSDKFirebase/PushAndFileStorage"

echo "$firebasePath/AudioMessage"

ln -s "$firebasePath/AudioMessage" "ChatSDKFirebase/AudioMessage"
ln -s "$firebasePath/Blocking" "ChatSDKFirebase/Blocking"
ln -s "$firebasePath/Broadcast" "ChatSDKFirebase/Broadcast"
ln -s "$firebasePath/ContactBook" "ChatSDKFirebase/ContactBook"
ln -s "$firebasePath/NearbyUsers" "ChatSDKFirebase/NearbyUsers"
ln -s "$firebasePath/ReadReceipts" "ChatSDKFirebase/ReadReceipts"
ln -s "$firebasePath/FirebaseSocialLogin" "ChatSDKFirebase/FirebaseSocialLogin"
ln -s "$firebasePath/TypingIndicator" "ChatSDKFirebase/TypingIndicator"
ln -s "$firebasePath/VideoMessage" "ChatSDKFirebase/VideoMessage"

ln -s "$firebasePath/FirebaseFileStorage" "ChatSDKFirebase/FirebaseFileStorage"
ln -s "$firebasePath/FirebasePush" "ChatSDKFirebase/FirebasePush"
 
# ln -s "$modulePath/KeyboardOverlayOptions" "ChatSDKModules/KeyboardOverlayOptions"
# ln -s "$modulePath/StickerMessages" "ChatSDKModules/StickerMessage"
