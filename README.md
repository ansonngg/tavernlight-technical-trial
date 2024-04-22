# Tavernlight Technical Trial Task

This is my solution of the technical trial task given by Tavernlight Games. In Question 5-7, I have tried to replicate the file structure of TFS and OTC, and those directories only contain files that have changes from me. If a file is not created by me, e.g. a source file that originally exists in [edubart/otclient](https://github.com/edubart/otclient), all the changes inside that file are surrounded by `// Change start` and `// Change end` (or `-- Change start` and `-- Change end` in Lua scripts) comments.

## Instructions

First, unzip all the files in `Environment`.

### Database

- Run `Environment/UniServerZ/UniController.exe`.
    - It may ask you to change your MySQL root password. It is highly recommended to do so.
- Click "Start Apache" and "Start MySQL". Two pages will pop up. You may close them at the moment.
- Click "phpMyAdmin". A page will then pop up.
- You might want to change your password hashing to "Native MySQL authentication" since TFS doesn't provide the required dll to support password hashing
    - You can change it by clicking "User accounts" at the top and clicking "Change password".
- Create a new database by clicking "New" on the left sidebar.
- Select your database name and click "Create".
- At the top, click the "Import" button.
- Click "Choose File" and choose `Environment/forgottenserver/schema.sql`.
- Scroll down and click "Import".
- Repeat the above two steps to import `Environment/UniServerZ/www/engine/database/znote_schema.sql`.

### Server Configuration

- Open `Environment/forgottenserver/config.lua`.
- Locate `mysqlUser`, `mysqlPass` and `mysqlDatabase`, and change their values accordingly.
    - `mysqlUser`: The account that has access to the database you have just created.
    - `mysqlPass`: The password of the account above.
    - `mysqlDatabase`: The name of the database you have just created.

### Character Creation

- Open `Environment/UniServerZ/www/config.php`.
- Locate `$config['sqlUser']`, `$config['sqlPassword']` and `$config['sqlDatabase']`, and change their values like how you did in [Server Configuration](#server-configuration).
- Go back to the UniController. Click "View www". A page will then pop up
- Use that page to create an account and a character.

### Client Setup

- Go to [EPuncker/1098extended](https://github.com/EPuncker/1098extended), download `dat and spr.zip` and unzip it.
- Create a new directory in `Environment/otclient/data/things` with name `1098`.
- Copy `Tibia.dat` and `Tibia.spr` from the unzipped files to the new directory you have just created.

Everything is set up! You may now run `Environment/otclient/otclient.exe` and `Environment/forgottenserver/theforgottenserver-x64.exe` to try my works! You can login by setting:
- Server: 127.0.0.1 (localhost)
- Client Version: 1098
- Port: 7171
