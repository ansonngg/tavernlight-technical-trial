# Tavernlight Technical Trial Task

This is my solution of the technical trial task given by Tavernlight Games. In Question 5-7, I have tried to replicate the file structure of TFS and OTC, and those directories only contain files that have changes from me. If a file is not created by me, e.g. a source file that originally exists in [edubart/otclient](https://github.com/edubart/otclient), all the changes inside that file are surrounded by `// Change start` and `// Change end` (or `-- Change start` and `-- Change end` in Lua scripts) comments.

## Instructions

1. Unzip all the files in `Environment`.
1. Run `UniServerZ/UniController.exe`.
1. Click "Start Apache" and "Start MySQL". Two pages will pop up. You may simply close them.
1. Go to [EPuncker/1098extended](https://github.com/EPuncker/1098extended), download `dat and spr.zip` and unzip it.
1. Create a new directory in `otclient/data/things` with name `1098`.
1. Copy `Tibia.dat` and `Tibia.spr` from the unzipped `dat and spr.zip` to the new directory you have just created.
1. Run `forgottenserver/theforgottenserver-x64.exe`
1. Run `otclient/otclient.exe`

Now you can login with:
- Account name: otcadmin
- Password: otcadmin
- Server: 127.0.0.1
- Client Version: 1098
- Port: 7171

Enjoy!
