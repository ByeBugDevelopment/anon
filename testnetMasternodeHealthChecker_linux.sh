#!/bin/bash

while [ 1 ]; do
	git fetch origin
	sleep 5
	status=$(git status)
	if [[ $status == *"up to date"* ]]; then
		echo Anon up-to-date
	else
		echo Stopping ANON Node
		./src/anon-cli -testnet stop
		sleep 5
		echo Anon repo is not up to date. Updating anon repo...
		git pull origin master
		sleep 5
		echo Rebuilding anon node
		./anonutil/build.sh -j$(nproc)
		echo Fetching Params
		sleep 5
		./anonutil/fetch-params.sh
		echo Running ANON daemon
		./src/anond -testnet -reindex -daemon
		sleep 10
		echo Resetting mnsync   
        ./src/anon-cli -testnet mnsync reset
        assetid=$(./src/anon-cli -testnet mnsync status | grep "AssetID" | cut -c 14-16) 
        

        while [ $assetid != "999" ]; do
            assetid=$(./src/anon-cli -testnet mnsync status | grep "AssetID" | cut -c 14-16)
            echo -n MNSYNC in progress
            echo -n . 
            sleep 1
            echo -n .
            sleep 1
            echo -n .
            sleep 1
            echo -n .
            sleep 1
            echo -n .
            sleep 1
            echo -n .
            sleep 1
            echo -n .
            sleep 1
            echo -n .
            sleep 1
            echo -n .
            sleep 1
            echo .
            sleep 1
            assetname=$(./src/anon-cli -testnet mnsync status | grep "AssetName")
            echo $assetname 
            sleep 5	
        done

        echo Masternode has successfully started with asset id: $assetid.

        echo Starting masternodes:
        sleep 2

        ./src/anon-cli -testnet masternode start-all
	fi
	sleep 10
done