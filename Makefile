TOOL := PLAYBOOK_DEVELOPMENT=1 swift run -c release
GITHUB_RAW_CONTENT_PATH := https://raw.githubusercontent.com/playbook-ui/playbook-ios/master/
GITHUB_TREE_PATH := https://github.com/playbook-ui/playbook-ios/tree/master/
LIBS := "Playbook" "PlaybookUI" "PlaybookSnapshot"

.PHONY: proj
proj:
	$(TOOL) xcodegen
	$(TOOL) xcodegen --spec Example/project.yml --project Example

.PHONY: format
format:
	$(TOOL) swift-format format -i -p -r Sources Tests Example/SamplePlaybook Example/SampleSnapshot

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

.PHONY: fix-readme-links
fix-readme-links:
	sed -i '' -E '/.?http/!s#(<img src=")([^"]+)#\1$(GITHUB_RAW_CONTENT_PATH)\2#g' README.md
	sed -i '' -E '/.?http/!s#(<img .+src=")([^"]+)#\1$(GITHUB_RAW_CONTENT_PATH)\2#g' README.md
	sed -i '' -E '/.?http/!s#(<a href=")([^"]+)#\1$(GITHUB_TREE_PATH)\2#g' README.md
	sed -i '' -E '/.?http/!s#(<a .+href=")([^"]+)#\1$(GITHUB_TREE_PATH)\2#g' README.md
	sed -i '' -E '/.?http/!s#(\!\[.+\])\((.+)\)#\1($(GITHUB_RAW_CONTENT_PATH)\2)#g' README.md
	sed -i '' -E '/.?http/!s#(\[.+\])\((.+)\)#\1($(GITHUB_TREE_PATH)\2)#g' README.md

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
