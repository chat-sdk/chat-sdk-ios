Pod::Spec.new do |s|
  s.name             = "ChatSDKFirebaseAdapter"
  s.version          = "4.2.5"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'MIT'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = ['Classes/**/*']
    
  s.frameworks = 'CoreData', 'SystemConfiguration', 'Security', 'MobileCoreServices', 'CFNetwork', 'MessageUI', 'Accounts', 'Social', 'CoreLocation', 'AddressBook', 'AdSupport'
    
  # Maybe we can bring this back at some point but currently (03/17) Firebase pod is broken with use_frameworks! flag
  #s.dependency 'Facebook-iOS-SDK', '~>4.1.0'

#   s.dependency 'Firebase/Core'
#   s.dependency 'Firebase/Database'
#   s.dependency 'Firebase/Storage'
#   s.dependency 'Firebase/Auth'
#   s.dependency 'Firebase/Messaging'
  
#      s.pod_target_xcconfig = { 
#	    "ALWAYS_SEARCH_USER_PATHS" => 'NO',
#         "OTHER_LDFLAGS" => '$(inherited) -framework "FirebaseDatabase" -framework "FirebaseCore" -framework "FirebaseAuth" -framework "FirebaseStorage" -framework "FirebaseInstanceID" -framework "FirebaseAnalytics" -framework "FirebaseDatabase"', 
#         "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => 'YES',
###         "HEADER_SEARCH_PATHS" => '$(inherited) "${PODS_ROOT}/FirebaseAuth/Frameworks" "${PODS_ROOT}/FirebaseCore/Frameworks" "${PODS_ROOT}/FirebaseDatabase/Frameworks" "${PODS_ROOT}/FirebaseInstanceID/Frameworks" "${PODS_ROOT}/FirebaseStorage/Frameworks" "${PODS_ROOT}/FirebaseAnalytics/Frameworks"' 
#         "FRAMEWORK_SEARCH_PATHS" => '$(inherited) "${PODS_ROOT}/FirebaseAuth/Frameworks" "${PODS_ROOT}/FirebaseCore/Frameworks" "${PODS_ROOT}/FirebaseDatabase/Frameworks" "${PODS_ROOT}/FirebaseInstanceID/Frameworks" "${PODS_ROOT}/FirebaseStorage/Frameworks" "${PODS_ROOT}/FirebaseAnalytics/Frameworks"' 
#	}


  # Needed otherwise we get runtime errors (http://stackoverflow.com/questions/39617804/firebase-analytics-is-not-avaible)
#   s.pod_target_xcconfig = { 
#       "OTHER_LDFLAGS" => '-ObjC' "ENABLE_BITCODE" => 'false'
#   }
  s.pod_target_xcconfig = { 
      "ENABLE_BITCODE" => 'false'
  }
  
  
  # Import the Firebase frameworks to the main project (gets rid of missing header errors)
  s.user_target_xcconfig = {
      "FRAMEWORK_SEARCH_PATHS" => '"${PODS_ROOT}/../../ChatSDK/ChatSDKFirebaseAdapter/Frameworks"'
  }

  #s.dependency 'Google/SignIn', '~> 3.0'
  #s.dependency 'TwitterKit', '~>1.12'
  s.dependency 'ChatSDKCore'  
    
  
  s.dependency 'GTMSessionFetcher', '~>1.1'
  s.dependency 'GoogleToolboxForMac', '~>2.1.1'
  
  s.vendored_frameworks = "Frameworks/*"
      
  s.library = 'icucore', 'c++', 'sqlite3'
     
end
