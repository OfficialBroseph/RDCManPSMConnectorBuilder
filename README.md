# RDG File Connector Builder for PSM Connections
Will create server entries/connections that route through the CyberArk PSM for any app that can import a .RDG file! Including:
 - RD Connection Manager 
 - RD Manager Free
 - Devolutions (see screenshot for how to import into Devolutions)


## Using the script:

Fill out the .csv import spreadsheet with the servers you want to connect to.
Define the variables at the top of the script: 
 - the CSV import path
 - where you want the .rdg file written to (or the path of the current file you want to APPEND with new connections)
 - specify the name of the tree root in RDP Connection Manager 
 - specify the name of the main group in RDP Connection Manager

Note regarding the name of the root/group: currently all entries will be added to the first group in the file, you can manually organize servers afterwards with drag and drop

## Headers:
 - rdcDisplayName:      what the server will show up as in RDCMan when you open it.
 - psmServer:           the hostname of the PSM server you are connecting through
 - cyberarkUsername:    your username that you use to connect to CyberArk
 - targetAccount:       the username of the account in the Vault you are connecting to the target device with
 - targetAddress:       the hostname or IP address of the device you are connecting to with the target account
 - connectionComponent: the name of the connection component in you are using in CyberArk. This can be found in 
                          the account details next to the Connect button in the PVWA. E.g., PSM-RDP, PSM-SSH. 
                          DEFAULTS TO PSM-RDP IF LEFT BLANK

TO DO:
 - make script flexible to be able to append to a specific group defined by the user. Currently just appends to the first group node in the list
