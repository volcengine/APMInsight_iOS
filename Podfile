# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'APMInsight_iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # 可以把这部分代码copy到您的Podfile文件中，执行pod install，安装对应组件
  # You can copy the code as follows to your Podfile, and excute "pod install" in command line to install our SDKs.
  # 可复制部分开始---
  #  Copyable section starts ---
  source 'https://github.com/bytedance/cocoapods_sdk_source_repo.git'
  source 'https://github.com/CocoaPods/Specs.git'
  pod 'RangersAPM', '1.1.0', :subspecs => [
      'Crash',
      'WatchDog',
      'OOM',
      'LAG',
      'UserException',
      'Monitors',
      'UITrackers',
      'Hybrid',
      'MemoryGraph',
      'Network'
  ]
  pod 'RangersAppLog', :subspecs => [
      'Core',
      'Host/CN'
  ]
  # ---可复制部分结束
  # --- Copyable section ends
  
  # Pods for APMInsight_iOS

end
