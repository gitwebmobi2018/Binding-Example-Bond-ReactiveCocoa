# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BindingTest' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Bond'
  pod 'DatePickerCell'
  pod 'ReactiveCocoa'
  pod 'MarqueeLabel/Swift'
  pod 'LTMorphingLabel'

  target 'BindingTestTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BindingTestUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

## Workaround until these libs migrate to swift 4.2.
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'ReactiveCocoa' || target.name == 'ReactiveSwift' || target.name == 'Result'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end
    end
end
