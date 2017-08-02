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

    fi.dependency 'ChatSDKCore'  
#     fi.dependency 'ChatSDKFirebaseAdapter/FirebaseFrameworks'
    fi.dependency 'Firebase/Core'
    fi.dependency 'Firebase/Auth'
    fi.dependency 'Firebase/Database'
    fi.dependency 'Firebase/Storage'
    fi.dependency 'Firebase/Messaging'

  end
     
end
