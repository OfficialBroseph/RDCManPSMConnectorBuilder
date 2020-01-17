#############################################################################
#
# RDP Connection Manager - PSM Connector Builder
#
# Description:   Creates server entries within RDP Connection Manager that 
#                go through the CyberArk PSM from an import spreadsheet
#
# Created by:    Joe Arida
#
# GitHub Repo:   
#
##############################################################################

## Variables First!
$CSVImportPath = "C:\Users\john\Desktop\rdcman.csv"
$RDGFilePath = "C:\Users\john\Desktop\CM.rdg"
$RootName = "CyberArk PSM Connections"
$RDGGroupName = "Windows Servers"
$global:NewServerNode

## The Functions!

#Only needed if creating a new document
Function CreateXML {
  #creates the XML Document Object
  #[xml]$RDCEntry = New-Object System.Xml.XmlDocument

  $RDGBasicXML = @"
<?xml version="1.0" encoding="utf-8"?>
<RDCMan programVersion="2.7" schemaVersion="3">
  <file>
    <credentialsProfiles />
    <properties>
      <expanded>True</expanded>
      <name>$RootName</name>
    </properties>
    <group>
      <properties>
        <expanded>True</expanded>
        <name>$RDGGroupName</name>
      </properties>
    </group>
  </file>
  <connected />
  <favorites />
  <recentlyUsed />
</RDCMan>
"@

#write the XML skeleton file to the path specified by the user
$RDGBasicXML | Out-File -FilePath $RDGFilePath -Encoding utf8 -Force
}

#sets the variables then sets the entire server node to a variable and writes it to the file for each row in the csv
Function SetXMLNewServerNode {
  ForEach ($Server in $Servers) {
    #set the variables from the CSV Import
  $rdcDisplayName = $Server.rdcDisplayName
  $psmServer = $Server.psmServer
  $cyberarkUsername = $Server.cyberarkUsername
  $targetAccount = $Server.targetAccount
  $targetAddress = $Server.targetAddress
  $connectionComponent = $Server.connectionComponent
    if (!$connectionComponent) {$connectionComponent = "PSM-RDP"} #default connection component to PSM-RDP if left blank
    
  #set the data for the new server node
  [xml]$NewServerNode = @"
    <server>
      <properties>
        <displayName>$rdcDisplayName</displayName>
        <name>$psmServer</name>
      </properties>
      <logonCredentials inherit="None">
        <profileName scope="Local">Custom</profileName>
        <userName>$cyberarkUsername</userName>
        <password />
      </logonCredentials>
      <connectionSettings inherit="None">
        <connectToConsole>False</connectToConsole>
        <startProgram>psm /u $targetAccount /a $targetAddress /c $connectionComponent</startProgram>
        <workingDir />
        <loadBalanceInfo />
      </connectionSettings>
    </server>
"@;
  
  ## append the new nodes and save the file
  AppendXMLDoc $NewServerNode
}

}

#function appends additional server entries to the existing XML
Function AppendXMLDoc ($NewServerNode) {
  #get the content from the .rdg file
  $xDoc = [xml](Get-Content -Path $RDGFilePath)

  #create document fragment to prevent error regarding no root node
  $xmlFrag = $xDoc.CreateDocumentFragment()

  #grab the xmlFragment from the inner XML of the NewServerNode variable that was set above
  $xmlFrag.InnerXml = $NewServerNode.innerXml

  #select the group node to insert the server node into
  $node = $xDoc.SelectSingleNode("//group")

  #append the server node to the group node
  $node.AppendChild($xmlFrag)

  #save the changes to the document
  $xDoc.save($RDGFilePath)
}


## The Script!
# Check if the RDG file already exists. Creates a new file with XML skeleton if needed.
If (!(Test-Path $RDGFilePath)) {
  New-Item $RDGFilePath
  }

# check if the file exists but is empty
If ($null -eq (Get-Content $RDGFilePath)) {
  #if the file is present but empty, createXML
  CreateXML; 
  Write-Host "New rdg file written at $RDGFilePath!";
} Else {
  Write-Host "Skipping file creation, appending existing .RDG file" -ForegroundColor Yellow
}

# import csv
$Servers = Import-Csv $CSVImportPath

# loop through the lines in the CSV and update the XML body variable accordingly
Write-Host "Onboarding file $CSVImportPath. Please Wait" -ForegroundColor Yellow

#call the function to add the new node(s) to the rdg file
SetXMLNewServerNode

