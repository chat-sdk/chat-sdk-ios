Pod::Spec.new do |s|
  s.name             = "FirebaseModules"
  s.version          = "5.0.1"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'Commercial'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "git@github.com:chat-sdk/modules-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '11.0'
  s.swift_version = "5.0"
  # s.requires_arc = true
  # s.static_framework = true

  s.subspec 'Core' do |s|
    # s.source_files = ['Core/*']
    s.dependency 'ChatSDK'
    s.dependency 'Licensing'
  end

  s.subspec 'FirebaseReadReceipts' do |s|

    s.source_files = ['FirebaseReadReceipts/Classes/**/*']
    s.resource_bundles = {
      'ChatFirebaseReadReceipts' => ['FirebaseReadReceipts/Assets/**/*', 'FirebaseReadReceipts/Interface/**/*']
    }

    s.dependency 'FirebaseModules/Core'
    s.dependency 'ChatSDKFirebase/Adapter'

  end

  s.subspec 'FirebaseTypingIndicator' do |s|

    s.source_files = ['FirebaseTypingIndicator/Classes/**/*']
    s.resource_bundles = {
      'ChatFirebaseTypingIndicator' => ['FirebaseTypingIndicator/Assets/**/*', 'FirebaseTypingIndicator/Interface/**/*']
    }
    
    s.dependency 'FirebaseModules/Core'
    s.dependency 'ChatSDKFirebase/Adapter'

  end

  
  s.subspec 'FirebaseBlocking' do |s|

    s.source_files = ['FirebaseBlocking/Classes/**/*']
    s.resource_bundles = {
      'ChatFirebaseBlocking' => ['FirebaseBlocking/Assets/**/*', 'FirebaseBlocking/Interface/**/*']
    }

    s.dependency 'FirebaseModules/Core'
    s.dependency 'ChatSDKFirebase/Adapter'

  end

  s.subspec 'FirebaseLastOnline' do |s|

    s.source_files = ['FirebaseLastOnline/Classes/**/*']
    s.resource_bundles = {
      'ChatFirebaseLastOnline' => ['FirebaseLastOnline/Assets/**/*', 'FirebaseLastOnline/Interface/**/*']
    }

    s.dependency 'FirebaseModules/Core'
    s.dependency 'ChatSDKFirebase/Adapter'

  end
    
end
