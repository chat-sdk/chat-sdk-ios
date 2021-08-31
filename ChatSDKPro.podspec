Pod::Spec.new do |s|
  s.name             = "ChatSDKPro"
  s.version          = "5.0.3"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'Commercial'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => '4.0.0' }

  s.platform     = :ios, '11.0'
  s.swift_version = "5.0"
  # s.requires_arc = true
  # s.static_framework = true

  s.subspec 'Core' do |s|
    s.source_files = ['Core/*']
    s.dependency 'ChatSDK'
    s.vendored_frameworks = 'ChatSDKPro/Licensing/Licensing.framework'
  end

  s.subspec 'ContactBook' do |s|

    s.vendored_frameworks = 'ChatSDKPro/ContactBookModule/ContactBookModule.framework'
    s.dependency 'ChatSDKPro/Core'

  end

  s.subspec 'Encryption' do |s|

    s.vendored_frameworks = ['ChatSDKPro/EncryptionModule/EncryptionModule.framework', 
      'ChatSDKPro/EncryptionModule/VirgilCrypto.framework',
      'ChatSDKPro/EncryptionModule/VirgilCryptoAPI.framework',
      'ChatSDKPro/EncryptionModule/VirgilCryptoApiImpl.framework',
      'ChatSDKPro/EncryptionModule/VSCCrypto.framework',
      'ChatSDKPro/EncryptionModule/VirgilSDK.framework']

    s.dependency 'ChatSDKPro/Core'

    # s.dependency 'VirgilCryptoApiImpl', '~> 3.2.2'
    # s.dependency 'VirgilSDK', '~> 5.7'

    s.dependency 'SAMKeychain'
    s.dependency 'QRCodeReader.swift', '~> 10.1.0'

  end

  s.subspec 'Firebase' do |s|

    s.vendored_frameworks = 'ChatSDKPro/FirebaseModules/FirebaseModules.framework'
    s.dependency 'ChatSDKPro/Core'
    s.dependency 'ChatSDKFirebase/Adapter'

  end

    s.subspec 'Message' do |s|

    s.vendored_frameworks = 'ChatSDKPro/MessageModules/MessageModules.framework'
    s.dependency 'ChatSDKPro/Core'
    s.dependency 'FLAnimatedImage'

  end

  s.subspec 'FirebaseNearbyUsers' do |s|

    s.vendored_frameworks = 'ChatSDKPro/FirebaseNearbyUsersModule/FirebaseNearbyUsersModule.framework'
    s.dependency 'ChatSDKPro/Core'
    s.dependency 'ChatSDKFirebase/Adapter'

  end


  # s.subspec 'ChatK!t' do |s|

  #   s.vendored_frameworks = 'ChatSDKPro/ChatK!t/ChatKitExtras.framework'

  #   s.dependency 'ChatK!t'
  #   s.dependency 'ChatK!t/ChatSDK'
  #   s.dependency 'ChatSDKPro/Modules'
  # end

  #   s.subspec 'XMPPFramework' do |s|

  #   s.source_files = ['ChatSDKPro/XMPPFramework/Core/**/*.{h,m,swift}',
  #                   'ChatSDKPro/XMPPFramework/Authentication/**/*.{h,m,swift}', 
  #                   'ChatSDKPro/XMPPFramework/Categories/**/*.{h,m,swift}',
  #                   'ChatSDKPro/XMPPFramework/Jingle/**/*.{h,m,swift}', 
  #                   'ChatSDKPro/XMPPFramework/Utilities/**/*.{h,m,swift}', 
  #                   'ChatSDKPro/XMPPFramework/Extensions/**/*.{h,m,swift}',
  #                   'ChatSDKPro/XMPPFramework/Swift/**/*.{h,m,swift}']
                      
        
  #  s.ios.exclude_files = 'ChatSDKPro/XMPPFramework/Extensions/SystemInputActivityMonitor/**/*.{h,m}'

  #  s.resources = [ 'ChatSDKPro/XMPPFramework/Resources/*']
    
  # s.dependency 'CocoaLumberjack' # Skip pinning version because of the awkward 2.x->3.x transition
  # s.dependency 'CocoaAsyncSocket', '~> 7.6'
  # s.dependency 'KissXML', '~> 5.2'
  # s.dependency 'libidn', '~> 1.35'
  # s.dependency 'ChatSDKPro/Core'
    
  # s.libraries = 'xml2', 'resolv'
  # s.frameworks = 'CoreData', 'SystemConfiguration', 'CoreLocation'
  # s.xcconfig = {
  #   'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2 $(SDKROOT)/usr/include/libresolv',
  # }

  # end

  # s.subspec 'XMPP' do |s|

  #   s.vendored_frameworks = 'ChatSDKPro/XMPP/ChatSDKXMPP.framework'
  #   # s.resources ='XMPPAdapterFramework/ChatXMPPAdapter.bundle'

  #   s.dependency 'SAMKeychain'
  #   s.dependency 'CocoaLumberjack' # Skip pinning version because of the awkward 2.x->3.x transition
  #   s.dependency 'CocoaAsyncSocket', '~> 7.6'
  #   # s.dependency 'CocoaAsyncSocket'
  #   s.dependency 'KissXML', '~> 5.2'
  #   s.dependency 'libidn', '~> 1.35'
  #   s.dependency 'ChatSDK'

  #   s.libraries = 'xml2', 'resolv'
  #   s.frameworks = 'CoreData', 'SystemConfiguration', 'CoreLocation'
  #   s.xcconfig = {
  #     'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2 $(SDKROOT)/usr/include/libresolv',
  #   }

  # end

end
