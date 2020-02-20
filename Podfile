platform :ios, '10.0'

target 'BOOTSTRAPAPP' do

  use_frameworks!
  
  pod 'ViperServices', '>= 1.1.2'
  pod 'ViperMcFlurryX'
  pod 'OnDeallocateX'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'R.swift', '>= 5.0.0'
  pod 'SwiftGen'
  pod 'MagicalRecord'

  target 'BOOTSTRAPAPPTests' do
    
    inherit! :complete
    inherit! :search_paths
    
    pod 'OHHTTPStubs'
    pod 'OHHTTPStubs/Swift'
    
  end

  target 'BOOTSTRAPAPPUITests' do
      
      inherit! :complete
      inherit! :search_paths
      
  end

end

post_install do |installer|
    
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end

  installer.pods_project.build_configurations.each do |config|
    # Supress Xcode warning 'Turn on whole module optimization'
    if config.name == 'Release'
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
    else
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
    end
  end
  
end
