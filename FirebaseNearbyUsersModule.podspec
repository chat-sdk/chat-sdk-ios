Pod::Spec.new do |s|
  s.name             = "FirebaseNearbyUsersModule"
  s.version          = "5.0.1"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'Commercial'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "git@github.com:chat-sdk/modules-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '10.0'
  s.swift_version = "5.0"
  # s.requires_arc = true
  # s.static_framework = true
  # s.xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }

  s.subspec 'Core' do |s|
    # s.source_files = ['Core/*']
    s.dependency 'ChatSDK'
    s.dependency 'Licensing'
  end

  s.subspec 'FirebaseNearbyUsers' do |s|

    s.source_files = ['FirebaseNearbyUsers/Classes/**/*', 'FirebaseNearbyUsers/geofire-objc/GeoFire/**/*']
    s.resource_bundles = {
      'ChatFirebaseNearbyUsers' => ['FirebaseNearbyUsers/Assets/**/*', 'FirebaseNearbyUsers/Interface/**/*']
    }
    
    # Not included because it would double import the Firebase libraries
    # because they are already imported using vendored_frameworks
    #nu.dependency 'GeoFire'

    s.dependency 'FirebaseNearbyUsersModule/Core'
    s.dependency 'ChatSDKFirebase/Adapter'

  end

    
end
