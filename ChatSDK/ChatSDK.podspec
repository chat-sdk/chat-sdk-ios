Pod::Spec.new do |s|
  s.name             = "ChatSDK"
  s.version          = "4.2.0"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'MIT'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => '4.2.0' }

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  
  #s.default_subspec = 'Core'
  
  s.subspec 'Core' do |core|

    core.source_files = ['Core/Classes/**/*']
    core.resource_bundles = {
      'ChatSDKCore' => ['Core/Assets/**/*']
    }

    core.dependency 'RXPromise', '~> 1.0'
    core.dependency 'Reachability', '~> 3.0'
    core.dependency 'AFNetworking', '~>3.0'

  end
  
  s.subspec 'ChatUI' do |ui|
  
    ui.source_files = 'ChatUI/Classes/**/*'
    ui.resource_bundles = {
      'ChatUI' => ['ChatUI/Assets/**/*', 'ChatUI/Interface/**/*']
    }
  
    ui.dependency 'ChatSDK/Core'
    ui.dependency 'Google/SignIn', '~> 3.0'
    ui.dependency 'MBProgressHUD', '~> 1.0'
    ui.dependency 'VENTokenField', '~> 2.0'
    ui.dependency 'SDWebImage', '~> 3.0'
    ui.dependency 'SDWebImage-ProgressView', '~> 0.4'
    ui.dependency 'StaticDataTableViewController', '~> 2.0'
    ui.dependency 'CountryPicker', '~> 1.0'
    ui.dependency 'DateTools', '~> 1.0'
    ui.dependency 'TOCropViewController', '~> 2.0'
  
  end
  
  s.subspec 'CoreData' do |coredata|
  
    coredata.source_files = 'CoreData/Classes/**/*'
    coredata.resource_bundles = {
      'ChatCoreData' => ['CoreData/Assets/**/*']
    }
  
    coredata.dependency 'ChatSDK/Core'
	coredata.frameworks = 'UIKit', 'CoreData'
  
  end
  
  s.subspec 'FirebaseAdapter' do |firebase|
  
    firebase.source_files = 'FirebaseAdapter/Classes/**/*'
    firebase.resource_bundles = {
      'ChatFirebaseAdapter' => ['FirebaseAdapter/Assets/**/*']
    }

    firebase.frameworks = 'CoreData', 'SystemConfiguration', 'Security', 'MobileCoreServices', 'CFNetwork', 'MessageUI', 'Accounts', 'Social', 'CoreLocation'

    firebase.dependency 'ChatSDK/Core'
    firebase.dependency 'Facebook-iOS-SDK', '~>4.0.1'
    firebase.dependency 'Firebase/Core'
    firebase.dependency 'Firebase/Database'
    firebase.dependency 'Firebase/Storage'
    firebase.dependency 'Firebase/Auth'
    firebase.dependency 'Firebase/Messaging'

    firebase.dependency 'Google/SignIn'
    firebase.dependency 'TwitterKit', '~>1.12'
  
    firebase.library = 'icucore'
  
  end

end
