#!/bin/bash

test -f $HOME/Library/LaunchAgents/mkl.plist && echo "Patch was already used! You don't have to run it again" && exit
sudo -v

echo "Generating LaunchAgent for automatically applying MKL_DEBUG_CPU_TYPE..."

[ ! -d $HOME/Library/LaunchAgents ] && mkdir $HOME/Library/LaunchAgents
AGENT=$HOME/Library/LaunchAgents/mkl.plist
sysctl -n machdep.cpu.brand_string | grep FX >/dev/null 2>&1
x=$(echo $(($? != 0 ? 5 : 4)))
cat >$AGENT <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
 <key>Label</key>
 <string>mkl-debug</string>
 <key>ProgramArguments</key>
 <array>
 <string>sh</string>
 <string>-c</string>
    <string>launchctl setenv MKL_DEBUG_CPU_TYPE $x;</string>
 </array>
 <key>RunAtLoad</key>
 <true/>
</dict>
</plist>
EOF
launchctl load ${AGENT} >/dev/null 2>&1
launchctl start ${AGENT} >/dev/null 2>&1

echo "Applying required sleep/hibernate parameters..."
sudo pmset autopoweroff 0
sudo pmset powernap 0
sudo pmset standby 0
sudo pmset proximitywake 0
sudo pmset tcpkeepalive 0 > /dev/null

echo ""
echo "Done, reboot your Hackintosh!"