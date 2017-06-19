### macOS Drive Mounter
Bash script to automatically mount network drives on macOS on a schedule. 

The script ensures that the drive is available via ping. If it is available and is not already mounted, it 
attempts to mount the drive. The script runs as a ```launchd``` job every 30 seconds. 

#### Set Up
To install, first list the drives in the ```private.drive_mounter.conf``` file. The file should have one 
address per line and specify the protocol and mount point like the example below.

```
smb://192.168.9.20/Shared
afp://192.168.9.21/Backups
```

Connect to each of the servers using the Go/Connect to Server menu of the Finder application. When connecting
check the box that will save the credentials in the KeyChain so that the drives can automatically authenticate.

NOTE: The configuration file is located at: ```~/.drive_mounter.conf```. The install script renames the 
```private.drive_mounter.conf``` to ```.drive_mounter.conf``` and copies it to ```~/```.

Give the ```install.sh``` execute permissions with ```chmod +x ./install.sh``` and 
run the script with ```./install.sh```. The installer will take the following actions:

NOTE: the steps below are explanatory and will be automatically completed by the install script.

* Copy the drive mounter script to the ```/usr/local/bin``` directory and grant it execute permissions.
* Copy the LaunchAgent ```.plist``` file to the user LaunchAgents directory at ```~/Library/LaunchAgents```
* Copy the configuration file to the ```~/``` directory. 
* Unloads the previous LaunchAgent file and reloads the (potentially) new file. 