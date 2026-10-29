param virtualMachines_vm1_name string = 'vm1'
param virtualNetworks_vnet1_name string = 'vnet1'
param networkInterfaces_vm1981_name string = 'vm1981'
param bastionHosts_vnet1_bastion_name string = 'vnet1-bastion'
param publicIPAddresses_vnet1ip941_name string = 'vnet1ip941'
param storageAccounts_storageacc14321_name string = 'storageacc14321'
param networkSecurityGroups_nsg_subnet2_pe_name string = 'nsg-subnet2-pe'
param networkSecurityGroups_nsg_subnet1_vm1_name string = 'nsg-subnet1-vm1'
param privateDnsZones_privatelink_blob_core_windows_net_name string = 'privatelink.blob.core.windows.net'
param privateEndpoints_pe_storageacc14321_to_subnet2_pe_name string = 'pe-storageacc14321-to-subnet2-pe'

resource networkSecurityGroups_nsg_subnet1_vm1_name_resource 'Microsoft.Network/networkSecurityGroups@2025-09-01' = {
  name: networkSecurityGroups_nsg_subnet1_vm1_name
  location: 'westus3'
  properties: {
    securityRules: [
      {
        name: 'BastionToVm1'
        id: networkSecurityGroups_nsg_subnet1_vm1_name_BastionToVm1.id
        properties: {
          sourcePortRange: '*'
          sourceAddressPrefix: '20.171.96.133'
          destinationAddressPrefix: '10.0.0.4'
          priority: 100
          protocol: '*'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '3389'
            '22'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_nsg_subnet2_pe_name_resource 'Microsoft.Network/networkSecurityGroups@2025-09-01' = {
  name: networkSecurityGroups_nsg_subnet2_pe_name
  location: 'westus3'
  properties: {
    securityRules: [
      {
        name: 'AllowVM1ToSAPrivateEndpoint'
        id: networkSecurityGroups_nsg_subnet2_pe_name_AllowVM1ToSAPrivateEndpoint.id
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '10.0.0.0/24'
          destinationAddressPrefix: '10.0.1.4'
          priority: 100
          description: 'Allows a connection between vm1 in subnet1-vm1 (10.0.0.4) to the storageacc1 private endpoint NIC (10.0.1.4) in subnet2-pe (10.0.1.0).'
          protocol: '*'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'DenySsh'
        id: networkSecurityGroups_nsg_subnet2_pe_name_DenySsh.id
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '10.0.0.0/24'
          destinationAddressPrefix: '10.0.1.4'
          priority: 110
          protocol: '*'
          access: 'Deny'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_blob_core_windows_net_name
  location: 'global'
  properties: {}
}

resource publicIPAddresses_vnet1ip941_name_resource 'Microsoft.Network/publicIPAddresses@2025-09-01' = {
  name: publicIPAddresses_vnet1ip941_name
  location: 'westus3'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.171.96.133'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource storageAccounts_storageacc14321_name_resource 'Microsoft.Storage/storageAccounts@2026-06-01' = {
  name: storageAccounts_storageacc14321_name
  location: 'westus3'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    allowCrossTenantDelegationSas: false
    dualStackEndpointPreference: {
      publishIpv6Endpoint: false
    }
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Disabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    networkAcls: {
      ipv6Rules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Cold'
  }
}

resource virtualMachines_vm1_name_resource 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: virtualMachines_vm1_name
  location: 'westus3'
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'microsoftwindowsdesktop'
        offer: 'windows-11'
        sku: 'win11-25h2-pro'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_vm1_name}_OsDisk_1_634d90248b844744bfd03212aca1b7bd'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm1_name}_OsDisk_1_634d90248b844744bfd03212aca1b7bd'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_vm1_name
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm1981_name_resource.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    licenseType: 'Windows_Client'
  }
}

resource networkInterfaces_vm1981_name_resource 'Microsoft.Network/networkInterfaces@2025-09-01' = {
  name: networkInterfaces_vm1981_name
  location: 'westus3'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm1981_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.0.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnet1_name_subnet_vm1.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkSecurityGroups_nsg_subnet2_pe_name_AllowVM1ToSAPrivateEndpoint 'Microsoft.Network/networkSecurityGroups/securityRules@2025-09-01' = {
  name: '${networkSecurityGroups_nsg_subnet2_pe_name}/AllowVM1ToSAPrivateEndpoint'
  properties: {
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: '10.0.0.0/24'
    destinationAddressPrefix: '10.0.1.4'
    priority: 100
    description: 'Allows a connection between vm1 in subnet1-vm1 (10.0.0.4) to the storageacc1 private endpoint NIC (10.0.1.4) in subnet2-pe (10.0.1.0).'
    protocol: '*'
    access: 'Allow'
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_nsg_subnet2_pe_name_resource
  ]
}

resource networkSecurityGroups_nsg_subnet1_vm1_name_BastionToVm1 'Microsoft.Network/networkSecurityGroups/securityRules@2025-09-01' = {
  name: '${networkSecurityGroups_nsg_subnet1_vm1_name}/BastionToVm1'
  properties: {
    sourcePortRange: '*'
    sourceAddressPrefix: '20.171.96.133'
    destinationAddressPrefix: '10.0.0.4'
    priority: 100
    protocol: '*'
    access: 'Allow'
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '3389'
      '22'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_nsg_subnet1_vm1_name_resource
  ]
}

resource networkSecurityGroups_nsg_subnet2_pe_name_DenySsh 'Microsoft.Network/networkSecurityGroups/securityRules@2025-09-01' = {
  name: '${networkSecurityGroups_nsg_subnet2_pe_name}/DenySsh'
  properties: {
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '10.0.0.0/24'
    destinationAddressPrefix: '10.0.1.4'
    priority: 110
    protocol: '*'
    access: 'Deny'
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_nsg_subnet2_pe_name_resource
  ]
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_storageacc14321 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'storageacc14321'
  properties: {
    metadata: {
      creator: 'created by private endpoint pe-storageacc14321-to-subnet2-pe with resource guid ccd9882b-d740-4e80-a5f5-aad069e668b1'
    }
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.1.4'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_blob_core_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource virtualNetworks_vnet1_name_resource 'Microsoft.Network/virtualNetworks@2025-09-01' = {
  name: virtualNetworks_vnet1_name
  location: 'westus3'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'subnet-vm1'
        id: virtualNetworks_vnet1_name_subnet_vm1.id
        properties: {
          addressPrefixes: [
            '10.0.0.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'NetworkSecurityGroupEnabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'subnet2-pe'
        id: virtualNetworks_vnet1_name_subnet2_pe.id
        properties: {
          addressPrefixes: [
            '10.0.1.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_nsg_subnet2_pe_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'NetworkSecurityGroupEnabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'AzureBastionSubnet'
        id: virtualNetworks_vnet1_name_AzureBastionSubnet.id
        properties: {
          addressPrefix: '10.0.2.0/26'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'subnet3-nva'
        id: virtualNetworks_vnet1_name_subnet3_nva.id
        properties: {
          addressPrefixes: [
            '10.0.3.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet1_name_AzureBastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_vnet1_name}/AzureBastionSubnet'
  properties: {
    addressPrefix: '10.0.2.0/26'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet1_name_resource
  ]
}

resource virtualNetworks_vnet1_name_subnet3_nva 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_vnet1_name}/subnet3-nva'
  properties: {
    addressPrefixes: [
      '10.0.3.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet1_name_resource
  ]
}

resource virtualNetworks_vnet1_name_subnet_vm1 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_vnet1_name}/subnet-vm1'
  properties: {
    addressPrefixes: [
      '10.0.0.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'NetworkSecurityGroupEnabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet1_name_resource
  ]
}

resource storageAccounts_storageacc14321_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-06-01' = {
  parent: storageAccounts_storageacc14321_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    staticWebsite: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_storageacc14321_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-06-01' = {
  parent: storageAccounts_storageacc14321_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {
        encryptionInTransit: {
          required: true
        }
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource storageAccounts_storageacc14321_name_storageAccounts_storageacc14321_name_7a908d84_57a8_40d3_92e0_0d6c602838c0 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2026-06-01' = {
  parent: storageAccounts_storageacc14321_name_resource
  name: '${storageAccounts_storageacc14321_name}.7a908d84-57a8-40d3-92e0-0d6c602838c0'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-Approved'
      actionRequired: 'None'
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_storageacc14321_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-06-01' = {
  parent: storageAccounts_storageacc14321_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_storageacc14321_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-06-01' = {
  parent: storageAccounts_storageacc14321_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource bastionHosts_vnet1_bastion_name_resource 'Microsoft.Network/bastionHosts@2025-09-01' = {
  name: bastionHosts_vnet1_bastion_name
  location: 'westus3'
  sku: {
    name: 'Premium'
  }
  properties: {
    dnsName: 'bst-dfbaea64-e0db-4765-9b51-e664785fa76d.bastion.azure.com'
    scaleUnits: 2
    ipConfigurations: [
      {
        name: 'IpConf'
        id: '${bastionHosts_vnet1_bastion_name_resource.id}/bastionHostIpConfigurations/IpConf'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_vnet1ip941_name_resource.id
          }
          subnet: {
            id: virtualNetworks_vnet1_name_AzureBastionSubnet.id
          }
        }
      }
    ]
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_qo7sstpbo7nts 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'qo7sstpbo7nts'
  location: 'global'
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_vnet1_name_resource.id
    }
  }
}

resource privateEndpoints_pe_storageacc14321_to_subnet2_pe_name_resource 'Microsoft.Network/privateEndpoints@2025-09-01' = {
  name: privateEndpoints_pe_storageacc14321_to_subnet2_pe_name
  location: 'westus3'
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_pe_storageacc14321_to_subnet2_pe_name
        id: '${privateEndpoints_pe_storageacc14321_to_subnet2_pe_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_pe_storageacc14321_to_subnet2_pe_name}'
        properties: {
          privateLinkServiceId: storageAccounts_storageacc14321_name_resource.id
          groupIds: [
            'blob'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    customNetworkInterfaceName: '${privateEndpoints_pe_storageacc14321_to_subnet2_pe_name}-nic'
    subnet: {
      id: virtualNetworks_vnet1_name_subnet2_pe.id
    }
    ipConfigurations: []
    customDnsConfigs: []
    ipVersionType: 'IPv4'
  }
}

resource privateEndpoints_pe_storageacc14321_to_subnet2_pe_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2025-09-01' = {
  name: '${privateEndpoints_pe_storageacc14321_to_subnet2_pe_name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-blob-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZones_privatelink_blob_core_windows_net_name_resource.id
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoints_pe_storageacc14321_to_subnet2_pe_name_resource
  ]
}

resource virtualNetworks_vnet1_name_subnet2_pe 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_vnet1_name}/subnet2-pe'
  properties: {
    addressPrefixes: [
      '10.0.1.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_nsg_subnet2_pe_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'NetworkSecurityGroupEnabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet1_name_resource
  ]
}