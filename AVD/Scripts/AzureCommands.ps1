# List RGs

az group list -o table

# Create RG

az group create `
--name rg-avd-bicep2-LAB `
--location eastus

# Delete RG

az group delete `
--name rg-avd-bicep2-LAB `
--yes

# Start VM

az vm start `
--resource-group rg-avd-bicep2-LAB `
--name windowsservervm01

# Stop VM

az vm stop `
--resource-group rg-avd-bicep2-LAB `
--name windowsservervm01

# Deallocate VM

az vm deallocate `
--resource-group rg-avd-bicep2-LAB `
--name windowsservervm01

# Show VM

az vm show `
--resource-group rg-avd-bicep2-LAB `
--name windowsservervm01


# List VNets

az network vnet list -o table

# List Subnets

az network vnet subnet list `
--resource-group rg-avd-bicep2-LAB `
--vnet-name vnet-bicep2-lab `
-o table

# Get Subnet ID

az network vnet subnet show `
--resource-group rg-avd-bicep2-LAB `
--vnet-name vnet-bicep2-lab `
--name serversubnet `
--query id -o tsv


# List Storage Accounts

az storage account list -o table

# List File Shares

az storage share list `
--account-name avdcloudfslogixst `
-o table




# Current Subscription

az account show

# List Subscriptions

az account list -o table

# Switch Subscription

az account set `
--subscription "Sandbox"