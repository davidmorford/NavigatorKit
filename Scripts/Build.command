
# ================================================================================
# Build Kit 
#
# (c) 2008 - 2010, Semantap
# 
# iOS Application and Libraries Build Script
#
# Created: Aug. 12, 2009 - david [at] semantap
# Updated: Sep. 08, 2009 - david [at] semantap
# Updated: Mar. 17, 2010 - david [at] semantap
# Updated: Apr. 12, 2010 - david [at] semantap
# Updated: Jun. 20, 2010 - david [at] semantap
# Updated: Sept. 4, 2010 - david [at] semantap
# Updated: Sept. 15, 2010 - david [at] semantap
# Updated: Sept. 19, 2010 - david [at] semantap
# ================================================================================

Usage()
{
    builtin echo "iPhone Build Script, version 1.0\n"
    builtin echo "Usage: Build.command <SDKVersion> <BuildConfiguration>"
    builtin echo "\t<SDKVersion>         = A SDK Version"
    builtin echo "\t\tAvailable          = [3.2 | 4.1 | 4.2]"
    builtin echo "\t<BuildConfiguration> = A Build Configuration"
    builtin echo "\t\tAvailable          = [Debug | Profile | Release | Adhoc | Distribution]"
    builtin echo "\n"
}

set -e

# process arguments
if [ $# -eq 1 ]; then
    SELECTED_SDK_VERSION="$1"
    Usage
    exit 1
elif [ $# -eq 2 ]; then
    SELECTED_SDK_VERSION="$1"
    SELECTED_BUILD_CONFIGURATION="$2"
else
    Usage
    exit 1
fi

echo $TARGET_SDK_VERSION
echo $TARGET_SDK_TYPE

# ================================================================================
# Debug | Profile | Release | Adhoc | Distribution
# ================================================================================

export BUILD_CONFIGURATION=$SELECTED_BUILD_CONFIGURATION
export BUILD_SDK_VERSION=$SELECTED_SDK_VERSION


# ================================================================================
# iphoneos[*] | iphonesimulator[*]
# ================================================================================

export BUILD_DEVICE_SDK_NAME=iphoneos
export BUILD_SIMULATOR_SDK_NAME=iphonesimulator

export BUILD_DEVICE_SDK=$BUILD_DEVICE_SDK_NAME$BUILD_SDK_VERSION
export BUILD_SIMULATOR_SDK=$BUILD_SIMULATOR_SDK_NAME$BUILD_SDK_VERSION


# ================================================================================
# Current working directory.
# ================================================================================

export PROJECT_ROOT=$PWD/../Projects
export LIBRARIES_ROOT=$PROJECT_ROOT/Libraries
export VENDOR_ROOT=$PROJECT_ROOT/Vendors


# ================================================================================
# Location of Shared Build Directory
# ================================================================================

export BUILD_DIR=../Build

# ================================================================================
# Location of Shared Build Libraries
# ================================================================================

export BUILD_SDK_DIR=$BUILD_DIR/Libraries

echo "Xcode Version"
echo "________________________________________________________________________________\n"
xcodebuild -version
echo "\n"

echo "Available SDKs"
echo "________________________________________________________________________________\n"
xcodebuild -showsdks
echo "\n"

echo "SDK Versions"
echo "________________________________________________________________________________\n"
xcodebuild -version -sdk $BUILD_DEVICE_SDK
xcodebuild -version -sdk $BUILD_SIMULATOR_SDK
echo "\n"


echo "Build Configuration"
echo "________________________________________________________________________________\n"

echo "Build Configuration  =" $BUILD_CONFIGURATION
echo "Build SDK Version    =" $BUILD_SDK_VERSION
echo "Device SDK Name      =" $BUILD_DEVICE_SDK
echo "Simulator SDK Name   =" $BUILD_SIMULATOR_SDK
echo "Root Build Directory =" $PROJECT_ROOT
echo "Deployment Directory =" $BUILD_SDK_DIR
echo "\n"


# ================================================================================
# Libraries
# ================================================================================ 

CleanDeployedLibrary()
{
    echo "Cleaning " $1
    rm -dRfv $BUILD_SDK_DIR/$BUILD_CONFIGURATION/$BUILD_DEVICE_SDK_NAME$BUILD_SDK_VERSION/$1
    rm -dRfv $BUILD_SDK_DIR/$BUILD_CONFIGURATION/$BUILD_SIMULATOR_SDK_NAME$BUILD_SDK_VERSION/$1
}

CleanDeployedLibrary NavigatorKit

# Add libraries to clean

# ================================================================================
# Libraries
# ================================================================================ 

BuildLibrary()
{
    echo "Building " $2
    echo "________________________________________________________________________________\n"
    cd $1/$2

    xcodebuild -sdk $BUILD_DEVICE_SDK -target $3 -configuration $BUILD_CONFIGURATION -project $2.xcodeproj clean
    xcodebuild -sdk $BUILD_SIMULATOR_SDK -target $3 -configuration $BUILD_CONFIGURATION -project $2.xcodeproj clean

    xcodebuild -sdk $BUILD_DEVICE_SDK -target $3 -configuration $BUILD_CONFIGURATION -project $2.xcodeproj build
    xcodebuild -sdk $BUILD_SIMULATOR_SDK -target $3 -configuration $BUILD_CONFIGURATION -project $2.xcodeproj build
}

# ================================================================================
# arg1 = Project Directory Path
# arg2 = Xcode Project
# arg3 = Project Target
# ================================================================================

BuildLibrary $LIBRARIES_ROOT NavigatorKit NavigatorKit

# Add libraries
