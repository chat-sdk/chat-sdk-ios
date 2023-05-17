Pod::Spec.new do |s|
  s.name             = "ContactBook"
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
  # s.xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }

  s.subspec 'Core' do |s|
    # s.source_files = ['Core/*']
    s.dependency 'ChatSDK'
  end
  
  s.subspec 'ContactBook' do |s|

    s.source_files = ['ContactBook/Classes/**/*']
    s.resource_bundles = {
      'ChatContactBook' => ['ContactBook/Assets/**/*', 'ContactBook/Interface/**/*']
    }

    s.dependency 'ContactBook/Core'

  end

    
end
