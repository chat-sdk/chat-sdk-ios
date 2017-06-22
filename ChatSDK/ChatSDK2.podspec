Pod::Spec.new do |s|
  s.name             = "ChatSDK"
  s.version          = "4.2.5"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'MIT'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.frameworks = 'CoreData', 'SystemConfiguration', 'Security', 'MobileCoreServices', 'CFNetwork', 'MessageUI', 'Accounts', 'Social', 'CoreLocation', 'AddressBook', 'AdSupport'

  s.pod_target_xcconfig = { 
      "ENABLE_BITCODE" => 'false'
  }

  # Import the Firebase frameworks to the main project (gets rid of missing header errors)
#   s.user_target_xcconfig = {
#       "FRAMEWORK_SEARCH_PATHS" => '"${PODS_ROOT}/../../ChatSDK/ChatSDKFirebaseAdapter/Frameworks"'
#   }

  s.library = 'icucore', 'c++', 'sqlite3'

  s.subspec 'Base' do |base| 

	base.source_files = ['Classes/**/*']

    base.dependency 'Firebase/Core'
	base.dependency 'Firebase/Database'
	base.dependency 'Firebase/Storage'
	base.dependency 'Firebase/Auth'
	base.dependency 'Firebase/Messaging'

    base.dependency 'ChatSDKCore'  
  
  end
     
end
