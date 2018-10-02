#!/bin/sh

sudo apt-get update
sudo apt-get install zip unzip
echo Downloading GHDL Source Code from Github
wget https://codeload.github.com/ghdl/ghdl/zip/master
unzip -q master -d ./

echo Installing Dependencies: LLVM and GNAT and other essentials
echo Following commands use Super-User Access
sudo apt-get install gcc g++ make clang gnat zlib1g-dev llvm-dev

echo Building GHDL from Source using LLVM Backend
mkdir ghdl-master/build
cd ghdl-master/build
../configure --with-llvm-config --prefix=/usr/local
make
sudo make install

echo Installing Other Packages
sudo apt-get install gtkwave xterm gnuplot
echo Cleaning Up...
cd ../..
sudo rm -r ghdl-master master

echo Installation Ended. Please check the output on the terminal for any errors.
echo Running Checks. If the following commands give any error then the installation was not successful.
ghdl --help
ghdl --version

#echo
#echo Check if the Installation is successful by running \"ghdl --help\" or \"ghdl --version\"
