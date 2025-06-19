#!/bin/bash
DATE=$(date +%Y-%m-%d-%H%M%S)
BACKUP_DIR="/mnt/mother/backup/piguard/fhemconfig"
SOURCE="/opt/fhem"


cp /opt/fhem/fhem.cfg $BACKUP_DIR/fhem.cfg-$DATE
sleep 1
omxplayer --adev alsa /home/pi/audio/transfercomplete_clean.mp3

