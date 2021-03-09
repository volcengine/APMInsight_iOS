# APMInsight_iOS
APMInsight SDK. Enter official website to read the introduction of SDK capabilities and access. [APMInsight](https://datarangers.com.cn/help/doc?lid=6438&did=78964)

## Example 
### Download & Installation
1. git clone https://github.com/volcengine/APMInsight_iOS.git --branch master
2. cd APMInsight_iOS/Example
3. pod install
4. open APMInsight_iOS.xcworkspace

### Usage
1. The demo APP has integrated all capabilities of APMInsight.
2. You can make errors and performance data in the demo APP.
3. The data is shown on APMInsight. You should first request for access to the demo data. [Demo data](https://datarangers.com.cn/apminsight/crash/list?aid=194767&org_id=4210&time=%7B%22granularity%22%3A%22hour%22%2C%22duration%22%3A%22recently%22%2C%22range%22%3A1%7D&filters=%7B%22type%22%3A%22and%22%2C%22sub_conditions%22%3A%5B%7B%22dimension%22%3A%22os%22%2C%22op%22%3A%22in%22%2C%22values%22%3A%5B%22iOS%22%5D%7D%5D%7D)
##### Request for access to demo data
* Register an account for APMInsight. [Go to Register](https://datarangers.com.cn/product/apminsight)
* Contact us to grant permission for you. *chujun.icy@bytedance.com*  *xuminghao.eric@bytedance.com*  
* You will receive an email when you get access.

## Environment
* iOS 9.0+
* Xcode 9.0+

## License
APMInsight_iOS is available under the MIT license. See the LICENSE file for more info.

## Change Log
### 1.5.7
* feature : enable Bitcode
* bugfix : fix addScriptMessageHandler crash in Hybrid module

### 1.5.5
* feature : viewControllers tracing
* feature : more NSNotifications
* optimiz : bundle resources search path 
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


