#!/usr/bin/fish

set UNIFI_API_KEY from-unifi-video-web-interface
set UNIFI_SERVER_ADDR https://server:7443
set BACKUP_DIR /path/to/backup
set TEMP_DIR /tmp

# path to JSON file should be passed in as first arg
set json_file $argv

# example of JSON file contents
#cat /path/to/recordings/<camera-folder-name>/2018/01/31/meta/5b570d885e0798b13760c9ef1.json
#{
#  "eventType": "motionRecording",
#  "startTime": 1517358451223,
#  "endTime": 1517358495236,
#  "cameras": [
#    "7a7a23715e0edf8883e926ff"
#  ],
#  "locked": false,
#  "inProgress": false,
#  "markedForDeletion": false,
#  "meta": {
#    "cameraName": "UVC-G3-AF",
#    "key": "OzryxpPU",
#    "recordingPathId": "8a65a2ec5d3773577ef2807"
#  },
#  "_id": "5b570d885e0798b13760c9ef1"
#}

# grab info to use in filename
# TODO: cat once, use many
set camera_name (cat $json_file | jq --raw-output .'meta | .cameraName')
set start_time (date --date=@(math (cat $json_file | jq '.startTime'/1000))+%Y%m%d_%Hh%Mm%Ss)
set end_time (date --date=@(math (cat $json_file | jq '.endTime'/1000))+%Y%m%d_%Hh%Mm%Ss)
set filename (string join "_" $start_time "to" $end_time $camera_name ".mp4")
set output_path (string join "" $TEMP_DIR "/" $filename)

# the recording to download
set record_id (string match --regex '.*/(.*).json' $json_file)[2]

# TODO: error handling / retries?
curl --output $output_path --insecure (string join "" $UNIFI_SERVER_ADDR "/api/2.0/recording/" $record_id "/download?apiKey=" $UNIFI_API_KEY)
mv $output_path $BACKUP_DIR/
