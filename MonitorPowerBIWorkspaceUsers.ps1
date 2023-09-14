# Check if the required modules are installed, and install them if not
if (!(Get-Module -Name MicrosoftPowerBIMgmt -ListAvailable)) {
    Install-Module -Name MicrosoftPowerBIMgmt
}

function get-sha256 ($string) {
    $sha256 = New-Object System.Security.Cryptography.SHA256CryptoServiceProvider
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($string)
    $hash = $sha256.ComputeHash($bytes)
    $result = [System.BitConverter]::ToString($hash) -replace '-'
    return $result
}
    

# Get a list of tenants, one txt file pr tenant in the tenants folder
# The file should be named after tenant and contain username in the first line and password in the second
$tenants = Get-ChildItem -Path ".\tenants\" -file

$GDPRCompliance = $true

$users = @()
# Loop through each tenant
foreach ($tenant in $tenants) {
    # Get the path to the credential file for the tenant
    $credentialPath = $tenant.fullname

    # Read the username and password from the credential file
    $credentials = Get-Content -Path $credentialPath
    $username = $credentials[0]
    $password = $credentials[1]

    # Convert the password to a secure string
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force

    # Create a PSCredential object from the username and secure password
    $credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

    # Connect to the Power BI service using the tenant's credentials. 
    
    Connect-PowerBIserviceaccount -Credential $credential

    # Get a list of all the workspaces in the tenant.
    # The users field will only contain data if the -scope organization parameter is set, and this parameter requires
    # that the user has tenant administrator rights in the customers powerbi account/tenant.
    $workspaces = (Invoke-PowerBIRestMethod -Method get -Url ("groups") | ConvertFrom-Json).value 


    # Loop through each workspace
    foreach ($workspace in $workspaces) {
        # Get a list of all the users in the workspace
        $workspaceUsers = (Invoke-PowerBIRestMethod -Method get -Url ("groups/$($workspace.Id)/users") | ConvertFrom-Json).value

        # Loop through each user
        foreach ($workspaceUser in $workspaceUsers) {
            if ($GDPRCompliance) { # if the GDPRCompliance flag is set, the email address is hashed and only firstname is saved
                $user = [PSCustomObject]@{
                    Clock      = Get-Date
                    Tenant     = $tenant.BaseName
                    Workspace  = $workspace.Name
                    Name       = $workspaceUser.firstName
                    Email      = get-sha256($workspaceUser.emailAddress)
                    AccessRole = $workspaceUser.groupUserAccessRight
                }
            } else {
            # Create a custom object to store the tenant name, user name, user email, and access role
            $user = [PSCustomObject]@{ # if the GDPRCompliance flag is not set, the email address is saved in clear text
                Clock      = Get-Date
                Tenant     = $tenant.BaseName
                Workspace  = $workspace.Name
                Name       = $workspaceUser.displayName
                Email      = $workspaceUser.emailAddress
                AccessRole = $workspaceUser.groupUserAccessRight
            }
        }
            # Add the user information to the array of users
            $users += $user
        }
    }
}

# Export the information about the users to a CSV file
$users | Export-Csv -Path ".\users.csv" -Append
