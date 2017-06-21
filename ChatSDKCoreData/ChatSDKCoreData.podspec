Pod::Spec.new do |s|
  s.name             = "ChatSDKCoreData"
  s.version          = "4.2.7"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'MIT'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/bensmiley/chat-sdk-test.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = ['Classes/**/*']    
  s.resource_bundles = {
    'ChatCoreData' => ['Assets/**/*']
  }    
      
  s.frameworks = 'UIKit', 'CoreData'
  s.dependency 'ChatSDKCore'

  # For compatibility with the XMPP Adapter
  s.pod_target_xcconfig = { 
      "ENABLE_BITCODE" => 'false'
  }

    
end

