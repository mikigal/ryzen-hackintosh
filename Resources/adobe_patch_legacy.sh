#!/bin/bash

echo "Starting patching..."

for file in MMXCore FastCore TextModel libiomp5.dylib libtbb.dylib libtbbmalloc.dylib; do
    find /Applications/Adobe* -type f -name $file | while read -r FILE; do
        sudo -v
        echo "found $FILE"
        [[ ! -f ${FILE}.back ]] && sudo cp -f $FILE ${FILE}.back || sudo cp -f ${FILE}.back $FILE
        echo $FILE | grep libiomp5 >/dev/null
        if [[ $? == 0 ]]; then
            dir=$(dirname "$FILE")
            [[ ! -f ${HOME}/libiomp5.dylib ]] && cd $HOME && curl -sO https://excellmedia.dl.sourceforge.net/project/badgui2/libs/mac64/libiomp5.dylib
            echo -n "replacing " && sudo cp -vf ${HOME}/libiomp5.dylib $dir && echo
            rm -f ${HOME}/libiomp5.dylib
            continue
        fi
        echo $FILE | grep TextModel >/dev/null
        [[ $? == 0 ]] && echo "emptying $FILE" && sudo echo -n >$FILE && continue
        echo "patching $FILE \n"
        sudo perl -i -pe 's|\x90\x90\x90\x90\x56\xE8\x6A\x00|\x90\x90\x90\x90\x56\xE8\x3A\x00|sg' $FILE
        sudo perl -i -pe 's|\x90\x90\x90\x90\x56\xE8\x4A\x00|\x90\x90\x90\x90\x56\xE8\x1A\x00|sg' $FILE
    done
done

echo "Removing Deep_Font plugin"
sudo find /Applications/Adobe* -name "Deep_Font" -exec rm -r {} +

echo ""
echo "Adobe Patching done, remember to run ryzen_patch.sh too"