cp ./drive_mounter.sh /usr/local/bin/drive_mounter.sh
chmod +x /usr/local/bin/drive_mounter.sh

cp ./com.cbergoon.drive_mounter.plist ~/Library/LaunchAgents/com.cbergoon.drive_mounter.plist

cp ./private.drive_mounter.conf ~/.drive_mounter.conf

launchctl unload ~/Library/LaunchAgents/com.cbergoon.drive_mounter.plist
launchctl load ~/Library/LaunchAgents/com.cbergoon.drive_mounter.plist