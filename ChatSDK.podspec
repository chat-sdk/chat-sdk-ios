Pod::Spec.new do |s|
  s.name             = "ChatSDK"
  s.version          = "4.2.10"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'MIT'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/bensmiley/chat-sdk-test.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.pod_target_xcconfig = { 
      "ENABLE_BITCODE" => 'false'
  }
  
  s.subspec 'Core' do |co|
  
    co.source_files = ['ChatSDKCore/Classes/**/*']

    co.dependency 'RXPromise', '~> 1.0'
    co.dependency 'PromiseKit'
    co.dependency 'Reachability', '~> 3.0'
    co.dependency 'AFNetworking', '~>3.1.0'
  
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
  
    ui.dependency 'ChatSDK/Core'
  
  end

  s.subspec 'FirebaseAdapter' do |fi| 

	fi.source_files = ['ChatSDKFirebaseAdapter/Classes/**/*']

    fi.dependency 'Firebase/Core'
	fi.dependency 'Firebase/Database'
	fi.dependency 'Firebase/Storage'
	fi.dependency 'Firebase/Auth'
	fi.dependency 'Firebase/Messaging'

    fi.dependency 'ChatSDK/Core'  

    fi.frameworks = 'CoreData', 'SystemConfiguration', 'Security', 'MobileCoreServices', 'CFNetwork', 'MessageUI', 'Accounts', 'Social', 'CoreLocation', 'AddressBook', 'AdSupport'
    fi.library = 'icucore', 'c++', 'sqlite3'
  
  end
  

  
     
end
