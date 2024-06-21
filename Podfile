platform :ios, '13.0'
use_modular_headers!
use_frameworks! linkage: :static

source 'https://github.com/CocoaPods/Specs.git'

target 'Example-iOS' do
  pod 'SwiftyYYText', path: './'

  target 'Tests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  project = installer.pods_project

  config_group = project.groups.find { |group| group.name == 'Targets Support Files' }.new_group('Configurations')
  Dir.glob('Configurations/*.xcconfig').each do |config|
    path = File.expand_path(config)
    ref = project.add_file_reference(path, config_group)
    build_configuration = project.build_configurations
      .find { |build_config| build_config.name.downcase == File.basename(path, '.*').downcase }
    build_configuration.base_configuration_reference = ref
  end

  project.targets.each do |target|
    target.build_configurations.each do |config|
      pods_project_deployment = installer.pods_project.build_settings(config.name)['IPHONEOS_DEPLOYMENT_TARGET']
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f <= pods_project_deployment.to_f
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end

      if target.name == 'SwiftyYYText'
        config.build_settings['GCC_TREAT_WARNINGS_AS_ERRORS'] = 'YES'
        config.build_settings['SWIFT_TREAT_WARNINGS_AS_ERRORS'] = 'YES'
      end
    end
  end
end
