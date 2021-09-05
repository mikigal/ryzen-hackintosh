#!/bin/bash
# Credits to XLNC (https://gist.github.com/naveenkrdy/26760ac5135deed6d0bb8902f6ceb6bd)
# Credits to tomnic (https://www.macos86.it/profile/69-tomnic/) for libfakeintel.dylib

echo "Starting patching..."

files_list=(MMXCore FastCore TextModel libiomp5.dylib)
lib_dir="${HOME}/Documents/AdobeLibs"
lib1_file="${lib_dir}/libiomp5.dylib"
lib1_link="https://raw.githubusercontent.com/naveenkrdy/Misc/master/Libs/libiomp5.dylib"

for file in $files_list; do
    find /Applications/Adobe* -type f -name $file | while read -r curr_file; do
        name=$(basename $curr_file)
        sw_vers -productVersion | grep "11\|12" >/dev/null 2>&1
        [[ $? == 0 ]] && [[ $name =~ ^(MMXCore|FastCore)$ ]] && continue
        echo "found $curr_file"
        sudo -v
        [[ ! -f ${curr_file}.back ]] && sudo cp -f $curr_file ${curr_file}.back || sudo cp -f ${curr_file}.back $curr_file
        if [[ $name == "libiomp5.dylib" ]]; then
            [[ ! -d $lib_dir ]] && mkdir $lib_dir
            [[ ! -f $lib1_file ]] && cd $lib_dir && curl -sO $lib1_link
            adobelib_dir=$(dirname "$curr_file")
            echo -n "replacing " && sudo cp -vf $lib1_file $adobelib_dir
        elif [[ $name == "TextModel" ]]; then
            echo "emptying $curr_file"
            sudo echo -n >$curr_file
        else
            echo "patching $curr_file"
            sudo perl -i -pe 's|\x90\x90\x90\x90\x56\xE8\x6A\x00|\x90\x90\x90\x90\x56\xE8\x3A\x00|sg' $curr_file
            sudo perl -i -pe 's|\x90\x90\x90\x90\x56\xE8\x4A\x00|\x90\x90\x90\x90\x56\xE8\x1A\x00|sg' $curr_file
        fi
    done
done

agent_dir="${HOME}/Library/LaunchAgents"
env_file="${agent_dir}/environment.plist"
lib_dir="${HOME}/Documents/AdobeLibs"
lib2_file="${lib_dir}/libfakeintel.dylib"
lib2_link="https://raw.githubusercontent.com/naveenkrdy/Misc/master/Libs/libfakeintel.dylib"

sw_vers -productVersion | grep "11" >/dev/null 2>&1
if [[ $? == 0 ]]; then
    [[ ! -d $lib_dir ]] && mkdir $lib_dir
    [[ ! -f $lib2_file ]] && cd $lib_dir && curl -sO $lib2_link
    env="launchctl setenv DYLD_INSERT_LIBRARIES $lib2_file"
else
    mkl_value=$(
        sysctl -n machdep.cpu.brand_string | grep FX >/dev/null 2>&1
        echo $(($? != 0 ? 5 : 4))
    )
    env="launchctl setenv MKL_DEBUG_CPU_TYPE $mkl_value"
fi

[[ ! -d $agent_dir ]] && mkdir $agent_dir
cat >$env_file <<EOF
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
    <string>$env;</string>
 </array>
 <key>RunAtLoad</key>
 <true/>
</dict>
</plist>
EOF

launchctl load ${AGENT} >/dev/null 2>&1
launchctl start ${AGENT} >/dev/null 2>&1

echo "Removing Deep_Font plugin"
sudo find /Applications/Adobe* -name "Deep_Font" -exec rm -r {} +

echo ""
echo "Done, reboot your Hackintosh!"