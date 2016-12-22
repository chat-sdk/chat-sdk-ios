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

  end

  s.subspec 'StickerMessages' do |st|

    st.source_files = ['StickerMessages/Classes/**/*']
    st.resource_bundles = {
      'ChatStickerMessages' => ['StickerMessages/Assets/**/*', 'StickerMessages/Interface/**/*']
    }

  end

  s.subspec 'KeyboardOverlayOptions' do |st|

    st.source_files = ['KeyboardOverlayOptions/Classes/**/*']
    st.resource_bundles = {
      'ChatKeyboardOverlayOptions' => ['KeyboardOverlayOptions/Assets/**/*', 'KeyboardOverlayOptions/Interface/**/*']
    }

  end

end
