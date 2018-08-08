Pod::Spec.new do |s|
  s.name             = "ChatSDK"
  s.version          = "4.6.8"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = { :type => 'Chat SDK License', :file => 'LICENSE.md' }
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }
  s.module_name      = 'ChatSDK'

  s.platform     = :ios, '9.0'
  s.requires_arc = true
  
  s.default_subspec = 'UI'
  
  s.static_framework = true
  
  s.subspec 'Core' do |core| 

	  core.source_files = ['ChatSDKCore/Classes/**/*']
	  core.resource_bundles = {
		'ChatCore' => ['ChatSDKCore/Assets/**/*']
	  }

	  core.dependency 'RXPromise', '~> 1.0'
	  core.dependency 'Reachability', '~> 3.0'
	  core.dependency 'AFNetworking', '~>3.2.1'

      core.frameworks = 'SafariServices'
  
  end

  s.subspec 'CoreData' do |cd|
  
    cd.source_files = ['ChatSDKCoreData/Classes/**/*']    
    cd.resource_bundles = {
      'ChatCoreData' => ['ChatSDKCoreData/Assets/**/*']
    }    
      
    cd.frameworks = 'UIKit', 'CoreData'
    cd.dependency 'ChatSDK/Core'
  
  end

  s.subspec 'UI' do |ui|

	  ui.source_files = ['ChatSDKUI/Classes/**/*']
	  ui.resource_bundles = {
		'ChatUI' => ['ChatSDKUI/Assets/**/*', 'ChatSDKUI/Interface/**/*']
	  }
			
	  ui.dependency 'MBProgressHUD', '~> 1.0'
	  ui.dependency 'VENTokenField', '~> 2.0'
	  ui.dependency 'SDWebImage', '~> 4.0'
	  ui.dependency 'StaticDataTableViewController', '~> 2.0'
	  ui.dependency 'CountryPicker', '~> 1.0'
	  ui.dependency 'DateTools', '~> 2.0'
	  ui.dependency 'TOCropViewController', '~> 2.0'
	  ui.dependency 'Hakawai', '~> 5.1.5'
	  ui.dependency 'ChatSDKKeepLayout'
	  ui.dependency 'Toast', '~>4.0.0'

	  ui.dependency 'ChatSDK/CoreData'
	  
	  ui.frameworks = 'CoreLocation'
  
  end

 s.subspec 'FirebaseAdapter' do |fb|

	fb.source_files = ['ChatSDKFirebase/FirebaseNetworkAdapter/Classes/**/*']
	
    fb.dependency 'Firebase/Auth'
    fb.dependency 'Firebase/Database'
    fb.dependency 'Firebase/Performance'
 
	fb.dependency 'ChatSDK/Core'
  
  end

 s.subspec 'FirebaseFileStorage' do |ffs|

	ffs.source_files = ['ChatSDKFirebase/FirebaseFileStorage/Classes/**/*']

    ffs.dependency 'Firebase/Storage'
	ffs.dependency 'ChatSDK/FirebaseAdapter'
  
  end

 s.subspec 'FirebasePush' do |fp|

	fp.source_files = ['ChatSDKFirebase/FirebasePush/Classes/**/*']

    fp.dependency 'Firebase/Messaging'
	fp.dependency 'ChatSDK/FirebaseAdapter'

  end
  
 s.subspec 'FirebaseSocialLogin' do |fsl|

	fsl.source_files = ['ChatSDKFirebase/FirebaseSocialLogin/Classes/**/*']
	fsl.resource_bundles = {
	  'ChatFirebaseSocialLogin' => ['ChatSDKFirebase/FirebaseSocialLogin/Assets/**/*']
	}
	
# 	fsl.dependency 'TwitterKit', '<3.3.0'
# 	fsl.dependency 'TwitterCore', '<3.1.0'
 	fsl.dependency 'TwitterKit' 
 	fsl.dependency 'TwitterCore' 
    fsl.dependency 'GoogleSignIn'
    fsl.dependency 'FBSDKLoginKit'

	fsl.dependency 'ChatSDK/FirebaseAdapter'
	fsl.dependency 'ChatSDK/UI'

  end
      
end