# BOUNRITH LY
# 1/12/2023
# Set Computer AD Description Field
 
# Set-ExecutionPolicy Unrestricted
# Import-Module ActiveDirectory
# Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Online

# $PO = Read-Host -Prompt 'Enter this computer PO or Press ENTER to skip'
$PO = ""

# GET LOCAL COMPUTER DETAILS
# TO DO: Use modern method instead of WmiObject
$ComputerName = (Get-WmiObject -Class Win32_ComputerSystem -Property Name).Name
$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber
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
If($TF) {Set-ADComputer $env:COMPUTERNAME -Description "$Description"} else {}
