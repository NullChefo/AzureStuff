
<#
.SYNOPSIS
    Deletes a specified Azure Resource Group using a system‐assigned managed identity.

.DESCRIPTION
    This runbook script authenticates to Azure using the Automation account’s system‐assigned managed identity.
    It then optionally sets the subscription context (if a SubscriptionId is provided) and attempts to delete the resource group
    whose name is passed as a parameter.

.PARAMETER ResourceGroupName
    The name of the resource group to delete.

.PARAMETER SubscriptionId
    (Optional) The subscription ID where the resource group exists. If not provided, the default context is used.

.EXAMPLE
    .\DeleteResourceGroupRunbook.ps1 -ResourceGroupName "myResourceGroup"
    Deletes the resource group named "myResourceGroup" in the current subscription context.

.EXAMPLE
    .\DeleteResourceGroupRunbook.ps1 -ResourceGroupName "myResourceGroup" -SubscriptionId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    Deletes the resource group in the specified subscription.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $false)]
    [string]$SubscriptionId
)

try {
    Write-Output "Starting deletion runbook for resource group '$ResourceGroupName'."

    # Authenticate using the system-assigned managed identity.
    Write-Output "Authenticating with Azure using Managed Identity..."
    $azContext = Connect-AzAccount -Identity -ErrorAction Stop

    # If a SubscriptionId is provided, set the context.
    if ($SubscriptionId) {
        Write-Output "Setting Azure context to subscription ID: $SubscriptionId"
        Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop
    }

    # Verify that the resource group exists.
    Write-Output "Verifying existence of resource group '$ResourceGroupName'..."
    $rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
    if ($null -eq $rg) {
        Write-Output "Resource group '$ResourceGroupName' does not exist. Exiting runbook."
        return
    }

    # Delete the resource group.
    Write-Output "Initiating deletion of resource group '$ResourceGroupName'..."
    Remove-AzResourceGroup -Name $ResourceGroupName -Force -ErrorAction Stop

    Write-Output "Deletion of resource group '$ResourceGroupName' has been initiated successfully."
}
catch {
    Write-Error "An error occurred during deletion: $_"
}
