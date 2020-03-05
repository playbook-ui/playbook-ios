SWIFT_TOOL := Tools/swift-run.sh
GITHUB_RAW_CONTENT_PATH := https://raw.githubusercontent.com/playbook-ui/playbook-ios/master/
GITHUB_TREE_PATH := https://github.com/playbook-ui/playbook-ios/tree/master/

.PHONY: all
all: proj mod format

.PHONY: proj
proj:
	$(SWIFT_TOOL) xcodegen
	$(SWIFT_TOOL) xcodegen --spec Example/project.yml --project Example

.PHONY: mod
mod:
	$(SWIFT_TOOL) swift-mod

.PHONY: format
format:
	$(SWIFT_TOOL) swift-format --configuration .swift-format.json -i -r -m format \
	  Sources Tests Example/SamplePlaybook Example/SampleSnapshot

.PHONY: lint
lint:
	$(SWIFT_TOOL) swift-format --configuration .swift-format.json -r -m lint Sources Tests

.PHONY: pod-lib-lint
pod-lib-lint:
	bundle exec pod lib lint

.PHONY: pod-release
pod-release:
	bundle exec pod trunk push

.PHONY: gem
gem:
	bundle config path vendor/bundle
	bundle install --jobs 4 --retry 3

.PHONY: npm
npm:
	npm i

.PHONY: docs
docs:
	@echo "Currently swift-doc is installed via HomeBrew, it should be installed via SwiftPM after merged this PR 'https://github.com/SwiftDocOrg/swift-doc/pull/7'"
	rm -rf docs
	cat README.md | \
	  sed -E '/.?http/!s#(<img src=")([^"]+)#\1$(GITHUB_RAW_CONTENT_PATH)\2#g' | \
	  sed -E '/.?http/!s#(<img .+src=")([^"]+)#\1$(GITHUB_RAW_CONTENT_PATH)\2#g' | \
	  sed -E '/.?http/!s#(<a href=")([^"]+)#\1$(GITHUB_TREE_PATH)\2#g' | \
	  sed -E '/.?http/!s#(<a .+href=")([^"]+)#\1$(GITHUB_TREE_PATH)\2#g' | \
	  sed -E '/.?http/!s#(\!\[.+\])\((.+)\)#\1($(GITHUB_RAW_CONTENT_PATH)\2)#g' | \
	  sed -E '/.?http/!s#(\[.+\])\((.+)\)#\1($(GITHUB_TREE_PATH)\2)#g' > \
	  gitbook/README.md
	swift doc Sources --output gitbook
	echo '## Playbook\n' > gitbook/SUMMARY.md
	cat gitbook/Home.md | \
	  sed 's/#/##/g' | \
	  sed -E 's#\[(.+)\]\((.+)\)#[\1](\2.md)#g' >> \
	  gitbook/SUMMARY.md
	npx gitbook install gitbook
	npx gitbook build gitbook docs

.PHONY: xcframework
xcframework:
	rm -rf ./archive
	for scheme in "Playbook" "PlaybookUI"; do \
	for sdk in "iphoneos" "iphonesimulator"; do \
	xcodebuild archive \
	  -scheme $$scheme \
	  -configuration Release \
	  -sdk $$sdk \
	  -destination="iOS" \
	  -archivePath "archive/$$sdk.xcarchive"; \
	done; \
	find archive -name '*.swiftinterface' -exec sed -i '' -e 's/Playbook\.//g' {} \;; \
	rm -rf ./$$scheme.xcframework; \
	xcodebuild -create-xcframework \
	  -framework archive/iphoneos.xcarchive/Products/Library/Frameworks/$$scheme.framework \
	  -framework archive/iphonesimulator.xcarchive/Products/Library/Frameworks/$$scheme.framework \
	  -output $$scheme.xcframework; \
	done
