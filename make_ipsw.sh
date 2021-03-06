#!/bin/bash
echo "**** s0meiyoshino v2.0b4 make_ipsw.sh ****"

echo "iPhone3,1 only"
Identifier="iPhone3,1"

#### Set support device information ####
if [ "$Identifier" = "iPhone3,1" ]; then
    InternalName="n90ap"
    SoC="s5l8930x"
    Image="2x~iphone-30pin"
    BaseFWVer="7.1.2"
    BaseFWBuild="11D257"
fi

#### Find base firmware ####
if [ -e ""$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw" ]; then
    echo ""$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw OK"
else
    echo ""$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw does not exist"
exit
fi

#### Set macOS version ####
OSXVer=`sw_vers -productVersion | awk -F. '{print $2}'`

echo "Select downgrade iOS version"
select iOSVer in "iOS 4" "iOS 5" "iOS 6" "iOS 7" exit
do

    #### iOS 4.x ####
    if [ "$iOSVer" = "iOS 4" ]; then
        iOSLIST="4"

        echo "Select iOS 4.x"
        select iOSVers in "iOS 4.3.3 [BETA]" "iOS 4.3.5"
        do
            #### iOS 4.3.3 ####
            if [ "$iOSVers" = "iOS 4.3.3 [BETA]" ]; then
                ## iBoot-1072.61~2
                iOS4Switch="433"
                iOSVersion="4.3.3_8J2"
                iOSBuild="8J2"
                RestoreRamdisk="038-1449-003.dmg"
                iBoot_Key="c2ead1d3b228a05b665c91b4b1ab54b570a81dffaf06eaf1736767bcb86e50de"
                iBoot_IV="bb3fc29dd226fac56086790060d5c744"
                LLB_Key="63083d71e1039bca175ac4958bcb502f655f59a56c7008d516328389a3abae4f"
                LLB_IV="598c1dc81a30e794814d884d4baca4a9"
            fi
            #### iOS 4.3.5 ####
            if [ "$iOSVers" = "iOS 4.3.5" ]; then
                ## iBoot-1072.61~6
                iOS4Switch="435"
                iOSVersion="4.3.5_8L1"
                iOSBuild="8L1"
                RestoreRamdisk="038-2265-002.dmg"
                iBoot_Key="b4e300c54a9dd2e648ead50794e9bf2205a489c310a1c70a9fae687368229468"
                iBoot_IV="986032eecd861c37ca2a86b6496a3c0d"
            fi

            #### make scab ####
            echo "Please connect the target device to USB."
            read -p "<enter>: "
            echo "getting shsh..."
            ECID="$((./bin/idevicerestore -t "$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw) | sed -n -e 's/^.*Found ECID //p')"
            if [ -e "shsh/"$ECID"-iPhone3,1-7.1.2.shsh" ]; then
                zcat< shsh/"$ECID"-iPhone3,1-7.1.2.shsh > shsh/"$ECID"-iPhone3,1-7.1.2.plist
                plutil -extract 'APTicket' xml1 shsh/"$ECID"-iPhone3,1-7.1.2.plist -o 'shsh/apticket.plist'
                cat shsh/apticket.plist | sed -ne '/<data>/,/<\/data>/p' | sed -e "s/<data>//" | sed  "s/<\/data>//" | awk '{printf "%s",$0}' | base64 --decode > shsh/apticket.der
                bin/xpwntool shsh/apticket.der src/"$ECID"-apticket.img3 -t src/scab_template.img3

                rm shsh/apticket.der
                rm shsh/apticket.plist
                rm shsh/"$ECID"-iPhone3,1-7.1.2.plist
                break
            fi

            echo "failed get shsh"
            echo "Re-Select iOS 4.x"
        done
        break
    fi

    #### iOS 5.x ####
    if [ "$iOSVer" = "iOS 5" ]; then
        iOSLIST="6"
        echo "Select iOS 5.x"
        select iOSVers in "iOS 5.1.1"
        do
            #### iOS 5.1.1 ####
            if [ "$iOSVers" = "iOS 5.1.1" ]; then
                ## iBoot-1219.62.15~2
                iOSVersion="5.1.1_9B206"
                iOSBuild="9B206"
                RestoreRamdisk="038-4361-021.dmg"
                iBoot_Key="e8e26976984e83f967b16bdb3a65a3ec45003cdf2aaf8d541104c26797484138"
                iBoot_IV="b1846de299191186ce3bbb22432eca12"
                Boot_Partition_Patch="000081a: 00200020"
                break
            fi
        done
        break
    fi

    #### iOS 6.x ####
    if [ "$iOSVer" = "iOS 6" ]; then
        iOSLIST="6"
        Boot_Partition_Patch="0000a6c: 00200020"
        echo "Select iOS 6.x"
        select iOSVers in "iOS 6.0" "iOS 6.0.1" "iOS 6.1" "iOS 6.1.2" "iOS 6.1.3"
        do
            #### iOS 6.0 ####
            if [ "$iOSVers" = "iOS 6.0" ]; then
                ## iBoot-1537.4.18~2
                iOSVersion="6.0_10A403"
                iOSBuild="10A403"
                RestoreRamdisk="038-6451-001.dmg"
                iBoot_Key="838270f668a05a60ff352d8549c06d2f21c3e4f7617c72a78d82c92a3ad3a045"
                iBoot_IV="7891928b9dd0dd919778743a2c8ec6b3"
                break
            fi
            #### iOS 6.0.1 ####
            if [ "$iOSVers" = "iOS 6.0.1" ]; then
                ## iBoot-1537.4.21~3
                iOSVersion="6.0.1_10A523"
                iOSBuild="10A523"
                RestoreRamdisk="038-7924-011.dmg"
                iBoot_Key="8d539232c0e906a9f60caa462f189530f745c4abd81a742b4d1ec1cb8b9ca6c3"
                iBoot_IV="44ffe675d6f31167369787a17725d06c"
                break
            fi
            #### iOS 6.1 ####
            if [ "$iOSVers" = "iOS 6.1" ]; then
                ## iBoot-1537.9.55~4
                iOSVersion="6.1_10B144"
                iOSBuild="10B144"
                RestoreRamdisk="048-0804-001.dmg"
                iBoot_Key="891ed50315763dac51434daeb8543b5975a555fb8388cc578d0f421f833da04d"
                iBoot_IV="4d76b7e25893839cfca478b44ddef3dd"
                break
            fi
            #### iOS 6.1.2 ####
            if [ "$iOSVers" = "iOS 6.1.2" ]; then
                ## iBoot-1537.9.55~4
                iOSVersion="6.1.2_10B146"
                iOSBuild="10B146"
                RestoreRamdisk="048-1037-002.dmg"
                iBoot_Key="cbcd007712618cb6ab3be147f0317e22e7cceadb344e99ea1a076ef235c2c534"
                iBoot_IV="c939629e3473fdb67deae0c45582506d"
                break
            fi
            #### iOS 6.1.3 ####
            if [ "$iOSVers" = "iOS 6.1.3" ]; then
                ## iBoot-1537.9.55~11
                iOSVersion="6.1.3_10B329"
                iOSBuild="10B329"
                RestoreRamdisk="048-2441-007.dmg"
                iBoot_Key="3dbe8be17af793b043eed7af865f0b843936659550ad692db96865c00171959f"
                iBoot_IV="b559a2c7dae9b95643c6610b4cf26dbd"
                break
            fi
        done
        break
    fi

    #### iOS 7.x ####
    if [ "$iOSVer" = "iOS 7" ]; then
        iOSLIST="7"
        Boot_Partition_Patch="0000a54: 00200020"
        echo "Select iOS 7.x"
        select iOSVers in "iOS 7.0" "iOS 7.0.2" "iOS 7.0.3" "iOS 7.0.4" "iOS 7.0.6" "iOS 7.1" "iOS 7.1.1"
        do
            #### iOS 7.0 ####
            if [ "$iOSVers" = "iOS 7.0" ]; then
                ## iBoot-1940.1.75~20
                iOSVersion="7.0_11A465"
                iOSBuild="11A465"
                RestoreRamdisk="038-3373-256.dmg"
                iBoot_Key="e1fef31c8aabcdca2a3887ba21c0e2113c41a5617380657ab6a487993b39f9a8"
                iBoot_IV="5bf099d9db5cf1009329e527a378c8be"
                break
            fi
            #### iOS 7.0.2 ####
            if [ "$iOSVers" = "iOS 7.0.2" ]; then
                ## iBoot-1940.1.75~93
                iOSVersion="7.0.2_11A501"
                iOSBuild="11A501"
                RestoreRamdisk="048-9414-002.dmg"
                iBoot_Key="5cd910c268813cb4008e5b33e01f761c0794ed1437737b4d386727d17fac79d1"
                iBoot_IV="65db9a4e4f64bb79a55d76d98ce1457b"
                break
            fi
            #### iOS 7.0.3 ####
            if [ "$iOSVers" = "iOS 7.0.3" ]; then
                ## iBoot-1940.3.5~1
                iOSVersion="7.0.3_11B511"
                iOSBuild="11B511"
                RestoreRamdisk="058-0322-002.dmg"
                iBoot_Key="bd56f0886e21f233f519d4db20fd044b9208882a6fb791553a75eb4e0c45bbc5"
                iBoot_IV="7cb97df787dcc6367816b03492b225f9"
                break
            fi
            #### iOS 7.0.4 ####
            if [ "$iOSVers" = "iOS 7.0.4" ]; then
                ## iBoot-1940.3.5~1
                iOSVersion="7.0.4_11B554a"
                iOSBuild="11B554a"
                RestoreRamdisk="058-1056-002.dmg"
                iBoot_Key="2a6940252b5cb19b86efb9005cdd5fd713290e573dc760f5a3e05df9e868bb89"
                iBoot_IV="67087ac7f28c77cdf9110356f476540b"
                break
            fi
            #### iOS 7.0.6 ####
            if [ "$iOSVers" = "iOS 7.0.6" ]; then
                ## iBoot-1940.3.5~1
                iOSVersion="7.0.6_11B651"
                iOSBuild="11B651"
                RestoreRamdisk="058-2320-001.dmg"
                iBoot_Key="d7b5bb9b90f19493449ab17fda63afdb16069ad5b65026bb11b4db223fdd4be1"
                iBoot_IV="12af3a975f0346e89d3a34e73b4e0ae1"
                break
            fi
            #### iOS 7.1 ####
            if [ "$iOSVers" = "iOS 7.1" ]; then
                ## iBoot-1940.10.58~115
                iOSVersion="7.1_11D169"
                iOSBuild="11D169"
                RestoreRamdisk="058-4107-003.dmg"
                iBoot_Key="b68612f21e377bd1f685e9031be159a724e931eff162db245c63b7b692cefa7e"
                iBoot_IV="9fe5b6785126c8fc5787582df9efcf94"
                break
            fi
            #### iOS 7.1.1 ####
            if [ "$iOSVers" = "iOS 7.1.1" ]; then
                ## iBoot-1940.10.58~122
                iOSVersion="7.1.1_11D201"
                iOSBuild="11D201"
                RestoreRamdisk="058-00093-002.dmg"
                iBoot_Key="c6fbf428e0105ab22b2abaefd20ca22c2084e200f74e8a3b08298a54f8bfe28f"
                iBoot_IV="b110991061d76f74c1fc05ddd7cff540"
                break
            fi
        done
        break
    fi
    if [ "$iOSVer" = "exit" ]; then
        exit
    fi
