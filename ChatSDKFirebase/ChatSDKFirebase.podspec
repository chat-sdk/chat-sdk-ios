Pod::Spec.new do |s|
  s.name             = "ChatSDKFirebase"
  s.version          = "4.0.0"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'Commercial'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => '4.0.0' }

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  
  s.pod_target_xcconfig = { 
      "ENABLE_BITCODE" => 'false'
  }


  s.subspec 'AudioMessages' do |am|

    am.source_files = ['AudioMessages/Classes/**/*']
    am.resource_bundles = {
      'ChatAudioMessages' => ['AudioMessages/Assets/**/*', 'AudioMessages/Interface/**/*']
    }
    
    am.dependency 'ChatSDKCore'
    am.dependency 'ChatSDKFirebaseAdapter'
    am.dependency 'ChatSDKUI'

  end

  s.subspec 'ContactBook' do |cb|

    cb.source_files = ['ContactBook/Classes/**/*']
    cb.resource_bundles = {
      'ChatContactBook' => ['ContactBook/Assets/**/*', 'ContactBook/Interface/**/*']
    }
    
    cb.dependency 'ChatSDKCore'
    cb.dependency 'ChatSDKFirebaseAdapter'
    cb.dependency 'ChatSDKUI'


  end

  s.subspec 'NearbyUsers' do |nu|

    nu.source_files = ['NearbyUsers/Classes/**/*', 'NearbyUsers/geofire-objc/GeoFire/**/*']
    nu.resource_bundles = {
      'ChatNearbyUsers' => ['NearbyUsers/Assets/**/*', 'NearbyUsers/Interface/**/*']
    }
    
    # Not included because it would double import the Firebase libraries
    # because they are already imported using vendored_frameworks
    #nu.dependency 'GeoFire'
    nu.dependency 'ChatSDKCore'
    nu.dependency 'ChatSDKFirebaseAdapter'
    nu.dependency 'ChatSDKUI'

  end

  s.subspec 'ReadReceipts' do |rr|

    rr.source_files = ['ReadReceipts/Classes/**/*']
    rr.resource_bundles = {
      'ChatReadReceipts' => ['ReadReceipts/Assets/**/*', 'ReadReceipts/Interface/**/*']
    }

    rr.dependency 'ChatSDKCore'
    rr.dependency 'ChatSDKFirebaseAdapter'
    rr.dependency 'ChatSDKUI'

  end

  s.subspec 'TypingIndicator' do |ti|

    ti.source_files = ['TypingIndicator/Classes/**/*']
    ti.resource_bundles = {
      'ChatTypingIndicator' => ['TypingIndicator/Assets/**/*', 'TypingIndicator/Interface/**/*']
    }
    
    ti.dependency 'ChatSDKCore'
    ti.dependency 'ChatSDKFirebaseAdapter'
    ti.dependency 'ChatSDKUI'

  end

  s.subspec 'VideoMessages' do |vm|

    vm.source_files = ['VideoMessages/Classes/**/*']
    vm.resource_bundles = {
      'ChatVideoMessages' => ['VideoMessages/Assets/**/*', 'VideoMessages/Interface/**/*']
    }

    vm.dependency 'ChatSDKCore'
    vm.dependency 'ChatSDKFirebaseAdapter'
    vm.dependency 'ChatSDKUI'

  end

  s.subspec 'Broadcast' do |br|

    br.source_files = ['Broadcast/Classes/**/*']
    br.resource_bundles = {
      'ChatBroadcast' => ['Broadcast/Assets/**/*', 'Broadcast/Interface/**/*']
    }

    br.dependency 'ChatSDKCore'
    br.dependency 'ChatSDKFirebaseAdapter'
    br.dependency 'ChatSDKUI'

  end
  
  s.subspec 'SocialLogin' do |sl|

    sl.source_files = ['SocialLogin/Classes/**/*']
    sl.resource_bundles = {
      'ChatSocialLogin' => ['SocialLogin/Assets/**/*', 'SocialLogin/Interface/**/*']
    }
    
    #sl.dependency 'Google/SignIn', '~> 3.0'
    #sl.dependency 'TwitterKit', '~>1.1'
    #sl.dependency 'Facebook-iOS-SDK', '~>4.1.0'
    #sl.dependency 'FBSDKCoreKit'
    #sl.dependency 'FBSDKLoginKit'

    
    # This needs to be synchronized with the Firebase Adapter Module because 
    # They share some Google library dependencies
    #sl.dependency 'GTMOAuth2', '~>1.0'
    #sl.dependency 'GTMSessionFetcher', '~>1.1'
    #sl.dependency 'GoogleToolboxForMac', '~>2.1'

    #sl.vendored_frameworks = "SocialLogin/Frameworks/*"
    
#       Import the Firebase frameworks to the main project (gets rid of missing header errors)
	#sl.user_target_xcconfig = {
	#  "FRAMEWORK_SEARCH_PATHS" => '"${PODS_ROOT}/../../../ChatSDK/ChatSDKFirebase/SocialLogin/Frameworks"'
	#}

    sl.dependency 'ChatSDKCore'
    sl.dependency 'ChatSDKFirebaseAdapter'
    sl.dependency 'ChatSDKUI'

  end


end
