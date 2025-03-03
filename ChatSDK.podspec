Pod::Spec.new do |s|
  s.name             = "ChatSDK"
  s.version          = "5.2.2"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "https://chatsdk.co"
  s.license          = { :type => 'Chat SDK License' }
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }
  s.module_name      = 'ChatSDK'

  s.platform     = :ios, '17.0'
  s.requires_arc = true
  s.swift_version = "5.0"
  # s.static_framework = true

#   s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  
  s.default_subspec = 'Complete'
  
  # s.static_framework = true
  
  s.subspec 'Complete' do |s| 
    s.dependency 'ChatSDK/UI'
    s.dependency 'ChatSDK/Reachability'
  end
  
  s.subspec 'Core' do |s| 

	  s.source_files = ['ChatSDKCore/Classes/**/*']
	  s.resource_bundles = {
		'ChatCore' => ['ChatSDKCore/Assets/**/*']
	  }

	  s.dependency 'RXPromise', '~> 1.0'
	  # s.dependency 'AFNetworking/NSURLSession', '~>4.0.1'
	  s.dependency 'MZDownloadManager'
	  
	  s.dependency 'DateTools', '~> 2.0'
      s.dependency 'SAMKeychain'

      s.dependency 'RxSwift', '~>6.9.0'
      s.dependency 'RxCocoa', '~>6.9.0'

      s.frameworks = 'SafariServices'
  
  end

  s.subspec 'Reachability' do |s| 
	  s.source_files = ['ChatSDKExtras/Reachability/Classes/**/*']
	  s.dependency 'Reachability'
      s.dependency 'ChatSDK/Core'
  end

  s.subspec 'CoreData' do |s|
  
    s.source_files = ['ChatSDKCoreData/Classes/**/*']    
    s.resource_bundles = {
      'ChatCoreData' => ['ChatSDKCoreData/Assets/**/*']
    }    
      
    s.frameworks = 'UIKit', 'CoreData'
    s.dependency 'ChatSDK/Core'
  
  end

  s.subspec 'UI' do |s|

	  s.source_files = ['ChatSDKUI/Classes/**/*.{swift,h,m}']
	  s.resource_bundles = {
		'ChatUI' => ['ChatSDKUI/Assets/**/*', 'ChatSDKUI/Interface/**/*']
	  }
			
	  s.dependency 'MBProgressHUD'
	  s.dependency 'VENTokenField', '~> 2.0'
	  s.dependency 'SDWebImage', '~> 5.0'
	  s.dependency 'StaticDataTableViewController', '~> 2.0'
	  s.dependency 'CropViewController', '~> 2.0'
	  s.dependency 'Hakawai', '~> 5.1.5'
	  s.dependency 'ChatSDKKeepLayout'
	  s.dependency 'Toast', '~>4.1.1'
	  s.dependency 'EFQRCode'
	  s.dependency 'CollectionKit'
    s.dependency 'QuickTableViewController'	  
    s.dependency 'ZLImageEditor'

	  s.dependency 'ChatSDK/CoreData'
	  s.frameworks = 'CoreLocation'
  
  end

  s.subspec 'ModAddContactWithQRCode' do |s|

	  s.source_files = ['ChatSDKExtras/AddContactWithQRCode/**/*.{swift,h,m}']
      s.dependency 'ChatSDK/UI'
  
  end

  s.subspec 'Base64ImageMessage' do |s|

	  s.source_files = ['ChatSDKExtras/Base64ImageMessage/**/*.{swift,h,m}']
      s.dependency 'ChatSDK/UI'
  end
  
  # s.subspec 'Extras' do |s|

	 #  s.source_files = ['ChatSDKExtras/Classes/**/*']
	 #  s.resource_bundles = {
		# 'ChatExtras' => ['ChatSDKExtras/Assets/**/*', 'ChatSDKExtras/Interface/**/*']
	 #  }
			
	 #  s.dependency 'SideMenu'

	 #  s.dependency 'ChatSDK/UI'
  
  # end
      
end
