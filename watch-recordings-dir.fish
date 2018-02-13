#!/usr/bin/fish

set UNIFI_RECORDINGS_DIR /path/to/recordings/

# Watches for new JSON files in the Unifi recordings (sub)directories,
# and passes the filenames to the backup script.

fswatch --print0 --directories --recursive --event Created \
        --exclude '.*' --include '\.json$' $UNIFI_RECORDINGS_DIR \
  | xargs --verbose --null --max-args=1  --replace='{}' '/usr/local/bin/backup-recording.fish' "{}"
