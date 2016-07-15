#!/bin/bash
#
BW_HOME_BIN=/Users/AUwanogho/Desktop/tibco/home/bw/6.3/bin
BW_ADMIN=${BW_HOME_BIN}/bwadmin
WORKSPACE=/Users/Shared/Jenkins/Home/workspace/Tibco_FilePoller

HTTP_PORT=2225

# Run bwadmin from CWD
cd ${BW_HOME_BIN}

# Create the .EAR archive file from application
EAR_FILE=FilePoller.application_1.0.0.ear

# Create automic domain
${BW_ADMIN} create domain automic
if [ $? -eq 0 ]; then
	Echo 'automic domain created'
fi

# Create automicSpace AppSpace
${BW_ADMIN}  create -d automic -minNodes 3 appspace automicSpace
if [ $? -eq 0 ]; then
        Echo 'automic appSpace created'
fi

# Create macAppNode 
${BW_ADMIN} create -d automic -a automicSpace -httpPort ${HTTP_PORT} appnode macAppNode
if [ $? -eq 0 ]; then
        Echo 'macAppNode created'
fi

# Upload application archive (.ear)
#${BW_ADMIN} upload -d automic /Users/AUwanogho/filepoller/FilePoller.application_1.0.0.ear
${BW_ADMIN} upload -d automic ${WORKSPACE}/${EAR_FILE}
if [ $? -eq 0 ]; then
      Echo 'Successfully uploaded .ear archive'
fi

# Start Node
${BW_ADMIN} start -d automic -a automicSpace -appnode macAppNode
if [ $? -eq 0 ]; then
        Echo 'macAppNode Started'
	sleep 5
fi

# Deploy Application
${BW_ADMIN} deploy -d automic -a automicSpace FilePoller.application_1.0.0.ear
if [ $? -eq 0 ]; then
        Echo 'Successfully deployed FilePoller Application'
fi


# Start Application
${BW_ADMIN} start -d automic -a automicSpace -n macAppNode application FilePoller.application 1.0
if [ $? -eq 0 ]; then
        Echo 'File Poller Application Started'
fi

# CLEAN UP
# Stop Application
#./bwadmin stop -d automic -a automicSpace application FilePoller.application 1.0

# Stop Node
#./bwadmin stop -d automic -a automicSpace -appnode macAppNode

# Undeploy Application
# ./bwadmin undeploy -d automic -a automicSpace application FilePoller.application 1.0

# Remove automic domain
