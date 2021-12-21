#!/usr/bin/env bash
DIR=$(pwd)
DATE=$(date "+%d/%m/%Y %H:%M:%S +%Z")

_echo () {
	echo $@
	echo $@ >> $DIR/check.log
	}
	

getsigver () {
	CURSIGVER=$(curl -s https://cdn.rfxn.com/downloads/maldet.sigs.ver)
}

processsigfile () {
	_echo " - Downloading archive from https://cdn.rfxn.com/downloads/maldet-sigpack.tgz"
	curl -O https://cdn.rfxn.com/downloads/maldet-sigpack.tgz
	_echo " - Extracting archive"
	tar -zxvf $DIR/maldet-sigpack.tgz
	_echo " - Committing to git."
	git commit -am "Update on $DATE"
	git push		
}

_echo "Starting script in $DIR on $DATE"

if [ ! -f .cursigver ]; then
        _echo "First run, no .cursigver present"
        _echo "Grabbing signature file"
        getsigver
        _echo $CURSIGVER > .cursigver
        LASTSIGVER=$(cat .cursigver)
else
	LASTSIGVER=$(cat .cursigver)
fi

getsigver
_echo "Current signature version $CURSIGVER"
_echo "Last signature version $LASTSIGVER"

if [ $CURSIGVER == $LASTSIGVER ]; then
	_echo "No signature update."
else
	_echo "Signatures updated."
	processsigfile
	
fi

_echo "Exiting" 

