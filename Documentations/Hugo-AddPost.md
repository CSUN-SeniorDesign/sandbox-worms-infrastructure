# How to Add Posts #
## Goal ##
The goal is to add a new entry in the blog. 

## Assumptions:  ##
1. Hugo is installed
2. Git is installed
3. Blog Post Repo is cloned in the computer

## Workflow: ##
1. Create a new branch on the repo
2. Create a new post using hugo cli
3. Edit the .md file that will be created
4. Verify the functionality of the site
5. Commit and Push the change
5. When confident, merge the master to the branch
6. Delete branch
## Instructions ##
1. Open GIT CMD or GIT BASH
2. Navigate to the Repos directory
3. git pull origin master
4. git checkout -b newpostAubrey
5. hugo new article/my-blog-title.md
6. Edit the article/my-blog-title.md using a text or markdown editor.
	- Change the title:
	- Change the draft:true
	- Add categories: [Project 0]
	- Add tags: []
	- Add author: "Aubrey Nigoza"
7. Save it.
8. Go back to CLI (GIT BASH or GIT CMD)
9. hugo server #press ctrl + c to end
10. git status
11. git add .
12. git status
13. git commit -m "my post for the week"
14. git push origin newpostAubrey 
15. git status
16. git checkout master
17. git merge newpostAubrey
18. git branch -d newpostAubrey
19. git push --delete origin newpostAubrey