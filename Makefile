TOOL = scripts/swift-run.sh
GITHUB_RAW_CONTENT_PATH = https://raw.githubusercontent.com/playbook-ui/playbook-ios/master/
GITHUB_TREE_PATH = https://github.com/playbook-ui/playbook-ios/tree/master/
LIBS = "Playbook" "PlaybookUI" "PlaybookSnapshot"
XCODE_GEN_RESOURCES = Tools/.build/checkouts/XcodeGen/SettingPresets

.PHONY: proj
proj:
	SWIFT_PACKAGE_RESOURCES=$(XCODE_GEN_RESOURCES) $(TOOL) xcodegen
	SWIFT_PACKAGE_RESOURCES=$(XCODE_GEN_RESOURCES) $(TOOL) xcodegen --spec Example/project.yml --project Example

.PHONY: format
format:
	$(TOOL) swift-format format -i -p -r Sources Tests Example/SamplePlaybook Example/SampleSnapshot Package.swift Tools/Package.swift

.PHONY: lint
lint:
	$(TOOL) swift-format lint -s -p -r Sources Tests

.PHONY: docs
docs:
	xcodebuild docbuild \
	  -scheme PlaybookSnapshot \
	  -destination generic/platform=iOS \
	  OTHER_DOCC_FLAGS="--transform-for-static-hosting --hosting-base-path playbook-ios --output-path docs"

.PHONY: npm
npm:
	npm i

.PHONY: xcframework
xcframework:
	rm -rf ./archive
	for scheme in $(LIBS); do \
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
