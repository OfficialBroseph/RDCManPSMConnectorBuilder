# RDCManPSMConnectorBuilder
PowerShell RDCMan connector builder for CyberArk PSM connections


Usage:

Fill out the .csv import spreadsheet with the servers you want to connect to.
Define the variables at the top of the script: 
 - the CSV import path
 - where you want the .rdg file written to (or the path of the current file you want to APPEND with new connections)
 - the name of the tree root in RDP Connection Manager
 - the name of the main group in RDP Connection Manager

Headers:
 - rdcDisplayName:      what the server will show up as in RDCMan when you open it.
 - psmServer:           the hostname of the PSM server you are connecting through
 - cyberarkUsername:    your username that you use to connect to CyberArk
 - targetAccount:       the username of the account in the Vault you are connecting to the target device with
 - targetAddress:       the hostname or IP address of the device you are connecting to with the target account
 - connectionComponent: the name of the connection component in you are using in CyberArk. This can be found in 
                          the account details next to the Connect button in the PVWA. E.g., PSM-RDP, PSM-SSH. 
                          DEFAULTS TO PSM-RDP IF LEFT BLANK

TO DO:
 - make script flexible to be able to append to a specific group defined by the user. Currently just appends 
     to the first group node in the list
