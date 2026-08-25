# Build

az bicep build `
--file .\VMs\vmserver.bicep

# Validate

az deployment group validate `
--resource-group rg-avd-bicep2-LAB `
--template-file .\VMs\vmserver.bicep

# What-If

az deployment group what-if `
--resource-group rg-avd-bicep2-LAB `
--template-file .\VMs\vmserver.bicep