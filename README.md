# Private Endpoint network setup

## Architecture

Here is example private endpoint network setup in [hub-spoke](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
network topology:

![private endpoint network setup architecture](https://user-images.githubusercontent.com/2357647/97886561-69c42f80-1d31-11eb-8fe3-47748c32f33a.png)

This architecture deploys `Private DNS Zone` to the hub network.
Spoke deployments then update the private IP addresses of the services deployed to the
spoke networks.

## Step-by-step walkthrough

If you want to mimic typical Enterprise environment, then create 3 different
service principals to your environment (here using simplified naming conventions):

- `hub`: contributor in `rg-pedemo-hub` resource group
- `spoke1`: contributor in `rg-pedemo-spoke1` resource group
- `spoke2`: contributor in `rg-pedemo-spoke2` resource group

On top of the contributor role you need to have additional permissions for service principals for
[VNet peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering#permissions)
and 
[Private DNS Zone](https://docs.microsoft.com/en-us/azure/dns/dns-protect-private-zones-recordsets).
E.g. `spoke1` needs to update Private DNS Zone record set in `rg-pedemo-hub` and make VNet
peering between spoke1 and hub VNets (same permissions apply for `spoke2`).

You can use following code to login as service principal:

```powershell
$tenantId = "<your tenant id>"
$clientID = "<your service principal Application (client) ID>"
$clientSecret = "<your service principal secret>"
$clientPassword = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($clientID, $clientPassword)
Login-AzAccount -Credential $credentials -ServicePrincipal -TenantId $tenantId

# Verify correct context
Get-AzSubscription
```

Now you can use correct service principals for deploying
their individual templates.

## Deploy example

*Note:* Since `condition` is not yet implemented in
bicep you need to comment out the network peering in
`hub/main.bicep` before the initial deployment:

```powershell
bicep build .\hub\main.bicep && .\hub\deploy.ps1
```

```powershell
bicep build .\spoke1\main.bicep && .\spoke1\deploy.ps1
```

```powershell
bicep build .\spoke2\main.bicep && .\spoke2\deploy.ps1
```
