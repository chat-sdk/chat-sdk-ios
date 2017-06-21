Pod::Spec.new do |s|
  s.name             = "ChatSDKFirebaseAdapter"
  s.version          = "4.2.6"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'MIT'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
#   s.source           = { :git => "https://github.com/bensmiley/chat-sdk-test.git" }
  s.source           = { :git => "https://github.com/bensmiley/chat-sdk-test.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = ['ChatSDKFirebaseAdapter/Classes/**/*']
    
  s.frameworks = 'CoreData', 'SystemConfiguration', 'Security', 'MobileCoreServices', 'CFNetwork', 'MessageUI', 'Accounts', 'Social', 'CoreLocation', 'AddressBook', 'AdSupport'
    
  # Maybe we can bring this back at some point but currently (03/17) Firebase pod is broken with use_frameworks! flag
  #s.dependency 'Facebook-iOS-SDK', '~>4.1.0'

  s.dependency 'Firebase/Core'
  s.dependency 'Firebase/Database'
  s.dependency 'Firebase/Storage'
  s.dependency 'Firebase/Auth'
  s.dependency 'Firebase/Messaging'

  s.pod_target_xcconfig = { 
      "ENABLE_BITCODE" => 'false'
  }

  s.dependency 'ChatSDKCore'  
          
  s.library = 'icucore', 'c++', 'sqlite3'
     
end
