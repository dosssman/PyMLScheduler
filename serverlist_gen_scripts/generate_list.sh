#!/bin/bash
## TODO: Add support for first argument as the name of the raw server list file.
## This will help mamange anonymity with github.
if [ -z $1 ]; then
	echo "Expected raw server filename as first argument. Exiting ..."
	exit
fi

if [ ! -f $1 ]; then
	echo "The filename passed does not seems to exist";
fi

PRIVATE_SEGMENT="10.34.22."
SERVER_LIST=$1

# Holders for server names and last array byte respectively
declare -a NAME_LIST
declare -a LAST_BYTE_LIST
declare -a HAS_GPU_LIST

# Read all server names into and array
for NAME in $(cat $SERVER_LIST | awk '{print $1}'); do
	NAME_LIST+=("${NAME}")
done

# Read all the corresponding last byte of tbe ip addresses
for LAST_BYTE in $(cat $SERVER_LIST | awk '{print $2}'); do
	LAST_BYTE_LIST+=("${LAST_BYTE}")
done

for HAS_GPU in $(cat $SERVER_LIST | awk '{print $3}'); do
	HAS_GPU_LIST+=("${HAS_GPU}")
done
SERVER_COUNT=$(wc -l "${SERVER_LIST}" | awk '{print $1}')
#echo $SERVER_COUNT

CONFIG_FILENAME="serverlist.yml"

# Remove global user as we need more flexibility when working with CS24 unrelated servers

for ((i=0; i < $SERVER_COUNT ; i++)) ; do
	printf "${NAME_LIST[$i]}:\n" >> $CONFIG_FILENAME
	printf "  hostname: ${NAME_LIST[$i]}\n" >> $CONFIG_FILENAME
  printf "  ipAddress: ${PRIVATE_SEGMENT}${LAST_BYTE_LIST[$i]}\n" >> $CONFIG_FILENAME
  printf "  hasGPU: ${HAS_GPU_LIST[$i]}\n" >> $CONFIG_FILENAME
  printf "\n" >> $CONFIG_FILENAME
done
