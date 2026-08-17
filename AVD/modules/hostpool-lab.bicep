//Parameters 

param location string = resourceGroup().location

param hostPoolName string = 'avdhostpool2'

@description ('host pool friendly name')
param friendlyName string = 'hostpool2test'


@description('maximum session limit')
@minValue(1)
@maxValue(50)
param maxSessionLimit int = 10

param hostPoolType string = 'Pooled'

param loadBalancerType string = 'BreadthFirst'




resource hostPool 'Microsoft.DesktopVirtualization/hostpools@2026-03-01-preview' = {
  name: hostPoolName
  location: location
  identity: {
    type: 'None'
  }
  properties: {
    friendlyName: friendlyName
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    preferredAppGroupType: 'Desktop'
    allowRDPShortPathWithPrivateLink: 'Disabled'
    deploymentScope: 'Geographical'
    directUDP: 'Default'
    publicUDP: 'Default'
    relayUDP: 'Default'
    managementType: 'Standard'
    publicNetworkAccess: 'Enabled'
    customRdpProperty: 'drivestoredirect:s:;usbdevicestoredirect:s:;redirectclipboard:i:1;redirectprinters:i:0;audiomode:i:1;videoplaybackmode:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1;targetisaadjoined:i:1;redirectmicrophones:i:1;audiooutputmode:i:1;enablerdsaadauth:i:1;audiocapturemode:i:1;dynamic resolution:i:1;'
    maxSessionLimit: maxSessionLimit
  }
}
