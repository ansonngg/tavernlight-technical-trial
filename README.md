# Tavernlight Technical Trial Task

This is my solution of the technical trial task given by Tavernlight Games. In Question 5-7, I have tried to replicate the file structure of TFS and OTC, and those directories only contain files that have changes from me. If a file is not created by me, e.g. a source file that originally exists in [edubart/otclient](https://github.com/edubart/otclient), all the changes inside that file are surrounded by `// Change start` and `// Change end` (or `-- Change start` and `-- Change end` in Lua scripts) comments.

## Instructions
1. Unzip all the files in `Environment`.
1. Run `Environment/UniServerZ/UniController.exe`.
1. It may ask you to change your MySQL root password. It is highly recommended to do so.
1. Click "Start Apache" and "Start MySQL". Two pages will pop up. You may close them at the moment.
1. Click "phpMyAdmin". A page will then pop up.
1. Create a new database by clicking "New" on the left sidebar.
1. Select your database name and click "Create".
1. At the top, click the "Import" button.
1. Click "Choose File" and choose `Environment/forgottenserver/schema.sql`.
1. Scroll down and click "Import".
1. Repeat the above two steps to import `Environment/UniServerZ/www/engine/database/znote_schema.sql`.
1. The database is now good to go. Now we need to configure the server config.
1. Open `Environment/forgottenserver/config.lua`.
1. Locate `mysqlUser`, `mysqlPass` and `mysqlDatabase`, and change their values accordingly.
1. `mysqlUser`: The account that has access to the database you have just created.
1. `mysqlPass`: The password of the account above.
1. `mysqlDatabase`: The name of the database you have just created.
1. Open `Environment/UniServerZ/www/config.php`.
1. Locate `$config['sqlUser']`, `$config['sqlPassword']` and `$config['sqlDatabase']`, and change their values like above.
1. Go back to the UniController. Click "View www". A page will then pop up
1. Use that page to create an account and a character.
1. Now we need to set up our client side. Since the size of the client software is too big, I couldn't commit it to the repository. Please go to [edubart/otclient](https://github.com/edubart/otclient) and follow their guide to compile your own client software.
1. Before compiling, copy all the files in `Question5/otclient`, `Question6/otclient` and `Question7/otclient` to the `otclient` you have just cloned, or if you have already compiled, compile again after copying the files.
1. Everything is set up! You may now run `Environment/otclient/otclient.exe` and `Environment/forgottenserver/theforgottenserver-x64.exe` to try my works! Just need to remember that the Server should be 127.0.0.1 (localhost), the Client Version should be 1098 and the Port should be 7171
