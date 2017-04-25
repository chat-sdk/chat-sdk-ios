Pod::Spec.new do |s|
  s.name             = "ChatSDKCore"
  s.version          = "4.2.5"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'MIT'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = ['Classes/**/*']

  s.dependency 'RXPromise', '~> 1.0'
  s.dependency 'PromiseKit'
  s.dependency 'Reachability', '~> 3.0'
  s.dependency 'AFNetworking', '~>3.0'
    
end