Pod::Spec.new do |s|
  s.name             = "ChatSDKSinch"
  s.version          = "5.1.3"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "https://sdk.chat"
  s.license          = { :type => 'Chat SDK License' }
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }
  s.module_name      = 'ChatSDKSinch'

  s.platform     = :ios, '11.0'
  s.requires_arc = true
  s.swift_version = "5.0"

  s.subspec 'Sinch' do |s| 

  	s.source_files = ['ChatSDKExtras/Sinch/**/*.{swift,h,m}']
	  s.resource_bundles = {
		'Sinch' => ['ChatSDKExtras/Sinch/**/*.{xib}']
	  }
  	s.dependency 'ChatSDK/UI'

  	s.dependency 'SinchRTC'
  	s.dependency 'SwiftJWT'

	end
      
end
