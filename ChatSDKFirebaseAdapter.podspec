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

  s.source_files = ['ChatSDKFirebaseAdapter/Classes/**/*']
    
  s.frameworks = 'CoreData', 'SystemConfiguration', 'Security', 'MobileCoreServices', 'CFNetwork', 'MessageUI', 'Accounts', 'Social', 'CoreLocation'  
    
  #s.dependency 'Facebook-iOS-SDK', '~>4.1.0'
  s.dependency 'Firebase/Core'
  s.dependency 'Firebase/Database'
  s.dependency 'Firebase/Storage'
  s.dependency 'Firebase/Auth'
  #s.dependency 'Firebase/Messaging'

  #s.dependency 'Google/SignIn', '~> 3.0'
  #s.dependency 'TwitterKit', '~>1.12'
  s.dependency 'ChatSDKCore'  
      
  s.library = 'icucore'
     
end
