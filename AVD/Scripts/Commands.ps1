# =====================================================
# Bicep Build Commands
# =====================================================

az bicep build --file .\VMs\vmserver.bicep

# =====================================================
# Bicep What-If
# =====================================================

az deployment group what-if `
--resource-group rg-avd-bicep2-LAB `
--template-file .\VMs\vmserver.bicep

# =====================================================
# Deploy VM
# =====================================================

az deployment group create `
--resource-group rg-avd-bicep2-LAB `
--template-file .\VMs\vmserver.bicep

# =====================================================
# Delete VM
# =====================================================

az vm delete `
--resource-group rg-avd-bicep2-LAB `
--name windowsservervm01 `
--yes

# =====================================================
# List VMs
# =====================================================

az vm list `
--resource-group rg-avd-bicep2-LAB `
-o table



# What-If

az deployment group what-if `
--resource-group rg-avd-bicep2-LAB `
--template-file .\VMs\vmserver.bicep

# Exclude Noise

az deployment group what-if `
--resource-group rg-avd-bicep2-LAB `
--template-file .\VMs\vmserver.bicep `
--exclude-change-types Ignore


# Build

az bicep build --file .\VMs\vmserver.bicep

# Lint

az bicep lint --file .\VMs\vmserver.bicep

# Validate Deployment

az deployment group validate `
--resource-group rg-avd-bicep2-LAB `
--template-file .\VMs\vmserver.bicep



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


# Status/Git Commands

git status

# Add

git add .

# Commit

git commit -m "Updated VM Server Template"

# Push

git push

# Pull

git pull



# Current Subscription/Azure

az account show

# List Subscriptions

az account list -o table

# Switch Subscription

az account set `
--subscription "Sandbox"









# NOTES

# Deploy VM:
# 1. Build
# 2. Validate
# 3. What-If
# 4. Deploy

# Subnet Resource ID Format:
# /subscriptions/<subid>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<subnet>