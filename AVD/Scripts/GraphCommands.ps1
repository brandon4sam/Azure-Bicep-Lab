#Connect to Graph
Connect-MgGraph -Scopes "User.Read.All", "Group.ReadWrite.All", "Directory.ReadWrite.All"

#Get All Users
Get-MgUser -All

#Get a Specific User
Get-MgUser -UserId "user@contoso.com"

#Get Group Members
Get-MgGroupMember -GroupId <GroupID>

#Get User's Group Membership
Get-MgUserMemberOf -UserId <UserID>

#Get Intune Managed Devices
Get-MgDeviceManagementManagedDevice

#Get Entra Devices
Get-MgDevice

#Get Assigned Licenses
Get-MgUser -UserId user@contoso.com | Select-Object AssignedLicenses

# Search for a group
Get-MgGroup -Filter "displayName eq 'AVD Users'"

# Get all licensed users
Get-MgUser -All | Where-Object {$_.AssignedLicenses.Count -gt 0}

#Get user manager
Get-MgUserManager -UserId user@contoso.com

# Get devices owned by user
Get-MgUserOwnedDevice -UserId user@contoso.com

# Get registered devices
Get-MgUserRegisteredDevice -UserId user@contoso.com

# Get disabled accounts
Get-MgUser -Filter "accountEnabled eq false"

# Get users without MFA registration
Get-MgReportAuthenticationMethodUserRegistrationDetail