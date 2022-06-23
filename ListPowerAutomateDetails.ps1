<#  
    Outputs a .csv file of records that represent list of PowerAutomates from the tenant it is run in. Result feature records will include:
        - PowerAutomate display name
        - Environment Name
        - User display name who created the Power Automate
#>

if (Get-Module -ListAvailable -Name Microsoft.PowerApps.Administration.PowerShell) {
    Write-Host "Module Microsoft.PowerApps.Administration.PowerShell exists"
} 
else {
    Write-Host "Installing Module Microsoft.PowerApps.Administration.PowerShell..."
	Install-Module -Name Microsoft.PowerApps.Administration.PowerShell
	Write-Host "Installed Module Microsoft.PowerApps.Administration.PowerShell..."
}

if (Get-Module -ListAvailable -Name Microsoft.PowerApps.PowerShell) {
    Write-Host "Microsoft.PowerApps.PowerShell exists"
} 
else {
    Write-Host "Installing Module Microsoft.PowerApps.PowerShell -AllowClobber..."
	Install-Module -Name Microsoft.PowerApps.PowerShell -AllowClobber
	Write-Host "Installed Module Microsoft.PowerApps.PowerShell -AllowClobber..."
}

[string]$Path = 'D:\Migration SPO Script\List_PowerAutomate_Details.csv'

# This call opens prompt to collect credentials (AAD account & password) used by the commands
Add-PowerAppsAccount

# Get all PowerAutomates the Tenant - with proper respective permissions
# Global Administrator
# Environment Administrator
# Power Platform Administrator

$powerAutomates = Get-AdminFlow 

$powerAutomateListings = @()

# loop through each power automate
foreach ($powerAutomate in $powerAutomates)
{
	#Get the user from Created By field of Power Automate
	$user = Get-UsersOrGroupsFromGraph -ObjectId $powerAutomate.CreatedBy.userId
	#prepare the row to write the details in CSV file
	$row = @{
		ResourceType = 'PowerAutomate'
		DisplayName = $powerAutomate.displayName
		EnvironmentName = $powerAutomate.environmentName
		CreatedByEmail = $user.DisplayName
	}
	$powerAutomateListings+= $(new-object psobject -Property $row)
}

# output to file on given Path
$powerAutomateListings | Export-Csv -Path $Path
Write-Host "Report has been exported at " $Path