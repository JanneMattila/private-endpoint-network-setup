# Private Endpoint network setup

## Architecture

Here is example private endpoint network setup in [hub-spoke](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
network topology:

![private endpoint network setup architecture](https://user-images.githubusercontent.com/2357647/97886561-69c42f80-1d31-11eb-8fe3-47748c32f33a.png)

This architecture deploys `Private DNS Zone` to the hub network.
Spoke deployments then update the private IP addresses of the services deployed to the
spoke networks.

## Step-by-step walkthrough

*TBA*

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
