all: linuxAppimage lovefile win64 macos

lovefile:
	@rm -rf build/lovefile
	@mkdir -p build/lovefile
	@cd Harmoni; zip -r -9 ../build/lovefile/Harmoni.love .
	@mkdir -p build/release
	@rm -f build/release/HarmoniLovefile.zip
	@cd  build/lovefile; zip -9 -r ../release/HarmoniLovefile.zip .

