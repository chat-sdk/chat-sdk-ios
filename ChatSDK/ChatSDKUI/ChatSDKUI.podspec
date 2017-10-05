Pod::Spec.new do |s|
  s.name             = "ChatSDKUI"
  s.version          = "4.2.5"
  s.summary          = "Chat SDK - Mobile messaging framework for iOS"
  s.homepage         = "http://chatsdk.co"
  s.license          = 'MIT'
  s.author           = { "Ben Smiley" => "ben@chatsdk.co" }
  s.source           = { :git => "https://github.com/chat-sdk/chat-sdk-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = ['Classes/**/*']
  s.resource_bundles = {
    'ChatUI' => ['Assets/**/*', 'Interface/**/*']
  }
            
  s.dependency 'MBProgressHUD', '~> 1.0'
  s.dependency 'VENTokenField', '~> 2.0'
  s.dependency 'SDWebImage', '~> 4.0'
  #s.dependency 'SDWebImage-ProgressView', '~> 0.4'
  s.dependency 'StaticDataTableViewController', '~> 2.0'
  s.dependency 'CountryPicker', '~> 1.0'
  s.dependency 'DateTools', '~> 1.0'
  s.dependency 'TOCropViewController', '~> 2.0'
  s.dependency 'Hakawai', '~> 5.0.0'
  
  s.dependency 'ChatSDKCore'
   
    
end