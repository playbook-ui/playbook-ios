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
    spec.swift_versions = '5.1'
    spec.default_subspec = 'System', 'Snapshot', 'UI'

    spec.subspec 'System' do |subspec|
        subspec.ios.deployment_target = '11.0'
        subspec.ios.source_files = 'Sources/Playbook/**/*.swift'
        subspec.ios.weak_frameworks = ['SwiftUI', 'Combine']
    end

    spec.subspec 'Snapshot' do |subspec|
        subspec.dependency 'Playbook/System'
        subspec.ios.deployment_target = '11.0'
        subspec.ios.source_files = 'Sources/PlaybookSnapshot/**/*.swift'
        subspec.ios.frameworks = 'XCTest'
    end

    spec.subspec 'UI' do |subspec|
        subspec.dependency 'Playbook/System'
        subspec.ios.deployment_target = '13.0'
        subspec.source_files = 'Sources/PlaybookUI/**/*.swift'
        subspec.ios.frameworks = ['SwiftUI', 'Combine']
    end
end
