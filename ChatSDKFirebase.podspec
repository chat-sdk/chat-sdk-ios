Pod::Spec.new do |s|
  s.name             = "ChatSDKFirebase"
  s.version          = "4.14.5"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "https://sdk.chat"
  s.license          = { :type => 'Chat SDK License', :file => 'LICENSE.md' }
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }
#   s.module_name      = 'ChatSDKFirebase'

  s.platform     = :ios, '11.0'
  s.requires_arc = true
  s.swift_version = "5.0"
  
  s.default_subspec = 'Adapter'
  
  s.static_framework = true
  s.pod_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }

 s.subspec 'Adapter' do |s|

	s.source_files = ['ChatSDKFirebase/FirebaseNetworkAdapter/Classes/**/*']
	
    s.dependency 'Firebase/Auth'
    s.dependency 'Firebase/Database'
 
	s.dependency 'ChatSDK'
  
  end

 s.subspec 'FileStorage' do |s|

	s.source_files = ['ChatSDKFirebase/FirebaseFileStorage/Classes/**/*']

    s.dependency 'Firebase/Storage'
	s.dependency 'ChatSDKFirebase/Adapter'
  
  end

 s.subspec 'Push' do |s|

	s.source_files = ['ChatSDKFirebase/FirebasePush/Classes/**/*']

    s.dependency 'Firebase/Messaging'
    s.dependency 'Firebase/Functions'
	s.dependency 'ChatSDKFirebase/Adapter'

  end

 s.subspec 'FirebaseUI' do |s|

	s.source_files = ['ChatSDKFirebase/FirebaseUI/Classes/**/*']

	s.dependency 'ChatSDKFirebase/Adapter'
	s.dependency 'FirebaseUI/Auth', '~> 8.0'
	
  end
      
end