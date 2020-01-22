# RBE3001 Matlab Template
This is template code for talking to the Default firmware

# 1. Configure git
```bash
git config --global user.name "John Doe"
git config --global user.email johndoe@wpi.edu
```
# 2. Set up your Git Repository
## 2.1 Clone your private lab repository
Clone your private lab repository. **Note: The command below won't work! Use your own url, found on Github!**
```bash
git clone git@github.com:RBE300X-Lab/RBE3001_MatlabXX.git
```
If your repository is empty, you may get a warning.

## 2.2 Set up your private lab repository **[DO ONLY ONCE PER TEAM]**
Note: Perform this **only if** you do not already have the starter Matlab code in your repository
1. `cd` into your repository you just created
```bash
cd [name of the repository you just cloned]
```
2. Set up a secondary remote server pointing to your repository
```bash
git remote add default-code https://github.com/WPIRoboticsEngineering/RBE3001_Matlab.git
```
You can confirm that the remote has been added by running the following command: 
```bash
git remote
```
3. Pull the code from your remote server. You should then see the code in your local repository
``` bash
git pull default-code master
```
4. Push your code to your main remote repository `origin`
```bash
git push origin
```

## 2.3 Pulling changes from your secondary remote repository **[Only if required]**
If you need to pull new changes from the default repostory, follow these instructions:
1. Make sure you have set up the correct secondary remote repository. Run the following code to check:
``` bash
git remote -v
```
You should see `origin` (your main server repo) and another pointing to the following url:
```url
https://github.com/WPIRoboticsEngineering/RBE3001_Matlab.git
```
**If you do not see a second remote, or your second remote points to another url, follow the instructions under [Section 3.2 Part 2](##3.2-Set-up-your-private-lab-repository-**[DO-ONLY-ONCE-PER-TEAM]**)**

2. Run the following command to pull the new code from the secondary remote repository:
``` bash
git pull default-code master
```
Note: If your secondary remote is not named `default-code`, change it to the actual name

# 3. Launch Matlab 

Start in the directory with your checked out code.

```bash
cd src
matlab
```
