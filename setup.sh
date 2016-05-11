#!/bin/bash
# ---------------------------------------------------------------------------
# Setup processing for
#
# Environment Variable Prequisites
#
#   JAVA_HOME       Directory of Java Version
#
#
# $Id: setup.sh,v 1.1 2008/11/13 16:23:07 mohanar Exp $
# ---------------------------------------------------------------------------

echo

if [ "$#" -lt "3" ]; then
    echo "Missing required command line arguments"
    echo "USAGE: $0 <admin email> <SMTP server> <XNAT url> [XNAT site name] [destination] [modulePath1 modulePath2 modulePath3... modulePathn]"
    exit 1
fi


echo " "
echo "Using JAVA_HOME:         $JAVA_HOME"
echo " "
echo "Verify Java Version (with java -version)"
java -version

#======================================================================================================
# WORK_DIR gotten from http://software-lgl.blogspot.com/2009/03/find-full-path-of-your-bash-script.html
#======================================================================================================
WORK_DIR=`dirname "$(cd ${0%/*} && echo $PWD/${0##*/})"`

if [ -z $WORK_DIR ]; then
    WORK_DIR=`pwd`
fi

ADMIN_EMAIL=$1; shift;
SMTP_SERVER=$1; shift;
XNAT_URL=$1; shift;

# Set default values for these variables.
XNAT_SITE_NAME=XNAT
DESTINATION=""
MODULE_PATHS=""

if [ ! -z $1 ]; then
    XNAT_SITE_NAME=$1; shift
    if [ ! -z $1 ]; then
        DESTINATION=-Pdestination="$1"; shift;
        if [ ! -z $1 ]; then
            MODULE_PATHS=-PmodulePaths="$(echo $@ | sed 's/[ ,]\{1,\}/,/g')"
        fi
    fi
fi

cd $WORK_DIR
chmod +x $WORK_DIR/gradlew
echo Executing $WORK_DIR/gradlew -PadminEmail="$ADMIN_EMAIL" -PsmtpServer="$SMTP_SERVER" -PxnatUrl="$XNAT_URL" -PsiteName="$XNAT_SITE_NAME" $DESTINATION $MODULE_PATHS
./gradlew -PadminEmail="$ADMIN_EMAIL" -PsmtpServer="$SMTP_SERVER" -PxnatUrl="$XNAT_URL" -PsiteName="$XNAT_SITE_NAME" $DESTINATION $MODULE_PATHS

exit $?
