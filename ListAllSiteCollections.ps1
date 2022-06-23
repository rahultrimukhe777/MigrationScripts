#-------------- List all Site collections
 
# connect to the service
Connect-SPOService -Url $AdminUrl
 
# Export path
$path = "D:\Migration SPO Script\SitesInventory.csv"

# sharepoint online list all site collections powershell
Get-SPOSite -Detailed | Export-CSV -LiteralPath $path -NoTypeInformation

