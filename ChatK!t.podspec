Pod::Spec.new do |s|
  s.name             = "ChatK!t"
  s.version          = "5.0.12"
  s.summary          = "ChatK!t - Message View"
  s.homepage         = "https://chatk.it"
  s.license          = { :type => 'Apache 2.0' }
  s.author           = { "Ben Smiley" => "ben@sdk.chat" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }
  s.module_name      = 'ChatKit'

  s.platform     = :ios, '13.0'
  s.requires_arc = true
  s.swift_version = "5.0"
  s.default_subspec = 'ChatK!t'
  # s.static_framework = true

  s.subspec 'ChatK!t' do |s| 
  
    s.source_files = "ChatK!t/Core/**/*.{h,m,swift}"

    s.resources = 'ChatK!t/Core/**/*.{xib,xcassets,strings}'

    s.dependency 'ChatSDKKeepLayout'
    s.dependency 'NextGrowingTextView'
    s.dependency 'CollectionKit'
    s.dependency 'FFCircularProgressView'
    s.dependency 'MZDownloadManager'
    s.dependency 'FLAnimatedImage'
    s.dependency 'GSImageViewerController'
    s.dependency 'RxSwift', '~>6.2.0'
    s.dependency 'DateTools'
    s.dependency 'SDWebImage'

  end
  
  s.subspec 'ChatSDK' do |s| 
    s.source_files = ['ChatK!t/ChatSDK/**/*']
    s.dependency 'ChatSDK/UI', '~>5.0.11'
    s.dependency 'ChatK!t/ChatK!t'
  end
      
end