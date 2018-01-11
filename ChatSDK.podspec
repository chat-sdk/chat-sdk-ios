Pod::Spec.new do |s|
  s.name             = "ChatSDK"
  s.version          = "4.3.13"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = { :type => 'Chat SDK License', :file => 'LICENSE.md' }
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }
  s.module_name      = 'ChatSDK'

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  
  s.default_subspec = 'UI'
  
  s.subspec 'Core' do |core| 

	  core.source_files = ['ChatSDKCore/Classes/**/*']
	  core.resource_bundles = {
		'ChatCore' => ['ChatSDKCore/Assets/**/*']
	  }

	  core.dependency 'RXPromise', '~> 1.0'
	#   core.dependency 'PromiseKit'
	  core.dependency 'Reachability', '~> 3.0'
	  core.dependency 'AFNetworking', '~>3.1.0'

#     core.frameworks = 'CoreLocation'
  
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
	  ui.dependency 'DateTools', '~> 1.0'
	  ui.dependency 'TOCropViewController', '~> 2.0'
	  ui.dependency 'Hakawai', '~> 5.0.0'
	  ui.dependency 'ChatSDKKeepLayout'

	  ui.dependency 'ChatSDK/CoreData'
	  
	  ui.frameworks = 'CoreLocation'
  
  end

#  s.subspec 'FirebaseAdapter' do |fb|

# 	  fb.source_files = ['ChatSDK/Classes/**/*']
# 	  fb.resource_bundles = {
# 		'ChatUI' => ['ChatSDKUI/Assets/**/*', 'ChatSDKUI/Interface/**/*']
# 	  }

#     fb.dependency 'Firebase/Core'
#     fb.dependency 'Firebase/Auth'
#     fb.dependency 'Firebase/Database'
#     fb.dependency 'Firebase/Storage'
#     fb.dependency 'Firebase/Messaging'
 
#     fb.vendored_frameworks = "ChatSDKFirebaseAdapter/Frameworks/FirebaseAdapter.framework"
#   
# 	fb.dependency 'ChatSDK/CoreData'
#   
#   end
    
end