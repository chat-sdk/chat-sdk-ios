Pod::Spec.new do |s|
  s.name             = "ChatK!tExtras"
  s.version          = "5.1.0"
  s.summary          = "ChatK!t - Chat SDK Module"
  s.homepage         = "https://chatk.it"
  s.license          = { :type => 'Apache 2.0' }
  s.author           = { "Ben Smiley" => "ben@sdk.chat" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }
  s.module_name      = 'ChatKitExtras'

  s.platform     = :ios, '13.0'
  s.requires_arc = true
  s.swift_version = "5.0"
  
  s.source_files = ['ChatK!tExtras/*.{h,m,swift}']
  s.resources = [ 'ChatK!tExtras/*.{xcassets,xib}']

  s.dependency 'ChatK!t'
  s.dependency 'ChatK!t/ChatSDK'
  s.dependency 'MessageModules/StickerMessage'
      
end