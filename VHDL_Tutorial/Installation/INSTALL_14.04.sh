#!/bin/sh

sudo add-apt-repository ppa:pgavin/ghdl
sudo apt-get update
sudo apt-get install ghdl

sudo apt-get install zip unzip

echo Installing Other Packages
sudo apt-get install gtkwave xterm gnuplot

echo Installation Ended. Please check the output on the terminal for any errors.
echo Running Checks. If the following commands give any error then the installation was not successful.
ghdl --help
ghdl --version

#echo
#echo Check if the Installation is successful by running \"ghdl --help\" or \"ghdl --version\"
