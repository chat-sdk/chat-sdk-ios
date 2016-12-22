Pod::Spec.new do |s|
  s.name             = "ChatSDKFirebase"
  s.version          = "4.0.0"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'Commercial'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => '4.0.0' }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.subspec 'AudioMessages' do |am|

    am.source_files = ['AudioMessages/Classes/**/*']
    am.resource_bundles = {
      'ChatAudioMessages' => ['AudioMessages/Assets/**/*', 'AudioMessages/Interface/**/*']
    }

  end

  s.subspec 'ContactBook' do |cb|

    cb.source_files = ['ContactBook/Classes/**/*']
    cb.resource_bundles = {
      'ChatContactBook' => ['ContactBook/Assets/**/*', 'ContactBook/Interface/**/*']
    }

  end

  s.subspec 'NearbyUsers' do |nu|

    nu.source_files = ['NearbyUsers/Classes/**/*']
    nu.resource_bundles = {
      'ChatNearbyUsers' => ['NearbyUsers/Assets/**/*', 'NearbyUsers/Interface/**/*']
    }
    
    nu.dependency 'GeoFire'

  end

  s.subspec 'ReadReceipts' do |rr|

    rr.source_files = ['ReadReceipts/Classes/**/*']
    rr.resource_bundles = {
      'ChatReadReceipts' => ['ReadReceipts/Assets/**/*', 'ReadReceipts/Interface/**/*']
    }

  end

  s.subspec 'Stickers' do |st|

    st.source_files = ['Stickers/Classes/**/*']
    st.resource_bundles = {
      'ChatStickers' => ['Stickers/Assets/**/*', 'Stickers/Interface/**/*']
    }

  end

  s.subspec 'TypingIndicator' do |ti|

    ti.source_files = ['TypingIndicator/Classes/**/*']
    ti.resource_bundles = {
      'ChatTypingIndicator' => ['TypingIndicator/Assets/**/*', 'TypingIndicator/Interface/**/*']
    }

  end

  s.subspec 'VideoMessages' do |vm|

    vm.source_files = ['VideoMessages/Classes/**/*']
    vm.resource_bundles = {
      'ChatVideoMessages' => ['VideoMessages/Assets/**/*', 'VideoMessages/Interface/**/*']
    }

  end


end
