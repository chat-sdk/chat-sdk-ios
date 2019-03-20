Pod::Spec.new do |s|
  s.name             = "ChatSDK"
  s.version          = "4.9.5"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = { :type => 'Chat SDK License', :file => 'LICENSE.md' }
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }
  s.module_name      = 'ChatSDK'

  s.platform     = :ios, '9.0'
  s.requires_arc = true
  
  s.default_subspec = 'Complete'
  
#   s.static_framework = true
  
  s.subspec 'Complete' do |core| 
    core.dependency 'ChatSDK/UI'
    core.dependency 'ChatSDK/Reachability'
  end
  
  s.subspec 'Core' do |core| 

	  core.source_files = ['ChatSDKCore/Classes/**/*']
	  core.resource_bundles = {
		'ChatCore' => ['ChatSDKCore/Assets/**/*']
	  }

	  core.dependency 'RXPromise', '~> 1.0'
	  core.dependency 'AFNetworking', '~>3.2.1'
	  core.dependency 'DateTools', '~> 2.0'
      core.dependency 'SAMKeychain'

      core.frameworks = 'SafariServices'
  
  end

  s.subspec 'Reachability' do |reach| 
	  reach.source_files = ['ChatSDKExtras/Reachability/Classes/**/*']
	  reach.dependency 'Reachability'
      reach.dependency 'ChatSDK/Core'
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
	  ui.dependency 'StaticDataTableViewController', '~> 2.5.0'
	  ui.dependency 'CountryPicker', '~> 1.0'
	  ui.dependency 'TOCropViewController', '~> 2.0'
	  ui.dependency 'Hakawai', '~> 5.1.6'
	  ui.dependency 'ChatSDKKeepLayout', '~> 1.7.5'
	  ui.dependency 'Toast', '~>4.0.0'

	  ui.dependency 'ChatSDK/CoreData', '~>4.9.5'
	  
	  ui.frameworks = 'CoreLocation'
  
  end
  
#     s.subspec 'Extras' do |ex|
# 
# 	  ex.source_files = ['ChatSDKExtras/Classes/**/*']
# 	  ex.resource_bundles = {
# 		'ChatExtras' => ['ChatSDKExtras/Assets/**/*', 'ChatSDKExtras/Interface/**/*']
# 	  }
# 			
# 	  ex.dependency 'SideMenu'
# 
# 	  ex.dependency 'ChatSDK/UI', '~>4.9.5'
#   
#   end

#  s.subspec 'FirebaseAdapter' do |fb|
# 
# 	fb.source_files = ['ChatSDKFirebase/FirebaseNetworkAdapter/Classes/**/*']
#      fb.version   = "4.9.3"
#     fb.dependency 'Firebase/Auth', '~>5.6.0'
#     fb.dependency 'Firebase/Database', '~>5.6.0'
#  
# 	fb.dependency 'ChatSDK/Core', '~>4.9.5'
#   
#   end
# 
#  s.subspec 'FirebaseFileStorage' do |ffs|
# 
# 	ffs.source_files = ['ChatSDKFirebase/FirebaseFileStorage/Classes/**/*']
# 
#     ffs.dependency 'Firebase/Storage', '~>5.6.0'
# 	ffs.dependency 'ChatSDK/FirebaseAdapter', '~>4.9.3'
#   
#   end
# 
#  s.subspec 'FirebasePush' do |fp|
# 
# 	fp.source_files = ['ChatSDKFirebase/FirebasePush/Classes/**/*']
# 
#     fp.dependency 'Firebase/Messaging', '~>5.6.0'
#     fp.dependency 'Firebase/Functions', '~>5.6.0'
# 	fp.dependency 'ChatSDK/FirebaseAdapter', '~>4.9.3'
# 
#   end
#   
#  s.subspec 'FirebaseSocialLogin' do |fsl|
# 
# 	fsl.source_files = ['ChatSDKFirebase/FirebaseSocialLogin/Classes/**/*']
# 	fsl.resource_bundles = {
# 	  'ChatFirebaseSocialLogin' => ['ChatSDKFirebase/FirebaseSocialLogin/Assets/**/*']
# 	}
# 	
# # 	fsl.dependency 'TwitterKit', '<3.3.0'
# # 	fsl.dependency 'TwitterCore', '<3.1.0'
#  	fsl.dependency 'TwitterKit' 
#  	fsl.dependency 'TwitterCore' 
#     fsl.dependency 'GoogleSignIn'
#     fsl.dependency 'FBSDKLoginKit'
# 
# 	fsl.dependency 'ChatSDK/FirebaseAdapter', '~>4.9.3'
# 	fsl.dependency 'ChatSDK/UI', '~>4.9.5'
# 
#   end
      
end