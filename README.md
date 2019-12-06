# PowerShell integration with Barium API

PowerShell module to integrate with Barium API.

## Requirements

- PowerShell 3.0

## Functions

| Function            | Description                                                      |
| ------------------- | ---------------------------------------------------------------- |
| `Get-BariumToken`   | Post login details to authenticate user                          |
| `Get-BariumList`    | Get all lists                                                    |
| `Get-BariumObject`  | Get information about objects, such as forms, files and folders  |
| `Edit-BariumObject` | Edit information about objects, such as forms, files and folders |

## Example

#### Use the Barium module

```powershell
Import-Module .\Barium.psm1

$settings  =  @{
    Uri  =  'https://live.barium.se/api/v1.0'
    UserName = 'uu@domain.se'
    Password = 'pwd1'
    ApiKey = '[guid]'
}
```

#### Create authentication and recive a token

```powershell
$token = Get-BariumToken -Uri $settings.Uri -UserName $settings.UserName -ApiKey $settings.ApiKey -Password $settings.Password
```

#### Fetch list

If the '-Data' parameter is set, all data will be displayed. Otherwise, it's just the list.

```powershell
$list = Get-BariumList -Uri $settings.Uri -Token $token -List 'd4463ae9-a50a-49ab-9160-80c60637c78d' -Data
```

Or you can use this row to fetch all lists.

```powershell
$list = Get-BariumList -Uri $settings.Uri -Token $token
```

#### Get listobjects from the selected list

```powershell
$object = Get-BariumObject -Uri $settings.Uri -Token $token -List $list.'form.formId'
```

#### Select All 'Names' and 'Values'

```powershell
$object.Data | Select-Object Name, Value
```

This will return the current values, etc `samAccountName: user1`

#### Update 'SamAccountName' and 'Password' to Barium

```powershell
$values = @{
    samAccountName = 'USX1'
    Password = 'Random'
}
```

This item above wants to update 'samAccountName' and 'Password' with new values.

```powershell
Edit-BariumObject -Uri $settings.Uri -Token $token -List $list.'form.formId' -Values $values
```

## License

This project is licensed under the MIT.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
