# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs'
platform :ios, '17.0'

def shared_pods
  # Telegraph
  pod 'Telegraph'
end

target 'WebServerSocket' do
  use_frameworks!
  shared_pods
end

target 'WebServerSocketTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WebServerSocketUITests' do
    # Pods for testing
  end
