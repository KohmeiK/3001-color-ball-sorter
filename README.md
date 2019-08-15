# RBE3001 Matlab Template
This is template code for talking to the Default firmware

# Configure git
```
git config --global user.name "John Doe"
git config --global user.email johndoe@wpi.edu
```
# Cloning
## Clone the TEMPLATE firmware ONCE AND ONLY ONCE
The code comes from this source:
```
git clone https://github.com/WPIRoboticsEngineering/RBE3001_Matlab.git
```
## Set up your private repo ONCE AND ONLY ONCE

```
cd RBE3001_Matlab
#Set your fresh clean Private repo here where `XX' should be replaced by your team number (for instance `01').
git remote set-url origin git@github.com:RBE300X-Lab/RBE3001_MatlabXX.git
# Add the example RBE firmware as an upstream pull
git push origin master
cd ..
rm -rf RBE3001_Matlab
```
## Clone your copy of the firmware (Each team member should do this, AFTER the 2 steps above) 
A private repository containing the robot firmware was created for every team prior to the start of this lab. You can clone the repository by running

where `XX' should be replaced by your team number (for instance `01').
```
git clone git@github.com:RBE300X-Lab/RBE3001_MatlabXX.git
cd RBE3001_MatlabXX
git remote add RBE-UPSTREAM https://github.com/WPIRoboticsEngineering/RBE3001_Matlab.git
git pull RBE-UPSTREAM master
```
# Upstream updates
If the course staff needs to update or repair any system code or the dependant libraries, then you will need to run:
```
git pull RBE-UPSTREAM master
```

# Launch Matlab 

Start in the directory with your checked out code.

```
cd src
matlab
```
