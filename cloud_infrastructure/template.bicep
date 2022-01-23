@allowed([
  'dev'
  'prod'
])
param environemnt string

param location string = resourceGroup().location

param bgc_func_name string = 'bgc-func-${environemnt}'
param bgc_st_name string = 'bgcst${environemnt}'
param bgc_func_plan_name string = 'bgc-func-plan-${environemnt}'
param bgc_vnet_name string = 'bgc-vnet-${environemnt}'
param bgc_vnet_subnet_name string = 'default'
param bgc_cosmos_name string = 'bgc-cosmos-${environemnt}'
param bgc_func_appi_name string = 'bgc-func-appi-${environemnt}'
param bgc_func_appi_workspace_name string = '/subscriptions/0b0b0e44-f48a-4f5b-9ee0-6bf6c571e58a/resourceGroups/DefaultResourceGroup-EUS/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-0b0b0e44-f48a-4f5b-9ee0-6bf6c571e58a-EUS'

resource bgc_func_appi_resource 'microsoft.insights/components@2020-02-02' = {
  name: bgc_func_appi_name
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    RetentionInDays: 90
    WorkspaceResourceId: bgc_func_appi_workspace_name
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource bgc_vnet_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: bgc_vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          serviceEndpoints: [
            {
              service: 'Microsoft.AzureCosmosDB'
              locations: [
                '*'
              ]
            }
          ]
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource bgc_st_resource 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: bgc_st_name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
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
  }
}

resource bgc_func_plan_resource 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: bgc_func_plan_name
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource bgc_cosmos_resource 'Microsoft.DocumentDB/databaseAccounts@2021-10-15' = {
  name: bgc_cosmos_name
  location: location
  kind: 'GlobalDocumentDB'
  identity: {
    type: 'None'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: true
    virtualNetworkRules: [
      {
        id: bgc_vnet_subnet_resource.id
        ignoreMissingVNetServiceEndpoint: false
      }
    ]
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: false
    enableAnalyticalStorage: false
    analyticalStorageConfiguration: {
      schemaType: 'WellDefined'
    }
    databaseAccountOfferType: 'Standard'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    ipRules: [
      {
        ipAddressOrRange: '104.42.195.92'
      }
      {
        ipAddressOrRange: '40.76.54.131'
      }
      {
        ipAddressOrRange: '52.176.6.30'
      }
      {
        ipAddressOrRange: '52.169.50.45'
      }
      {
        ipAddressOrRange: '52.187.184.26'
      }
      {
        ipAddressOrRange: '60.241.65.58'
      }
    ]
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 1440
        backupRetentionIntervalInHours: 48
        backupStorageRedundancy: 'Local'
      }
    }
  }
}

resource bgc_vnet_subnet_resource 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: bgc_vnet_resource
  name: bgc_vnet_subnet_name
  properties: {
    addressPrefix: '10.0.0.0/24'
    serviceEndpoints: [
      {
        service: 'Microsoft.AzureCosmosDB'
        locations: [
          '*'
        ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource bgc_func_resource 'Microsoft.Web/sites@2021-02-01' = {
  name: bgc_func_name
  location: location
  kind: 'functionapp,linux'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${bgc_func_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${bgc_func_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: bgc_func_plan_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'DOTNET|6.0'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 20
      minimumElasticInstanceCount: 0
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: bgc_func_appi_resource.properties.InstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${bgc_st_resource.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(bgc_st_resource.id, bgc_st_resource.apiVersion).keys[0].value}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '10.14.1'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
      ]
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '4E29F012A8C2676B1655214BBEBEF22FEFC382D40F991B746D06404AFA458295'
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource bgc_func_host_name_bindings_resource 'Microsoft.Web/sites/hostNameBindings@2021-02-01' = {
  parent: bgc_func_resource
  name: '${bgc_func_name}.azurewebsites.net'
  properties: {
    siteName: 'bgc-func'
    hostNameType: 'Verified'
  }
}
