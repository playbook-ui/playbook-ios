Pod::Spec.new do |spec|
    spec.name = 'PlaybookUI'
    spec.version  = `cat .version`
    spec.author = { 'ra1028' => 'r.fe51028.r@gmail.com' }
    spec.homepage = 'https://github.com/playbook-ui/playbook-ios'
    spec.documentation_url = 'https://playbook-ui.github.io/playbook-ios'
    spec.summary = 'UI library for displaying components managed by Playbook.'
    spec.source = { :git => 'https://github.com/playbook-ui/playbook-ios.git', :tag => spec.version.to_s }
    spec.license = { :type => 'Apache 2.0', :file => 'LICENSE' }

    spec.requires_arc = true
    spec.swift_versions = '5.1'
    spec.ios.deployment_target = '13.0'
    spec.ios.source_files = 'Sources/PlaybookUI/**/*.swift'
    spec.ios.frameworks = 'SwiftUI', 'Combine'
    spec.dependency 'Playbook', "~> #{`cat .version`}"

    spec.pod_target_xcconfig = {
        'APPLICATION_EXTENSION_API_ONLY' => 'YES',
        'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'
   }
end
