Pod::Spec.new do |s|
    s.name             = 'RangersAPM'

    s.version          = '2.6.1'

    s.summary          = 'RangersAPM by ByteDance'

    s.description      = 'APMInsight iOS SDK, a tool to monitor APP performance.'

    s.homepage         = 'https://github.com/volcengine/APMInsight_iOS'

    s.license          = { :type => 'MIT', :file => 'RangersAPM/LICENSE' }

    s.authors          = 'ByteDance'

    s.ios.deployment_target = '9.0'

    s.source = { :http => "https://lf1-ttcdn-tos.pstatp.com/obj/heimdallr/RangersAPM/2.6.1/RangersAPM.zip" }

    s.frameworks = 'UIKit'

    s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES',}

    s.user_target_xcconfig = {'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',}

    s.static_framework = true

    s.subspec 'Above' do |above|
        above.vendored_libraries = "RangersAPM/Above/**/*.a"
    end

    s.subspec 'Zyone' do |zyone|
        zyone.vendored_libraries = "RangersAPM/Zyone/**/*.a"
    end

    s.subspec 'Public' do |public|
        public.vendored_libraries = "RangersAPM/Public/**/*.a"
        public.source_files = 'RangersAPM/Public/**/*.{h,m}'
        public.public_header_files = 'RangersAPM/Public/**/*.h'
        public.dependency 'RangersAPM/Core'
        public.dependency 'RangersAPM/Above'
        public.dependency 'RangersAPM/Zyone'
    end

    s.subspec 'Core' do |core|
    	core.vendored_libraries = "RangersAPM/Core/**/*.a"
    	core.libraries = 'c++','z','sqlite3'
        core.frameworks = 'SystemConfiguration','CoreTelephony','CoreFoundation'
        core.preserve_paths = 'RangersAPM/*.sh'
        core.resources = ['RangersAPM/Assets/Core/**/APMInsightCore.bundle']
        core.dependency 'OneKit/BaseKit', '>=1.1.19'
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
        hmd.dependency 'OneKit/Database', '>=1.1.19'
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
        uitrackers.source_files = 'RangersAPM/UITrackers/**/*.{h,m}'
        uitrackers.vendored_libraries = 'RangersAPM/UITrackers/**/*.a'
        uitrackers.public_header_files = 'RangersAPM/UITrackers/**/*.h'
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

    s.subspec 'EventMonitor' do |eventmonitor|
        eventmonitor.source_files = 'RangersAPM/EventMonitor/**/*.{h,m}'
        eventmonitor.vendored_libraries = 'RangersAPM/EventMonitor/**/*.a'
        eventmonitor.public_header_files = 'RangersAPM/EventMonitor/**/*.h'
        eventmonitor.libraries = 'c++'
        eventmonitor.dependency 'RangersAPM/Core'
        eventmonitor.dependency 'RangersAPM/HMD'
        eventmonitor.dependency 'RangersAPM/Public'
    end

    s.subspec 'CN' do |cn|
        cn.vendored_libraries = 'RangersAPM/CN/**/*.a'
        cn.dependency 'RangersAPM/Core'
        cn.dependency 'RangersAPM/Public'
    end

    s.subspec 'Global' do |global|
        global.vendored_libraries = 'RangersAPM/Global/**/*.a'
        global.dependency 'RangersAPM/Core'
        global.dependency 'RangersAPM/Public'
    end
    
    s.subspec 'Flutter' do |flutter|
        flutter.source_files = 'RangersAPM/Flutter/**/*.{h,m}'
        flutter.vendored_libraries = 'RangersAPM/Flutter/**/*.a'
        flutter.public_header_files = 'RangersAPM/Flutter/**/*.h'
        flutter.dependency 'RangersAPM/EventMonitor'
    end

    s.subspec 'SessionTracker' do |st|
        st.vendored_libraries = 'RangersAPM/SessionTracker/**/*.a'
        st.dependency 'RangersAPM/Core'
        st.dependency 'RangersAPM/HMD'
        st.dependency 'RangersAPM/Public'
    end

    s.subspec 'APMLog' do |alog|
        alog.source_files = 'RangersAPM/APMLog/**/*.{h,m}'
        alog.vendored_libraries = 'RangersAPM/APMLog/**/*.a'
        alog.public_header_files = 'RangersAPM/APMLog/**/*.h'
        alog.dependency 'RangersAPM/Core'
        alog.dependency 'RangersAPM/HMD'
        alog.dependency 'RangersAPM/Zip'
        alog.dependency 'RangersAPM/Public'
        alog.libraries = 'c++','z', 'resolv'
    end

    s.subspec 'NetworkBasic' do |nb|
        nb.source_files = 'RangersAPM/NetworkBasic/**/*.{h,m}'
        nb.vendored_libraries = 'RangersAPM/NetworkBasic/**/*.a'
        nb.public_header_files = 'RangersAPM/NetworkBasic/**/*.h'
        nb.dependency 'RangersAPM/Core'
        nb.dependency 'RangersAPM/HMD'
        nb.dependency 'RangersAPM/Public'
        nb.libraries = 'c++'
    end

    s.subspec 'Network' do |net|
        net.source_files = 'RangersAPM/Network/**/*.{h,m}'
        net.vendored_libraries = 'RangersAPM/Network/**/*.a'
        net.public_header_files = 'RangersAPM/Network/**/*.h'
        net.dependency 'RangersAPM/NetworkBasic'
    end

    s.subspec 'NetworkPro' do |np|
        # np.source_files = 'RangersAPM/NetworkPro/**/*.{h,m}'
        np.vendored_libraries = 'RangersAPM/NetworkPro/**/*.a'
        # np.public_header_files = 'RangersAPM/NetworkPro/**/*.h'
        np.dependency 'RangersAPM/NetworkBasic'
    end

    s.subspec 'CrashProtector' do |cp|
        # cp.source_files = 'RangersAPM/CrashProtector/**/*.{h,m}'
        cp.vendored_libraries = 'RangersAPM/CrashProtector/**/*.a'
        # cp.public_header_files = 'RangersAPM/CrashProtector/**/*.h'
        cp.dependency 'RangersAPM/Core'
        cp.dependency 'RangersAPM/HMD'
        cp.dependency 'RangersAPM/Public'
        cp.dependency 'RangersAPM/Crash'
        cp.libraries = 'c++'
    end

    s.subspec 'OKKit' do |ok|
        ok.vendored_libraries = 'RangersAPM/OKKit/**/*.a'
        ok.dependency 'OneKit/StartUp'
        ok.dependency 'OneKit/Service', '>=1.1.39-rc.0'
        ok.dependency 'RangersAPM/Public'
    end
end
