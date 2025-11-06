@echo off

if not exist build mkdir build
cd build
cmake -A x64 .. && cmake --build . --config Release
cd ..

@echo on

echo Video Module Build Complete