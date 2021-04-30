Pod::Spec.new do |s|
  s.name             = "ChatK!t"
  s.version          = "1.0.1"
  s.summary          = "ChatK!t - Message View"
  s.homepage         = "https://chatk.it"
  s.license          = { :type => 'Apache 2.0' }
  s.author           = { "Ben Smiley" => "ben@sdk.chat" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }
  s.module_name      = 'ChatKit'

  s.platform     = :ios, '11.0'
  s.requires_arc = true
  s.swift_version = "5.0"
  
  
  s.source_files = "ChatK!t/Core/**/*.{h,m,swift}"

  s.resources = 'ChatK!t/Core/**/*.{xib,xcassets,strings}'

  s.dependency 'ChatSDKKeepLayout'
  s.dependency 'NextGrowingTextView'
  s.dependency 'CollectionKit'
  
  s.subspec 'ChatSDK' do |s| 
	  s.source_files = ['ChatK!t/ChatSDK/**/*']
    s.dependency 'ChatSDK/Core'
  end
      
end