Pod::Spec.new do |spec|
    spec.name = 'Playbook'
    spec.version  = `cat .version`
    spec.author = { 'ra1028' => 'r.fe51028.r@gmail.com' }
    spec.homepage = 'https://github.com/playbook-ui/playbook-ios'
    spec.documentation_url = 'https://playbook-ui.github.io/playbook-ios'
    spec.summary = 'A library for isolated developing UI components and automatically snapshots of them.'
    spec.source = { :git => 'https://github.com/playbook-ui/playbook-ios.git', :tag => spec.version.to_s }
    spec.license = { :type => 'Apache 2.0', :file => 'LICENSE' }

    spec.requires_arc = true
    spec.default_subspec = 'System', 'Snapshot'
    spec.swift_versions = '5.1'
    spec.ios.deployment_target = '11.0'
    spec.pod_target_xcconfig = {
        'APPLICATION_EXTENSION_API_ONLY' => 'YES',
        'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'
   }

    spec.subspec 'System' do |subspec|
        subspec.ios.source_files = 'Sources/Playbook/**/*.swift'
        subspec.ios.weak_frameworks = 'SwiftUI', 'Combine'
    end

    spec.subspec 'Snapshot' do |subspec|
        subspec.dependency 'Playbook/System'
        subspec.ios.source_files = 'Sources/PlaybookSnapshot/**/*.swift'
        subspec.ios.frameworks = 'XCTest'
        subspec.user_target_xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/Frameworks"' }
        subspec.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
    end

    spec.subspec 'UI' do |subspec|
        subspec.dependency 'Playbook/System'
        subspec.ios.deployment_target = '13.0'
        subspec.ios.source_files = 'Sources/PlaybookUI/**/*.swift'
        subspec.ios.frameworks = 'SwiftUI', 'Combine'
    end
end
