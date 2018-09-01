# Deploy Blog Post #
## Goal ##
The goal is to generate the static html and copy it over to the webserver.
## Workflow: ##
1. Generate static html
2. Connect to EC2 using SCP protocol (use winscp)
3. Copy the files to your homedirectory
4. Use sudo to move the over to the DocumentRoot

## Instructions ##
1. On Git Bash, Git CMD, or CMD navigate to the hugo directory
2. Make sure the /templates folder is not empty
3. If templates folder is empty, navigate to the templates folder and clone the git of our template: https://github.com/Lednerb/bilberry-hugo-theme.git
4. Make sure you are at the parent folder of the blog repo
5. hugo
6. The static html files will be generated in the public folder. 
7. Open WinSCP
8. Connect to the server using your username and private key
9. Copy the html files to your home directory
10. Login to the EC2 instance using putty (ssh)
11. Use sudo to delete the files in the Documentroot (/var/www/html/) (rm /path/to/directory/* -r)
12. Use sudo to move the static html files to the DocumentRoot (mv /path/sourcefolder/* /path/destinationfolder/)
13. sudo restorecon -r /var/www

