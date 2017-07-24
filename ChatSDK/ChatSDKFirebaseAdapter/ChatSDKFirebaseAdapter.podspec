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
  s.default_subspecs = 'FirebaseAdapter'

  s.source_files = ['Classes/**/*']
    
  s.frameworks = 'CoreData', 'SystemConfiguration', 'Security', 'MobileCoreServices', 'CFNetwork', 'MessageUI', 'Accounts', 'Social', 'CoreLocation', 'AddressBook', 'AdSupport'
  s.library = 'icucore', 'c++', 'sqlite3'

  s.subspec 'FirebaseAdapter' do |fi| 

    fi.pod_target_xcconfig = { 
      "ENABLE_BITCODE" => 'false'
    }
  
    fi.dependency 'ChatSDKCore'  
    fi.dependency 'ChatSDKFirebaseAdapter/FirebaseFrameworks'

  end

  s.subspec 'FirebaseFrameworks' do |ff| 
  
    ff.dependency 'GTMSessionFetcher', '~>1.1'
    ff.dependency 'GoogleToolboxForMac/NSData+zlib', '~>2.1.1'
  
    ff.vendored_frameworks = "FirebaseFrameworks/*"

    # Import the Firebase frameworks to the main project (gets rid of missing header errors)
    ff.user_target_xcconfig = {
      "FRAMEWORK_SEARCH_PATHS" => '"${PODS_ROOT}/../../ChatSDK/ChatSDKFirebaseAdapter/FirebaseFrameworks"'
    }

  end

  s.subspec 'SocialFrameworks' do |sf| 
    
    sf.vendored_frameworks = "SocialFrameworks/*.framework"
 
    sf.dependency "GTMOAuth2", "~> 1.0"
    sf.dependency "GTMSessionFetcher/Core", "~> 1.1"
    sf.dependency "GoogleToolboxForMac/NSDictionary+URLArguments", "~> 2.1"
    sf.dependency "GoogleToolboxForMac/NSString+URLArguments", "~> 2.1"

 
#     authbase.resource_bundle = {
#       'GoolgeSignIn' => ['SocialFrameworks/*.framework']
#     }


    # Import the Firebase frameworks to the main project (gets rid of missing header errors)
#     sf.user_target_xcconfig = {
#       "FRAMEWORK_SEARCH_PATHS" => '"${PODS_ROOT}/../../ChatSDK/ChatSDKFirebaseAdapter/Frameworks"'
#     }

  end

  s.subspec 'AuthBase' do |authbase|
    authbase.source_files = "FirebaseAuthUI/**/*.{h,m}"
    authbase.resource_bundle = {
      'FirebaseAuthUI' => ['FirebaseAuthUI/Strings/**/*',
                           'FirebaseAuthUI/Resources/**/*',
                           'FirebaseAuthUI/**/*.xib']
    }
    authbase.dependency 'ChatSDKFirebaseAdapter/FirebaseFrameworks'

  end
      
  s.subspec 'Phone' do |phone|
    phone.source_files = "FirebasePhoneAuthUI/**/*.{h,m}"
    phone.resource_bundle = {
      'FirebasePhoneAuthUI' => ['FirebasePhoneAuthUI/Strings/**/*',
                                'FirebasePhoneAuthUI/Resources/**/*',
                                'FirebasePhoneAuthUI/**/*.xib']
    }
    phone.dependency 'ChatSDKFirebaseAdapter/AuthBase'
  end
  
  s.subspec 'Database' do |database|
    database.source_files = "FirebaseDatabaseUI/**/*.{h,m}"
    database.dependency 'ChatSDKFirebaseAdapter/FirebaseFrameworks'
#     database.dependency 'Firebase/Database'
#     database.ios.framework = 'FirebaseDatabase'
#     database.xcconfig  = { 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/FirebaseDatabase/Frameworks"','HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/Firebase/**"' }
  end
  
  s.subspec 'Facebook' do |facebook|
    facebook.source_files = "FirebaseFacebookAuthUI/**/*.{h,m}"
    facebook.resource_bundle = {
      'FirebaseFacebookAuthUI' => ['FirebaseFacebookAuthUI/Strings/**/*',
                                   'FirebaseFacebookAuthUI/Resources/**/*',
                                   'FirebaseFacebookAuthUI/**/*.xib']
    }
    facebook.dependency 'ChatSDKFirebaseAdapter/AuthBase'
    facebook.dependency 'FBSDKLoginKit', '~> 4.0'
  end

  s.subspec 'Google' do |google|
    google.source_files = "FirebaseGoogleAuthUI/**/*.{h,m}"
    google.resource_bundle = {
      'FirebaseGoogleAuthUI' => ['FirebaseGoogleAuthUI/Strings/**/*',
                                 'FirebaseGoogleAuthUI/Resources/**/*',
                                 'FirebaseGoogleAuthUI/**/*.xib']
    }
    google.dependency 'ChatSDKFirebaseAdapter/AuthBase'
     google.dependency 'ChatSDKFirebaseAdapter/SocialFrameworks'
#     google.dependency 'GoogleSignIn', '~> 4.0'
  end

  s.subspec 'Storage' do |storage|
    storage.source_files = "FirebaseStorageUI/**/*.{h,m}"
    storage.dependency 'ChatSDKFirebaseAdapter/FirebaseFrameworks'
    storage.dependency 'SDWebImage'
  end

  s.subspec 'Twitter' do |twitter|
    twitter.source_files = "FirebaseTwitterAuthUI/*.{h,m}"
    twitter.resource_bundle = {
      'FirebaseTwitterAuthUI' => ['FirebaseTwitterAuthUI/Strings/**/*',
                                  'FirebaseTwitterAuthUI/Resources/**/*',
                                  'FirebaseTwitterAuthUI/**/*.xib']
    }
    twitter.dependency 'ChatSDKFirebaseAdapter/AuthBase'
#     twitter.dependency 'TwitterKit', '~> 2.4'
     twitter.dependency 'ChatSDKFirebaseAdapter/SocialFrameworks'
    twitter.pod_target_xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PROJECT_DIR)/TwitterCore/iOS"' }
  end



     
end
