#!/bin/sh  

# Fix black screen in VMWare Fusion 10 on macOS Catalina
# Script must be executed with disabled SIP

tccutil reset All com.vmware.fusion
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" 'insert into access values ("kTCCServiceScreenCapture", "com.vmware.fusion", 0, 1, 1, "", "", "", "UNUSED", "", 0,1565595574)'  
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" 'insert into access values ("kTCCServiceListenEvent", "com.vmware.fusion", 0, 1, 1, "", "", "", "UNUSED", "", 0,1565595574)'   
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" 'insert into access values ("kTCCServicePostEvent", "com.vmware.fusion", 0, 1, 1, "", "", "", "UNUSED", "", 0,1565595574)'