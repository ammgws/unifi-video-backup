# unifi-video-backup

Simple (fish) shell script to download complete motion clips from Unifi Video server as they occur.

### Installation & Usage
```sh
cp backup-recording.fish /usr/bin/local
cp watch-recordings-dir.fish /usr/bin/local
chmod +x /usr/bin/local/*recording*.fish
cp backup-recordings.service /etc/systemd/system/
systemctl enable backup-recordings.service
systemctl start backup-recordings.service
```

### Dependencies
 - `fswatch` (tested with 1.11.2)
 - `jq` (tested with 1.5-1-a5b5cbe)
 - Unifi Video (tested with 3.9.0)
