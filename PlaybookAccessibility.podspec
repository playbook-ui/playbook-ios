Pod::Spec.new do |spec|
    spec.name = 'PlaybookAccessibility'
    spec.version  = `cat .version`
    spec.author = { 'jiayi-zhou' => 'jiayi.zhou98@gmail.com' }
    spec.homepage = 'https://github.com/playbook-ui/playbook-ios'
    spec.documentation_url = 'https://playbook-ui.github.io/playbook-ios'
    spec.summary = 'A library for generating snapshot images of components managed by Playbook with accessibility labels.'
    spec.source = { :git => 'https://github.com/playbook-ui/playbook-ios.git', :tag => spec.version.to_s }
    spec.license = { :type => 'Apache 2.0', :file => 'LICENSE' }

    spec.requires_arc = true
    spec.swift_versions = '5.1'
    spec.ios.deployment_target = '11.0'
    spec.ios.source_files = 'Sources/PlaybookAccessibility/**/*.swift'
    spec.ios.frameworks = 'XCTest'
    spec.dependency 'Playbook', "~> 0"
    spec.dependency 'AccessibilitySnapshot/Core', "~> 0.3.2"

    spec.pod_target_xcconfig = {
        'APPLICATION_EXTENSION_API_ONLY' => 'YES',
        'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
        'ENABLE_BITCODE' => 'NO'
    }
    spec.user_target_xcconfig = {
        'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/Frameworks"'
    }
end