done

if [ -e ""$Identifier"_"$iOSVersion"_Restore.ipsw" ]; then
    echo ""$Identifier"_"$iOSVersion"_Restore.ipsw OK"
else
    echo ""$Identifier"_"$iOSVersion"_Restore.ipsw does not exist"
    exit
fi

if [ -d "tmp_ipsw" ]; then
    rm -r tmp_ipsw
    rm -r FirmwareBundles/*
fi

echo ""

#### Setting Firmware Bundles ####
if [ "$iOSLIST" = "7" ]; then
    #### Jailbreak7?? ####
    echo "Jailbreak?"
    select Jailbreak in Yes No
    do
        if [ "$Jailbreak" = "Yes" ]; then
            JB="enable"
            cp -a Bundles/JB_"$Identifier"_"$iOSVersion".bundle FirmwareBundles/
            break
        fi
        if [ "$Jailbreak" = "No" ]; then
            JB="disable"
            cp -a Bundles/Down_"$Identifier"_"$iOSVersion".bundle FirmwareBundles/
            break
        fi
    done
else
    if [ "$iOSLIST" = "4" ]; then
        cp -a Bundles/Down_"$Identifier"_"$iOSVersion".bundle FirmwareBundles/
    else
        JB="disable"
        cp -a Bundles/Down_"$Identifier"_"$iOSVersion".bundle FirmwareBundles/
    fi
fi

mkdir tmp_ipsw
cd tmp_ipsw

#### Decrypt iBoot ####
unzip -j ../"$Identifier"_"$iOSVersion"_Restore.ipsw "Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3"
../bin/xpwntool iBoot."$InternalName".RELEASE.img3 iBoot."$InternalName".dec.img3 -k $iBoot_Key -iv $iBoot_IV -decrypt
../bin/xpwntool iBoot."$InternalName".dec.img3 iBoot."$InternalName".dec
echo ""

if [ "$iOSLIST" = "4" ]; then

    #### iOS4Switch = 433 ####
    if [ "$iOS4Switch" = "433" ]; then
        #### Patching LLB4 ####
        unzip -j ../"$Identifier"_"$iOSVersion"_Restore.ipsw "Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3"
        ../bin/xpwntool LLB."$InternalName".RELEASE.img3 LLB."$InternalName".dec.img3 -k $LLB_Key -iv $LLB_IV -decrypt
        ../bin/xpwntool LLB."$InternalName".dec.img3 LLB."$InternalName".dec
        bspatch LLB."$InternalName".dec PwnedLLB."$InternalName".dec ../FirmwareBundles/Down_"$Identifier"_"$iOSVersion".bundle/LLB."$InternalName".RELEASE.patch
        ../bin/xpwntool PwnedLLB."$InternalName".dec iBoot -t LLB."$InternalName".dec.img3
        echo "0000010: 63656269" | xxd -r - iBoot
        echo "0000020: 63656269" | xxd -r - iBoot
        tar -cvf bootloader4.tar iBoot
        #### Patching iBoot4 ####
        bspatch iBoot."$InternalName".dec PwnediBoot."$InternalName".dec ../FirmwareBundles/Down_"$Identifier"_"$iOSVersion".bundle/iBoot."$InternalName".RELEASE.patch
        ../bin/xpwntool PwnediBoot."$InternalName".dec iBoot4 -t iBoot."$InternalName".dec.img3
        echo "0000010: 346F6269" | xxd -r - iBoot4
        echo "0000020: 346F6269" | xxd -r - iBoot4
    fi

    #### iOS4Switch = 435 ####
    if [ "$iOS4Switch" = "435" ]; then
        #### Patching iBoot4 ####
        bspatch iBoot."$InternalName".dec PwnediBoot."$InternalName".dec ../FirmwareBundles/Down_"$Identifier"_"$iOSVersion".bundle/iBoot."$InternalName".RELEASE.patch
        ../bin/xpwntool PwnediBoot."$InternalName".dec iBoot -t iBoot."$InternalName".dec.img3
        echo "0000010: 63656269" | xxd -r - iBoot
        echo "0000020: 63656269" | xxd -r - iBoot
        tar -cvf bootloader4.tar iBoot
    fi

else
    #### Patching iBoot5/6/7 ####
    if [ "$JB" = "enable" ]; then
        echo "Enable verbose boot?"
        select Verbose in Yes No
        do
            if [ "$Verbose" = "Yes" ]; then
                ../bin/iBoot32Patcher iBoot."$InternalName".dec PrePwnediBoot."$InternalName".dec -r -d -b "cs_enforcement_disable=1 amfi=0xff -v"
                bspatch PrePwnediBoot."$InternalName".dec PwnediBoot."$InternalName".dec ../FirmwareBundles/JB_"$Identifier"_"$iOSVersion".bundle/iBoot."$InternalName".RELEASE.patch
                break
            fi
            if [ "$Verbose" = "No" ]; then
                ../bin/iBoot32Patcher iBoot."$InternalName".dec PrePwnediBoot."$InternalName".dec -r -d -b "cs_enforcement_disable=1 amfi=0xff"
                bspatch PrePwnediBoot."$InternalName".dec PwnediBoot."$InternalName".dec ../FirmwareBundles/JB_"$Identifier"_"$iOSVersion".bundle/iBoot."$InternalName".RELEASE.patch
                break
            fi
        done
    fi

    if [ "$JB" = "disable" ]; then
        echo "Enable verbose boot?"
        select Verbose in Yes No
        do
            if [ "$Verbose" = "Yes" ]; then
                ../bin/iBoot32Patcher iBoot."$InternalName".dec PwnediBoot."$InternalName".dec -r -d -b "-v"
                break
            fi
            if [ "$Verbose" = "No" ]; then
                ../bin/iBoot32Patcher iBoot."$InternalName".dec PwnediBoot."$InternalName".dec -r -d
                break
            fi
        done
    fi

    echo "$Boot_Partition_Patch" | xxd -r - PwnediBoot."$InternalName".dec
    ../bin/xpwntool PwnediBoot."$InternalName".dec PwnediBoot."$InternalName".img3 -t iBoot."$InternalName".dec.img3
    echo "0000010: 63656269" | xxd -r - PwnediBoot."$InternalName".img3
    echo "0000020: 63656269" | xxd -r - PwnediBoot."$InternalName".img3
    mv -v PwnediBoot."$InternalName".img3 iBEC
    tar -cvf bootloader.tar iBEC
fi

cd ../
#### Make custom ipsw by odysseus ####
if [ "$iOSLIST" = "4" ]; then
    ./bin/ipsw "$Identifier"_"$iOSVersion"_Restore.ipsw tmp_ipsw/"$Identifier"_"$iOSVersion"_Odysseus.ipsw -memory -ramdiskgrow 2000
fi

if [ "$JB" = "enable" ]; then
    ./bin/ipsw "$Identifier"_"$iOSVersion"_Restore.ipsw tmp_ipsw/"$Identifier"_"$iOSVersion"_Odysseus.ipsw -memory -ramdiskgrow 2000 tmp_ipsw/bootloader.tar src/Cydia7.tar
fi

if [ "$JB" = "disable" ]; then
    ./bin/ipsw "$Identifier"_"$iOSVersion"_Restore.ipsw tmp_ipsw/"$Identifier"_"$iOSVersion"_Odysseus.ipsw -memory -ramdiskgrow 2000 tmp_ipsw/bootloader.tar
fi

#### Confirm existence of firmware ####
if [ -e "tmp_ipsw/"$Identifier"_"$iOSVersion"_Odysseus.ipsw" ]; then
    echo "success"
else
    echo "failed make ipsw"
    exit
fi

#### Make CFW ####
cd tmp_ipsw

mkdir $BaseFWBuild
unzip -j ../"$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw "Firmware/all_flash/all_flash."$InternalName".production/*" -d $BaseFWBuild

mkdir $iOSBuild
unzip -d $iOSBuild "$Identifier"_"$iOSVersion"_Odysseus.ipsw

if [ "$iOSLIST" = "4" ]; then

    if [ "$iOS4Switch" = "433" ]; then
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest

        echo "0000010: 34676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo-640x960."$SoC".img3
        echo "0000020: 34676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo-640x960."$SoC".img3

        mv -v ../src/"$ECID"-apticket.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/apticket.img3
        cp -a -v ../src/manifest433 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest

        if [ "$OSXVer" -gt "10" ]; then
            mv -v $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/apticket.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogoT-640x960."$SoC".img3
            cp -a -v ../src/manifest433x $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest
        fi

        cp -a -v ../src/433.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogoX-640x960."$SoC".img3
        echo "0000010: 58676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogoX-640x960."$SoC".img3
        echo "0000020: 58676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogoX-640x960."$SoC".img3

        mv -v iBoot4 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot4."$InternalName".RELEASE.img3

        mv -v $BaseFWBuild/applelogo@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo7-640x960."$SoC".img3
        mv -v $BaseFWBuild/batterycharging0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0-640x960."$SoC".img3
        mv -v $BaseFWBuild/batterycharging1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1-640x960."$SoC".img3
        mv -v $BaseFWBuild/batteryfull@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull-640x960."$SoC".img3
        mv -v $BaseFWBuild/batterylow0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0-640x960."$SoC".img3
        mv -v $BaseFWBuild/batterylow1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1-640x960."$SoC".img3
        mv -v $BaseFWBuild/glyphplugin@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin-640x960."$SoC".img3
        mv -v $BaseFWBuild/iBoot."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
        mv -v $BaseFWBuild/LLB."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
        mv -v $BaseFWBuild/recoverymode@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode-640x960."$SoC".img3
    fi

    if [ "$iOS4Switch" = "435" ]; then
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest

        echo "0000010: 34676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo-640x960."$SoC".img3
        echo "0000020: 34676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo-640x960."$SoC".img3

        mv -v ../src/"$ECID"-apticket.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/apticket.img3
        cp -a -v ../src/manifest4 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest

        if [ "$OSXVer" -gt "10" ]; then
            mv -v $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/apticket.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogoT-640x960."$SoC".img3
            cp -a -v ../src/manifest4x $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest
        fi

        mv -v $BaseFWBuild/applelogo@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo7-640x960."$SoC".img3
        mv -v $BaseFWBuild/batterycharging0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0-640x960."$SoC".img3
        mv -v $BaseFWBuild/batterycharging1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1-640x960."$SoC".img3
        mv -v $BaseFWBuild/batteryfull@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull-640x960."$SoC".img3
        mv -v $BaseFWBuild/batterylow0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0-640x960."$SoC".img3
        mv -v $BaseFWBuild/batterylow1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1-640x960."$SoC".img3
        mv -v $BaseFWBuild/glyphplugin@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin-640x960."$SoC".img3
        mv -v $BaseFWBuild/iBoot."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
        mv -v $BaseFWBuild/LLB."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
        mv -v $BaseFWBuild/recoverymode@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode-640x960."$SoC".img3
    fi

fi

if [ "$iOSLIST" = "6" ]; then
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode@2x~iphone."$SoC".img3
    mv -v $BaseFWBuild/applelogo@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo@2x."$SoC".img3
    mv -v $BaseFWBuild/batterycharging0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0@2x."$SoC".img3
    mv -v $BaseFWBuild/batterycharging1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1@2x."$SoC".img3
    mv -v $BaseFWBuild/batteryfull@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull@2x."$SoC".img3
    mv -v $BaseFWBuild/batterylow0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0@2x."$SoC".img3
    mv -v $BaseFWBuild/batterylow1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1@2x."$SoC".img3
    mv -v $BaseFWBuild/glyphplugin@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin@2x."$SoC".img3
    mv -v $BaseFWBuild/iBoot."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
    mv -v $BaseFWBuild/LLB."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
    mv -v $BaseFWBuild/recoverymode@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode@2x~iphone."$SoC".img3
fi

if [ "$iOSLIST" = "7" ]; then
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin@"$Image"."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode@"$Image"."$SoC".img3
    mv -v $BaseFWBuild/applelogo@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v $BaseFWBuild/batterycharging0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v $BaseFWBuild/batterycharging1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v $BaseFWBuild/batteryfull@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v $BaseFWBuild/batterylow0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v $BaseFWBuild/batterylow1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v $BaseFWBuild/glyphplugin@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v $BaseFWBuild/iBoot."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v $BaseFWBuild/LLB."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v $BaseFWBuild/recoverymode@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
fi

#### make ramdisk ####
../bin/xpwntool $iOSBuild/$RestoreRamdisk $iOSBuild/ramdisk.dmg
if [ -e ""$iOSBuild"/ramdisk.dmg" ]; then
    echo "OK"
else
    echo "failed"
    exit
fi

if [ "$iOSLIST" = "4" ]; then
    hdiutil resize $iOSBuild/ramdisk.dmg -size 30m
fi

hdiutil attach -mountpoint ramdisk/ $iOSBuild/ramdisk.dmg
sleep 1s

if [ "$iOSLIST" = "4" ]; then
    mv -v ramdisk/sbin/reboot ramdisk/sbin/._

    if [ "$iOS4Switch" = "433" ]; then
        tar -xvf ../src/bin433.tar -C ramdisk/ --preserve-permissions
    fi

    if [ "$iOS4Switch" = "435" ]; then
        tar -xvf ../src/bin4.tar -C ramdisk/ --preserve-permissions
    fi

    tar -xvf bootloader4.tar -C ramdisk/ --preserve-permissions
else
    tar -xvf ../src/bin.tar -C ramdisk/ --preserve-permissions
    mv -v ramdisk/sbin/reboot ramdisk/sbin/reboot_
    cp -a -v ../src/partition.sh ramdisk/sbin/reboot
    cp -a -v ../src/ramdiskH.dmg ramdisk/
    chmod 755 ramdisk/sbin/reboot
fi

if [ "$iOSLIST" = "7" ]; then
    mv -v ramdisk/usr/share/progressui/applelogo@2x.tga ramdisk/usr/share/progressui/applelogo_orig.tga
    bspatch ramdisk/usr/share/progressui/applelogo_orig.tga ramdisk/usr/share/progressui/applelogo@2x.tga ../patch/applelogo7.patch
else
    mv -v ramdisk/usr/share/progressui/images-2x/applelogo.png ramdisk/usr/share/progressui/images-2x/applelogo_orig.png
    bspatch ramdisk/usr/share/progressui/images-2x/applelogo_orig.png ramdisk/usr/share/progressui/images-2x/applelogo.png ../patch/applelogo.patch
fi

sleep 1s

hdiutil detach ramdisk/
sleep 1s

mv $iOSBuild/$RestoreRamdisk $iOSBuild/t.dmg
../bin/xpwntool $iOSBuild/ramdisk.dmg $iOSBuild/$RestoreRamdisk -t $iOSBuild/t.dmg
rm $iOSBuild/ramdisk.dmg
rm $iOSBuild/t.dmg

rm -r $BaseFWBuild

#### zipping ipsw ####
cd $iOSBuild
zip ../../"$Identifier"_"$iOSVersion"_Custom.ipsw -r0 *

#### clean up ####
cd ../../
rm -r tmp_ipsw
rm -r FirmwareBundles/*

#### Done ####
echo "Done!"