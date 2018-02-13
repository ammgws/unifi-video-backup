# -*- coding: utf-8 -*-
import os
import pythoncom
import win32api
import win32con
from comtypes.hresult import S_OK
from pathlib import Path
from win32com.shell import shell

""" Finds all synced videos and delete the local copy.

    Running in Windows as there is no linux version
    for Google Backup and Sync, which is the onyl way
    at the moment to upload to Google Photos with
    unlimited storage.
"""

monitor_dir = r'path:/to/recordings'

# Get the Explorer overlay ID that's used to show synced status in Google Backup and Sync.
# TODO: Save to disk or set env var instead of running every time.
reg_key = win32api.RegOpenKeyEx(
    win32con.HKEY_LOCAL_MACHINE,
    r'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers',
)
i = 0
try:
    while True:
       overlay_name = win32api.RegEnumKey(reg_key, i)
       if overlay_name == 'GoogleDriveSynced':
           overlay_handler_ID = win32api.RegQueryValue(reg_key, overlay_name)
           break;
       i += 1
except win32api.error as e:
    if e.winerror == 259:
        # Couldn't find Google Backup and Drive handler, try hardcoded one anyway
        overlay_handler_ID = '{81539FE6-33C7-4CE7-90C7-1C7B8F2F2D40}'
finally:
    win32api.RegCloseKey(reg_key)

ovh = pythoncom.CoCreateInstance(overlay_handler_ID,
                                 None,
                                 pythoncom.CLSCTX_INPROC_SERVER,
                                 shell.IID_IShellIconOverlayIdentifier)

p = Path(monitor_dir)
for file in p.glob('*.mp4'):
    status = ovh.IsMemberOf(str(file), 0)
    if status == S_OK:
        os.remove(str(file))
