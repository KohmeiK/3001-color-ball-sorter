# RBE3001 Matlab Template
This is template code for talking to the Default firmware

# 1. Configure git
```
git config --global user.name "John Doe"
git config --global user.email johndoe@wpi.edu
```
# 2. Fork and push template to private repo

## 2.1 Clone the TEMPLATE Matlab ONCE AND ONLY ONCE
The code comes from this source:
```
git clone https://github.com/WPIRoboticsEngineering/RBE3001_Matlab.git
```
## 2.2 Set up your private repo ONCE AND ONLY ONCE

```
cd RBE3001_Matlab
#Set your fresh clean Private repo here where `XX' should be replaced by your team number (for instance `01').
git remote set-url origin git@github.com:RBE300X-Lab/RBE3001_MatlabXX.git
# Add the example RBE firmware as an upstream pull
git push origin master
cd ..
rm -rf RBE3001_Matlab
```
# 3. Clone your copy of the Matlab 

## 3.1 (Each team member should do this, AFTER the 2 steps above) 

A private repository containing the robot firmware was created for every team prior to the start of this lab. You can clone the repository by running

where `XX' should be replaced by your team number (for instance `01').
```
git clone git@github.com:RBE300X-Lab/RBE3001_MatlabXX.git
cd RBE3001_MatlabXX
git remote add RBE-UPSTREAM https://github.com/WPIRoboticsEngineering/RBE3001_Matlab.git
git pull RBE-UPSTREAM master
```
# 4. Upstream updates
If the course staff needs to update or repair any system code or the dependant libraries, then you will need to run:
```
git pull RBE-UPSTREAM master
```

# 5. Launch Matlab 

Start in the directory with your checked out code.

```
cd src
matlab
```
