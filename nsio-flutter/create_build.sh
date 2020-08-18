#!/bin/bash

# An simple script to build APK and add an copy to $HOME/Desktop/.
# It will generate build which is pointed to main.dart
appName="NonStopIO"


invalidInput() {
    echo "Please select valid Input"
    echo ""
    echo ""
    echo ""
}


cleanAndBuildMain(){
    echo "Cleaning build...."
    flutter clean
    echo "Creating a new build...."
    FLUTTER build apk
}

cleanAndBuildDev(){
    echo "Cleaning build...."
    flutter clean
    echo "Creating a new DEV build...."
    appName="$appName-DEV"
    flutter build apk lib/dev.dart
    copyBuildToDesktop
}


copyBuildToDesktop(){
    if [[ $? == 0 ]]; then
        echo "Flutter build successful...."
        echo "Copying APK to " $HOME/Desktop/
        cp -f $PWD/build/app/outputs/apk/release/app-release.apk $HOME/Desktop/
        mv $HOME/Desktop/app-release.apk $HOME/Desktop/${appName}-$(date +%F-%H:%M).apk
        echo "APK copied to $HOME/Desktop/${appName}-$(date +%F-%H:%M).apk"
        echo "Done"
    else
        echo "Flutter Build Failed! "
    fi
}


chooseBuildType(){
    echo "Select build type (1 or 2) "
    echo "1. main [Production]"
    echo "2. dev"
    echo ""
    read  buildType
    if [[  $buildType =~ ^[1-2]+$ ]] ; then

        if [[  $buildType == 1 ]] ; then
            cleanAndBuildMain
        fi

        if [[  $buildType == 2 ]] ; then
            cleanAndBuildDev
        fi

    else
      invalidInput
    exit
    fi
}


chooseBuildType





