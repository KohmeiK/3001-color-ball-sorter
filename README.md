# RBE3001 Matlab Template
This is template code for talking to the Default firmware
# 1. Configure git
## Generating a new SSH key
If you wish to be able to push changes to this repository without having to enter your username and password all the time,
you need to set up an SSH key with github. 
### 1.1 Create SSH key
Open Terminal

Paste the text below, substituting in your GitHub email address.

 `$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`
 
This creates a new ssh key, using the provided email as a label.

 `> Generating public/private rsa key pair.`
 
When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.

 `> Enter a file in which to save the key (/home/you/.ssh/id_rsa): [Press enter]`
 
At the prompt, DO NOT type a secure passphrase, hit enter to make it passwordless.

### 1.2 Add ssh key to GitHub

And then:  https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/

# 1.3 Configure git
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
