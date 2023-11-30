if (Get-InstalledModule -Name Az) {
    Write-Host "Connecting to Azure..."
    Connect-AzAccount > $null
    Write-Host "Getting Azure Subscriptions..."
    $(foreach ($subscription in (Get-AzSubscription)) {
        Set-AzContext -SubscriptionId $subscription.Id > $null
        Get-AzResource | ForEach-Object{
            [PsCustomObject]@{
                SubscriptionName = $subscription.Name
                ResourceType = $_.ResourceType
                Name = $_.Name
                Location = $_.Location
                Tenant = $subscription.TenantId
                Subscription = $subscription.Id
            }
        }
    }) | Export-Csv "azure-inventory.csv" -NoTypeInformation -Force
    Write-Host "Inventory saved to azure-inventory.csv"
} else {
    Write-Host "Az module not found. Install Az module by running Install-Module -Name Az -Repository PSGallery -Force"
}