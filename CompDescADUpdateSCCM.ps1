# BOUNRITH LY
# 1/12/2023
# Set Computer AD Description Field
 
# Set-ExecutionPolicy Unrestricted
# Import-Module ActiveDirectory
# Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Online

# $PO = Read-Host -Prompt 'Enter this computer PO or Press ENTER to skip'
$PO = ""

# GET LOCAL COMPUTER DETAILS
# TO DO: Use CIMinstance instead of WmiObject
# VERSION 2: $ComputerName = Get-CIMinstance -Class Win32_ComputerSystem -Property Name


$ComputerName = (Get-WmiObject -Class Win32_ComputerSystem -Property Name).Name
$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber

# VERSION2: # $CurrDesc = Get-ADComputer -Identity $ComputerName.name -Property Description
$ADObject = Get-ADComputer -Identity $ComputerName -Property Description

$a = Get-Date
# $b = $a.ToShortDateString()
$b = "1/1/2020"
$c = $a.ToShortTimeString()
$d = Get-WmiObject -computername $ComputerName Win32_Computersystem | Select -Expand model
$e = $SerialNumber

# if ($d -eq $null) {$d = '0000'}
# $e = $d -replace '\D+(\d+)\D+','$1'

$Description = "MD: $d; SN: $e; PO: $PO; $b"

$TF = [string]::IsNullOrEmpty($ADObject.Description)

# IF FALSE OR EMPTY THEN ADD DESCRIPTION, ELSE DO NOTHING
# VERSION 2A: if ([string]::IsNullOrEmpty($ADObject.Description)){}
# VERSION 2A: if (-not [string]::IsNullOrEmpty($ADObject.Description)){}
# VERSION 2B: If ($TF -eq $True) {write-host "true AD desc is empty"} else {write-host "false AD desc exists"}
# VERSION 2B: If ([string]::IsNullOrEmpty ($CurrDesc) ){write-host "true AD desc is empty"} else {write-host "false AD desc exists"}

If($TF) {Set-ADComputer $env:COMPUTERNAME -Description "$Description"} else {}
