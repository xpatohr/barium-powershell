function Get-BariumToken {

    <#

    .SYNOPSIS
    Post login details to authenticate user.

    .DESCRIPTION
    Authenticate the user using an API key, a user name and a password.

    .PARAMETER UserName
    Username for the API user.

    .PARAMETER Password
    Password to authenticate the API user.

    .PARAMETER ApiKey
    Api key related to the user context.

    .PARAMETER Uri
    Uri for connect to the Barium API.

    .OUTPUTS
    System.String

    .EXAMPLE
    PS> Get-BariumToken -Uri 'https://live.barium.se/api/v1.0' -UserName 'api.user@barium.se' -ApiKey 'd98d6ee1-e45c-4147-af6c-cbbe1840c6b6' -Password $("Password#1" | ConvertTo-SecureString -AsPlainText -Force)
    d4ef46cc-8e2b-4848-8b38-15eece903df9

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Username for the API user.")]
        [string]$UserName,
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Password to authenticate the API user.")]
        [SecureString]$Password,
        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Api key related to the user context.")]
        [string]$ApiKey,
        [Parameter(Mandatory = $true, Position = 3, HelpMessage = "Uri for connect to the Barium API.")]
        [string]$Uri
    )

    $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $Password

    $parameters = @{
        Uri    = "{0}/authenticate" -f $Uri
        Body   = @{
            username = $Credentials.GetNetworkCredential().UserName
            password = $Credentials.GetNetworkCredential().Password
            apikey   = $ApiKey
        }
        Method = 'POST'
    }


    try {

        # Make API call
        $token = Invoke-RestMethod @parameters -ErrorAction Stop

        # Return token from API call
        return $token

    }

    catch {

        # Write error if an error has occourd
        Write-Error $_

    }

}

function Get-BariumList {

    <#

    .SYNOPSIS
    Get all lists

    .DESCRIPTION
    Get all lists or specify a specific list by -List parameter.

    .PARAMETER Token
    Token for authentication.

    .PARAMETER Uri
    Uri for connect to the Barium API.

    .PARAMETER List
    Id for the list.

    .PARAMETER Data
    View data on specific list.

    .OUTPUTS
    PSCustomObject

    .EXAMPLE
    PS> Get-BariumList -Uri 'https://live.barium.se/api/v1.0' -List '56ef540b-ef29-45bd-8525-0b02417736391' -Token $token

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Token for authentication.")]
        [string]$Token,
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Uri for connect to the Barium API.")]
        [string]$Uri,
        [Parameter(Mandatory = $false, Position = 2, HelpMessage = "Id for the list.")]
        [string]$List,
        [Parameter(Mandatory = $false, Position = 3, HelpMessage = "View data for list or only list information?")]
        [switch]$Data
    )

    if ([string]::IsNullOrEmpty($List) -eq $false) {

        if ($Data.IsPresent -eq $true) {
            $showDataFields = '/Data'
        }

        $Url = "{0}/lists/{1}{2}" -f $Uri, $List, $showDataFields

    }

    else {

        if ($Data.IsPresent -eq $true) {
            Write-Warning "You can only use parameter 'Data' if parameter 'List' is set."
        }

        $Url = "{0}/lists" -f $Uri
    }


    $parameters = @{
        Uri     = $Url
        Headers = @{ 'ticket' = $token }
        Method  = 'GET'
    }

    try {

        $content = Invoke-RestMethod @parameters -ErrorAction Stop

        return $content

    }

    catch {

        Write-Error $_

    }

}

function Get-BariumObject {

    <#

    .SYNOPSIS
    Get information about objects, such as forms, files and folders.

    .DESCRIPTION
    Gets basic metadata for an object in the repository, such as a form or a file.

    .PARAMETER Token
    Token for authentication.

    .PARAMETER Uri
    Uri for connect to the Barium API.

    .PARAMETER List
    Id for the list.

    .OUTPUTS
    PSCustomObject

    .EXAMPLE
    PS> Get-BariumObject -Uri 'https://live.barium.se/api/v1.0' -List '56ef540b-ef29-45bd-8525-0b0241773639' -Token $token

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Token for authentication.")]
        [string]$Token,
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Uri for connect to the Barium API.")]
        [string]$Uri,
        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Id for the list.")]
        [string]$List
    )

    $parameters = @{
        Uri     = "{0}/Objects/{1}/Fields" -f $Uri, $List
        Headers = @{ 'ticket' = $token }
        Method  = 'GET'
    }

    $parameters

    try {

        $content = Invoke-RestMethod @parameters -ErrorAction Stop

        return $content

    }

    catch {

        Write-Error $_

    }

}

function Edit-BariumObject {

    <#

    .SYNOPSIS
    Edit information about objects, such as forms, files and folders.

    .DESCRIPTION
    Gets basic metadata for an object in the repository, such as a form or a file.

    .PARAMETER Token
    Token for authentication.

    .PARAMETER Uri
    Uri for connect to the Barium API.

    .PARAMETER List
    Id for the list.

    .PARAMETER Values
    Hashtable contain fields and values to edit..

    .OUTPUTS
    System.String

    .EXAMPLE
    PS> Edit-BariumObject -Uri 'https://live.barium.se/api/v1.0' -List '6fb70a0b-8cf8-44af-bd53-bb16c4f64ab1' -Token $token -Values @{ 'samAccountName' = 'usr123' }

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Token for authentication.")]
        [string]$Token,
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Uri for connect to the Barium API.")]
        [string]$Uri,
        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Id for the list.")]
        [string]$List,
        [Parameter(Mandatory = $true, Position = 3, HelpMessage = "Hashtable contain fields and values to edit.")]
        [object]$Values
    )

    $parameters = @{
        Uri     = "{0}/Objects/{1}/Fields" -f $Uri, $List
        Headers = @{ 'ticket' = $token }
        Method  = 'POST'
        Body    = $values
    }

    try {

        $content = Invoke-RestMethod @parameters -ErrorAction Stop

        return $content

    }

    catch {

        Write-Error $_

    }

}

function Set-BariumInstance {

    <#

    .SYNOPSIS
    Set status on Barium instance

    .DESCRIPTION
    Instances and instance metadata

    .PARAMETER Token
    Token for authentication.

    .PARAMETER Uri
    Uri for connect to the Barium API.

    .PARAMETER Object
    Id for the object.

    .PARAMETER Values
    Hashtable contain fields and values to edit..

    .OUTPUTS
    System.String

    .EXAMPLE
    PS> Set-BariumInstance -Uri 'https://live.barium.se/api/v1.0' -Object '6fb70a0b-8cf8-44af-bd53-bb16c4f64ab1' -Token $token -Values @{ 'Message' = 'SUCCESS' }

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Token for authentication.")]
        [string]$Token,
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Uri for connect to the Barium API.")]
        [string]$Uri,
        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Id for the list.")]
        [string]$Object,
        [Parameter(Mandatory = $true, Position = 3, HelpMessage = "Hashtable contain fields and values to edit.")]
        [object]$Values
    )

    $parameters = @{
        Uri     = "{0}/Instances/{1}" -f $Uri, $Object
        Headers = @{ 'ticket' = $token }
        Method  = 'POST'
        Body    = $values
    }

    try {

        $content = Invoke-RestMethod @parameters -ErrorAction Stop

        return $content

    }

    catch {

        Write-Error $_

    }

}


Export-ModuleMember -Function Get-BariumToken, Get-BariumList, Get-BariumObject, Edit-BariumObject, Set-BariumInstance