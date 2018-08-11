echo Requires super-suer access
echo Updating outdated packages
sudo apt-get update
sudo apt-get -y upgrade
echo Installing ngSpice
sudo apt-get -y install ngspice
echo Installing some other packages
sudo apt-get -y install gedit-plugins xterm gnuplot git
echo Making directory under "Home" Folder 
cd ~/
echo Downloading examples
git clone https://github.com/ymahajan456/ngSpice-Tutorial.git
echo Checking Installation
ngspice --version

