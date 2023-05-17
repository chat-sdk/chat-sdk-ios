Pod::Spec.new do |s|
  s.name             = "Encryption"
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
    # s.source_files = ['Core/*']
    s.dependency 'ChatSDK'
    s.dependency 'Licensing'
  end
  
  s.subspec 'Encryption' do |s|

    s.source_files = ['Encryption/Classes/**/*.{swift}']
    s.resource_bundles = {
      'ChatEncryption' => ['Encryption/Assets/**/*', 'Encryption/Interface/**/*']
    }
    s.dependency 'Encryption/Core'
    s.dependency 'VirgilCrypto', '~> 6.1.0'
    s.dependency 'SAMKeychain'
    s.dependency 'QRCodeReader.swift', '~> 10.1.0'

  end
    
end
