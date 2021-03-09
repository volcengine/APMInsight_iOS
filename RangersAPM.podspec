Pod::Spec.new do |s|
    s.name             = 'RangersAPM'

    s.version          = '1.5.7'

    s.summary          = 'RangersAPM by ByteDance'

    s.description      = 'APMInsight iOS SDK, a tool to monitor APP performance.'

    s.homepage         = 'https://github.com/volcengine/APMInsight_iOS'

    s.license          = { :type => 'MIT', :file => 'RangersAPM/LICENSE' }

    s.authors          = 'ByteDance'

    s.ios.deployment_target = '9.0'

    s.source = { :http => "https://lf1-ttcdn-tos.pstatp.com/obj/heimdallr/RangersAPM/#{s.version}/RangersAPM.zip" }

    s.frameworks = 'UIKit'

    s.dependency 'RangersAppLog/Core', '>=5.6.4'

    s.dependency 'RangersAppLog/Host/CN', '>=5.6.4'

    s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES',}

    s.user_target_xcconfig = {'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',}

    s.static_framework = true

    s.subspec 'Public' do |p|
        p.source_files = 'RangersAPM/Public/**/*.{h,m}'
        p.public_header_files = 'RangersAPM/Public/**/*.h'
        p.vendored_libraries = "RangersAPM/Public/**/*.a"
        p.dependency 'RangersAPM/Core'
    end

    s.subspec 'Core' do |core|
        core.vendored_libraries = "RangersAPM/Core/**/*.a"
        core.libraries = 'c++','z','sqlite3'
        core.frameworks = 'SystemConfiguration','CoreTelephony','CoreFoundation'
        core.preserve_paths = 'RangersAPM/*.sh'
    end

    s.subspec 'Crash' do |crash|
        crash.source_files = 'RangersAPM/Crash/**/*.{h,m}'
        crash.public_header_files = 'RangersAPM/Crash/**/*.h'
        crash.vendored_libraries = "RangersAPM/Crash/**/*.a"
        crash.dependency 'RangersAPM/Core'
        crash.dependency 'RangersAPM/Public'
        crash.dependency 'RangersAPM/HMD'
        crash.resources = ['RangersAPM/Assets/Crash/**/APMInsightCrash.bundle']
        crash.libraries = 'c++abi'
    end

    s.subspec 'WatchDog' do |watchdog|
        watchdog.vendored_libraries = "RangersAPM/WatchDog/**/*.a"
        watchdog.dependency 'RangersAPM/Core'
        watchdog.dependency 'RangersAPM/HMD'
        watchdog.dependency 'RangersAPM/Public'
    end

    s.subspec 'OOM' do |oom|
        oom.vendored_libraries = "RangersAPM/OOM/**/*.a"
        oom.dependency 'RangersAPM/Core'
        oom.dependency 'RangersAPM/Crash'
        oom.dependency 'RangersAPM/WatchDog'
        oom.dependency 'RangersAPM/HMD'
        oom.dependency 'RangersAPM/Public'
    end

    s.subspec 'HMD' do |hmd|
        hmd.vendored_libraries = "RangersAPM/HMD/**/*.a"
        hmd.dependency 'RangersAPM/Core'
    end

    s.subspec 'LAG' do |lag|
        lag.vendored_libraries = "RangersAPM/LAG/**/*.a"
        lag.dependency 'RangersAPM/Core'
        lag.dependency 'RangersAPM/HMD'
        lag.dependency 'RangersAPM/Public'
    end

    s.subspec 'UserException' do |user|
        user.source_files = 'RangersAPM/UserException/**/*.{h,m}'
        user.public_header_files = "RangersAPM/UserException/**/*.h"
        user.vendored_libraries = "RangersAPM/UserException/**/*.a"
        user.dependency 'RangersAPM/Core'
        user.dependency 'RangersAPM/HMD'
        user.dependency 'RangersAPM/Public'
    end

    s.subspec 'UITrackers' do |uitrackers|
        uitrackers.vendored_libraries = 'RangersAPM/UITrackers/**/*.a'
        uitrackers.dependency 'RangersAPM/Core'
        uitrackers.dependency 'RangersAPM/HMD'
        uitrackers.dependency 'RangersAPM/Public'
    end

    s.subspec 'Monitors' do |monitors|
        monitors.source_files = 'RangersAPM/Monitors/**/*.{h,m}'
        monitors.vendored_libraries = 'RangersAPM/Monitors/**/*.a'
        monitors.public_header_files = "RangersAPM/Monitors/**/*.h"
        monitors.dependency 'RangersAPM/UITrackers'
    end

    s.subspec 'Hybrid' do |hybrid|
        hybrid.vendored_libraries = 'RangersAPM/Hybrid/**/*.a'
        hybrid.resources = ['RangersAPM/Assets/Hybrid/**/APMInsightHybrid.bundle']
        hybrid.dependency 'RangersAPM/Core'
        hybrid.dependency 'RangersAPM/HMD'
        hybrid.dependency 'RangersAPM/Public'
        hybrid.frameworks = 'WebKit'
    end

    s.subspec 'MemoryGraph' do |memorygraph|
        memorygraph.vendored_libraries = 'RangersAPM/MemoryGraph/**/*.a'
        memorygraph.dependency 'RangersAPM/Core'
        memorygraph.dependency 'RangersAPM/HMD'
        memorygraph.dependency 'RangersAPM/Public'
        memorygraph.dependency 'RangersAPM/Zip'     
    end

    s.subspec 'Zip' do |zip|
        zip.vendored_libraries = 'RangersAPM/Zip/**/*.a'
        zip.libraries = 'z'
    end

    s.subspec 'Network' do |net|
        net.source_files = 'RangersAPM/Network/**/*.{h,m}'
        net.vendored_libraries = 'RangersAPM/Network/**/*.a'
        net.public_header_files = 'RangersAPM/Network/**/*.h'
        net.dependency 'RangersAPM/Core'
        net.dependency 'RangersAPM/HMD'
        net.dependency 'RangersAPM/Public'
        net.libraries = 'c++'
    end
end
