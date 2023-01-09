# APMInsight_iOS
[中文版本](https://github.com/volcengine/APMInsight_iOS/blob/master/说明.md)
APMPlus SDK. Enter official website to read the introduction of SDK capabilities and access. [APMPlus](https://www.volcengine.com/products/apmplus)

## Example 
### Download & Installation
1. git clone https://github.com/volcengine/APMInsight_iOS.git --branch master
2. cd APMInsight_iOS/Example
3. bundle exec pod install
4. open APMInsight_iOS.xcworkspace

### Usage
1. The demo APP has integrated all capabilities of APMPlus.
2. You can make errors and performance data in the demo APP. 
3. Reset the appID in AppDelegate.m and the performance data will be uploaded to your own console.

## Environment
* iOS 9.0+
* Xcode 9.0+

## License
APMInsight_iOS is available under the MIT license. See the [LICENSE](https://github.com/volcengine/APMInsight_iOS/blob/master/LICENSE) for more info.

## Change Log
### 3.0.5 (※Recommended※)
* bugfix : stability issues
* bugfix : fix mistake of OS version in some logs

### 3.0.4
* feature : support fetching configuration for userID

### 3.0.3
* feature : custom dimension for PV logs
* optimization : optimize the trigger timing of some requests

### 3.0.2
* bugfix : fix some stability issues
* bugfix : Improve compatibility with dynamic libraries

### 3.0.1
* bugfix : fix NSURLSession.sharedSession becoming unavailable in some cases
* bugfix : fix MemoryGraph stuck in some cases
* optimization : optimize the log reporting logic when the event balance is insufficient

### 3.0.0  
* feature : disk monitoring
* feature : interface authentication

### 2.13.2
* bugfix : fix memory leak
* bugfix : fix some data collection error

### 2.13.1
* bugfix : fix memory leak
* bugfix : fix page records error

### 2.13.0
* feature : support configuring performance data reporting interval
* bugfix : fix Global subspec protocol mismatch

### 2.12.4
* bugfix : fix network decision crash on iOS 15
* bugfix : fix the misjudgment problem of OOM

### 2.12.3
* bugfix : fix crash when network unavailable for SDK monitor
* feature : custom configuration support Prewarm threshold

### 2.12.2 
* bugfix : fix Flutter configuration not taking effect

### 2.12.1
* feature : add MetricKit subspec

### 2.12.0
* feature : full link tracing - connect client network log with server log

### 2.11.1
* optimization : optimize the problem that the launch time uploaded is too large
* optimization : optimize console error log

### 2.10.1 
* bugfix : fix problem that network monitoring unavailable on low system

### 2.10.0 
* feature : add BootingProtect subspec

### 2.9.7 
* bugfix : fix memory leak in network monitor
* optimization : time-consuming of network monitor during initialization
* bugfix : fix the compatibility issue of network monitor in swift

### 2.9.3 
* bugfix : fix the problem that the device may fail to report the custom log when using the 12-hour clock

### 2.9.2
* optimization : compatible with custom log reporting protocol

### 2.9.1 
* optimization : optimize custom log reporting time disorder
* optimization : optimize the problem that log retrieval using user_id cannot be delivered normally
* optimization : optimize console log to reduce duplicate messages

### 2.9.0 
* bugfix : fix crash when use class object as network delegate
* feature : deadlock detector

### 2.8.1
* bugfix : fix crash when working with Firebase Performance

### 2.8.0
* feature : zombie object detection online
* feature : userException interface supports passing in NSException
* optimization : change the domain for Saas

### 2.7.4
* bugfix : performance data reporting is not timely
* feature : add debug log for CPU Monitor
 
### 2.7.3
* feature : CPU Monitor

### 2.7.2
* optimization : compliance requirements
* feature : watchdog monitor supports component perspective
* optimization : split device registration module 
* bugfix : network monitor may lead to OOM in some cases 

### 2.6.5 
* optimization : destruction process
* optimization : hook scheme

### 2.6.3
* bugfix : missing fields

### 2.6.2
* bugfix : symbol conflicts

### 2.6.1
* bugfix : uploading apmlogs may crash
* feature : add OneKit start task
* optimization : dsym-uploading script
* bugfix : network monitoring may cause some callbacks to fail

### 2.5.7
* optimization : crash protection logic

### 2.5.6
* bugfix : header lost

### 2.5.5
* bugfix : crash when app exits

### 2.5.3 
* bugfix : network config
* bugfix : start module api

### 2.5.2
* feature : crash protector
* feature : extension crash monitor
* optimization : network monitor refactor

### 2.4.6 
* feature : enable default monitors

### 2.4.3
* optimization : start analysis

### 2.4.1
* bugfix : fix compiler error

### 2.4.0
* feature : custom log and cloudCommand
* bugfix : OOM log lose

### 2.3.2
* bugfix : deviceID may be null in some case

### 2.3.0 
* feature : report launch log
* bugfix : fix crash in iOS 15 and arm64e device

### 2.2.7
* optimization : optimize the judgment for network error log

### 2.2.6
* bugfix : fix symbol conflict

### 2.2.5
* feature : component crash monitor support dynamic library

### 2.2.4
* bugfix : fix the loss of network error log

### 2.2.3
* bugfix : fix config not fetch

### 2.2.2
* bugfix : fix symbol conflict

### 2.2.1
* feature : add flutter monitor

### 2.1.10
* bugfix : fix network code error

### 2.1.8
* optimization : update OneKit to 1.1.13

### 2.1.7
* bugfix : fix the loss of header files

### 2.1.6
* optimization : optimize regular matching

### 2.1.5
* optimization : optimize regular matching

### 2.1.4
* bugfix : fix symbol conflict

### 2.1.3
* optimization : remove some hook

### 2.1.2
* optimization : modified UITracker to start synchronously

### 2.1.1
* optimization : update OneKit to 1.1.9

### 2.1.0
* optimization : component monitor support custom deviceID

### 2.0.6
* bugfix : Custom-error add the validity of incoming parameters

### 2.0.5
* bugfix : fix incorrect judgment of component crash

### 2.0.3
* bugfix : fix compile error

### 2.0.2 (Obsolete)
* bugfix : deviceID service error

### 2.0.0
* feature : event analysis
* feature : custom deviceID

### 1.5.10
* bugfix : solve some category conflict

### 1.5.8
* bugfix : solve conflict with BGFMDB

### 1.5.7
* feature : enable Bitcode
* bugfix : fix addScriptMessageHandler crash in Hybrid module

### 1.5.5
* feature : viewControllers tracing
* feature : more NSNotifications
* optimization : bundle resources search path 
* feature : add custom information into MemoryGraph log

### 1.5.4
* bugfix : solve conflicts with SSZipArchive
* feature : some NSNotifications

### 1.5.3
* bugfix : network monitor certificates verification failed in particular scenes

### 1.5.2
* bugfix : request settings not effective

### 1.5.1
* feature : network type support 5G
* bugfix : solve conflicts with zipArchive

### 1.5.0
* feature : update MemoryGraph config
* feature : DSYM uploader script 

### 1.4.0
* feature : add debug log


