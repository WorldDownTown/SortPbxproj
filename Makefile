PREFIX?=/usr/local

TEMPORARY_FOLDER=./tmp_portable_sortpbxproj

build:
	swift build --disable-sandbox -c release

test:
	swift test

lint:
	swiftlint

clean:
	swift package clean

xcode:
	swift package generate-xcodeproj

install: build
	mkdir -p "$(PREFIX)/bin"
	cp -f ".build/release/SortPbxproj" "$(PREFIX)/bin/sort-pbxproj"

portable_zip: build
	mkdir -p "$(TEMPORARY_FOLDER)"
	cp -f ".build/release/SortPbxproj" "$(TEMPORARY_FOLDER)/sort-pbxproj"
	cp -f "LICENSE" "$(TEMPORARY_FOLDER)"
	(cd $(TEMPORARY_FOLDER); zip -r - LICENSE sort-pbxproj) > "./portable_sortpbxproj.zip"
	rm -r "$(TEMPORARY_FOLDER)"
