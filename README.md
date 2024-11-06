# Gluco Guide - Git Guide

This document serves as a quick reference for GIT commands that might be needed for the project

---

## Table of Contents
1. [Setup](#setup)
2. [Branching](#branching)
3. [Committing Changes](#committing-changes)
4. [Merging](#merging)
5. [Diverging](#diverging)
6. [Helpful Commands](#helpful-commands)

---

### Setup
To setup git with your credentials, make sure that you have configured your configs:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

There might also be an issue when configering, the solution will be to go to this url [Git Settings](https://github.com/settings/tokens). Make a token with full commands /(You dont always want to do this, but for these purposes you should/).
Copy the generated token, and type what is below in the terminal. This will set-up a connection to repo. 

```bash
#clone the repo
git clone https://github.com/UNO-CSCI4830/GlucoGuide.git
#go into the repo
cd GlucoGuide
#This is the format: git remote set-url origin https://<username>:<generated_token>@github.com/<ORG>/<repo>.git
git remote set-url origin https://<username>:<generated_token>@github.com/UNO-CSCI4830/GlucoGuide.git
```

---

### Branching 
When making changes to the project we want to avoid making changes in main. To make changes, we need to make branches for our dev work. To make setup a branch off the main branch, lets do this.
```bash
#check what branch you are on
git branch -a
#go to the main branch
git checkout main
#create a branch based off the main branch/navigate to it
git branch <branch_name>
git checkout <branch_name>
```
You can also check what branches are in the repo by adding the ```-a``` to the end of the ```git branch``` command.

##### Note: when making a branch from main, make sure that you have the latest changes from the main branch.

```bash 
git checkout main
git fetch   #fetch grabs all the changes from the repo
git pull
```

---

### Committing Changes

When you are done with developing in your branch you can commit changes to repo:
```bash
#Adds changes to the commit
git add .
#Adds/Pushes the Commit to the Repo
git commit -m "<what this commit adds>"
git push
```

You can also view the commit history with:
```bash 
git log     #shows previous git commits 
```
In the case that your branch was just created and hasn't commited before:
```bash 
#this configures your local branch with a repo branch
git push --set-upstream origin <branch_name>
```

---

### Merging 

When your changes have been pushed to the repo, they are still not in the main branch. To merge to the main repo:
```bash
#make sure your changes are in the repo from local
git status 
#navigate to the main branch/check for updates/push
git checkout main
git fetch
git merge <merging_branch>
git push
```
In the case for your branch not having the main updated code
```bash 
git checkout <branch_name>
git pull --set-upstream origin main
git status
git checkout main
git merge <branch_name>
git push
```

---

### Diverging 

Sometimes when you are trying to push code, your branch will have diverged. This can be solved by going through both codes, and try to resolve it manually. In the case that you dont want your code anymore, and just want to grab the code from whats on the repo:
```bash 
git reset origin <branch_name>
```

When doing this and it still doesn't work add ``` --hard ``` to the end for a force reset

##### Note: Only do this if it is ABSOLUTELY NEEDED. You will lose all data if it is not saved somewhere else.
 
 ---

### Helpful Commands

There are some commands that are good to know:
``` git status ``` - checks the if there are changes on your local branch compared to the repo branch
``` git fetch ``` - grabs the data from the repo, to check for any updates
``` git diff ``` - checks for the differences between files on the local compared to the repo in the terminal
``` git checkout ``` - allows you to travel between the different local branchs
``` git pull --set-upstream origin <target_branch>``` - sets up a connection between different repo branches and the local branch your in. This is used for pushing and pulling.
