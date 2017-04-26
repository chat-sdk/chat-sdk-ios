Pod::Spec.new do |s|
  s.name             = "ChatSDKModules"
  s.version          = "4.0.0"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'Commercial'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => '4.0.0' }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.subspec 'Backendless' do |bh|

    bh.source_files = ['Backendless/Classes/**/*']
    bh.resource_bundles = {
      'ChatBackendless' => ['Backendless/Assets/**/*', 'Backendless/Interface/**/*']
    }
    
    bh.dependency 'Backendless'
    bh.dependency 'ChatSDKCore'
    bh.dependency 'ChatSDKUI'

  end

  s.subspec 'StickerMessages' do |sm|

    sm.source_files = ['StickerMessages/Classes/**/*']
    sm.resource_bundles = {
      'ChatStickerMessages' => ['StickerMessages/Assets/**/*', 'StickerMessages/Interface/**/*']
    }

    sm.dependency 'ChatSDKCore'
    sm.dependency 'ChatSDKUI'
    sm.dependency 'ChatSDKModules/KeyboardOverlayOptions'

  end

  s.subspec 'KeyboardOverlayOptions' do |ko|

    ko.source_files = ['KeyboardOverlayOptions/Classes/**/*']
    ko.resource_bundles = {
      'ChatKeyboardOverlayOptions' => ['KeyboardOverlayOptions/Assets/**/*', 'KeyboardOverlayOptions/Interface/**/*']
    }
    
    ko.dependency 'ChatSDKCore'
    ko.dependency 'ChatSDKUI'

  end

end
