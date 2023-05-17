Pod::Spec.new do |s|
  s.name             = "MessageModules"
  s.version          = "5.0.1"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'Commercial'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "git@github.com:chat-sdk/modules-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '13.0'
  s.swift_version = "5.0"
  # s.requires_arc = true
  # s.static_framework = true
  # s.xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }

  s.subspec 'Core' do |s|
    # s.source_files = ['MessageModules/*']
    s.dependency 'ChatSDK'
    s.dependency 'Licensing'
  end

  s.subspec 'StickerMessage' do |s|

    s.source_files = ['StickerMessage/Classes/**/*.{h,m,swift}']
    s.resource_bundles = {
      'ChatStickerMessage' => ['StickerMessage/Assets/**/*']
    }

    # s.resources = [ 'StickerMessage/Assets/**/*']

    s.dependency 'ChatSDK'
    s.dependency 'MessageModules/KeyboardOverlayOptions'
    s.dependency 'MessageModules/Core'
    s.dependency 'FLAnimatedImage'
    s.dependency 'ChatK!t'

  end

  s.subspec 'KeyboardOverlayOptions' do |s|
    s.source_files = ['KeyboardOverlayOptions/Classes/**/*']
    s.dependency 'MessageModules/Core'
  end

  s.subspec 'VideoMessage' do |s|
    s.source_files = ['VideoMessage/Classes/**/*']
    s.dependency 'MessageModules/Core'
  end

  s.subspec 'AudioMessage' do |s|
    s.source_files = ['AudioMessage/Classes/**/*']
    s.dependency 'MessageModules/Core'
  end
  
  s.subspec 'FileMessage' do |s|

    s.source_files = ['FileMessage/Classes/**/*']
    s.resource_bundles = {
      'ChatFileMessage' => ['FileMessage/Assets/**/*', 'FileMessage/Interface/**/*']
    }

    s.dependency 'MessageModules/Core'
    s.dependency 'MessageModules/KeyboardOverlayOptions'

  end

    s.subspec 'GiphyMessage' do |s|

    s.source_files = ['GiphyMessage/Classes/**/*']
    s.resource_bundles = {
      'ChatGiphyMessage' => ['GiphyMessage/Assets/**/*', 'GiphyMessage/Interface/**/*']
    }

    s.dependency 'MessageModules/Core'
    s.dependency 'Giphy'
    s.dependency 'ChatK!t'
    s.dependency 'FLAnimatedImage'

  end
    
end
