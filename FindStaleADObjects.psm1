function Get-StaleADComputer {
<#
.SYNOPSIS
This tool will query AD for enabled computer objects that have not authenticated with the Domain Controller within the specified timeframe of either months or years.

.DESCRIPTION
A simple tool that queries Active Directory for active computer objects that have not authenticated with the Domain Controller within a specified time period. This module must be either run locally on Domain Controller or on endpoint with the ActiveDirectory module installed to run the query.

The tool uses LastLogonDate property of the computer object to determine the results returned based on input.

.PARAMETER LastLoginMonths
Enter number of months (1-11) in past time as threshold. Will return any object with a login time stamp older than this.

.PARAMETER LastLoginYears
Enter number of years in past time as threshold. Will return any object with a login time stamp older than this.

.EXAMPLE
This will return computer objects that have not authenticated in over 6 months, will sort objects by LastLogon timestamp with oldest at the top, and export the results to a CSV file:

Get-StaleADComputer -LastLoginMonths 6 | Sort-Object LastLogon | Export-CSV C:\temp\staleADComputers.csv

.EXAMPLE
This will return all computer objects that have not authenticated in over 1 year (default value) and display results in table in the console:

Get-StaleADComputer -LastLoginYears 

.EXAMPLE
Will return all computer objects that have not authenticated in over 2 months (positional parameter in default parameter set) and will display results in table in the console with oldest at the top:

Get-StaleADComputer 2 | Sort-Object LastLogon

.INPUTS
None. You cannot pipe objects to this module.

.OUTPUTS
PSObject

.LINK
https://learn.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2022-ps

.LINK
https://github.com/DataKrashKorrupt/Get-StaleADComputer.git
#>
    [CmdletBinding(DefaultParameterSetName="Months")]
    param (
        [Parameter(ParameterSetName="Years")]
        [PSDefaultValue(Help='1 Year')]
        [int]$LastLoginYears = 1,
        
        [Parameter(ParameterSetName="Months")]
        [PSDefaultValue(Help='3 Months')]
        [ValidateRange(1,11)]
        [int]$LastLoginMonths = 3
    )
    
    #Determine time period to query
    if ($PSBoundParameters.ContainsKey('LastLoginMonths')) {
        Write-Verbose "Time of $LastLoginMonths months specified"
        $timePeriod = (Get-Date).AddMonths(-$LastLoginMonths)
    } elseif ($PSBoundParameters.ContainsKey('LastLoginYears')) {
        Write-Verbose "Time of $LastLoginYears years specified"
        $timePeriod = (Get-Date).AddYears(-$LastLoginYears)
    }

    #Get enabled computer objects with last login date of older than specified time period
    Write-Verbose "Retrieving all computers that have not logged in prior to $($timePeriod.ToString("yyyy/MM/dd"))"
    $inactiveComputers = Get-ADComputer -Filter {LastLogonDate -lt $timePeriod -and Enabled -eq $true} -Properties *

    #Creating object and properties to output to pipeline
    [pscustomobject]@{
        'ComputerName' = $inactiveComputers.Name
        'OS' = $inactiveComputers.OperatingSystem
        'Description' = $inactiveComputers.Description
        'ADObject' = $inactiveComputers.DistinguishedName
        'LastLogon' = $inactiveComputers.LastLogonDate
        'Created' = $inactiveComputers.whenCreated
    }
}


function Get-StaleADUser {
<#
.SYNOPSIS
This tool will query AD for enabled user objects that have not authenticated with the Domain Controller within the specified timeframe of either months or years.

.DESCRIPTION
A simple tool that queries Active Directory for active user objects that have not authenticated with the Domain Controller within a specified time period. This module must be either run locally on Domain Controller or on endpoint with the ActiveDirectory module installed to run the query.

The tool uses LastLogonDate property of the user object to determine the results returned based on input.

.PARAMETER LastLoginMonths
Enter number of months (1-11) in past time as threshold. Will return any object with a login time stamp older than this.

.PARAMETER LastLoginYears
Enter number of years in past time as threshold. Will return any object with a login time stamp older than this.

.EXAMPLE
This will return user objects that have not authenticated >6 months, will sort objects by LastLogon timestamp with oldest at the top, and export the results to a CSV file:

Get-StaleADuser -LastLoginMonths 6 | Sort-Object LastLogon | Export-CSV C:\temp\staleADusers.csv

.EXAMPLE
This will return all user objects that have not authenticated in >1 year (default value) and display results in table in the console:

Get-StaleADuser -LastLoginYears 

.EXAMPLE
Will return all user objects that have not authenticated in >2 months (positional parameter in default parameter set) and will display results in table in the console with oldest at the top:

Get-StaleADuser 2 | Sort-Object LastLogon

.INPUTS
None. You cannot pipe objects to this module.

.OUTPUTS
PSObject

.LINK
https://learn.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2022-ps

.LINK
https://github.com/DataKrashKorrupt/Get-StaleADUser.git
#>
    [CmdletBinding(DefaultParameterSetName='Months')]
    param (
        [Parameter(ParameterSetName='Years')]
        [PSDefaultValue(Help='1 Year')]
        [int]$LastLoginYears = 1,

        [Parameter(ParameterSetName='Months')]
        [PSDefaultValue(Help='3 Months')]
        [ValidateRange(1,11)]
        [int]$LastLoginMonths = 3
    )
    
    #Determine time period to query
    if ($PSBoundParameters.ContainsKey('LastLoginMonths')) {
        Write-Verbose "Time of $LastLoginMonths months specified"
        $TimePeriod = (Get-Date).AddMonths(-$LastLoginMonths)
    } elseif ($PSBoundParameters.ContainsKey('LastLoginYears')) {
        Write-Verbose "Time of $LastLoginYears years specified"
        $TimePeriod = (Get-Date).AddYears(-$LastLoginYears)
    }

    #Get enabled users with last login date of older than specified time period
    Write-Verbose "Retrieving all users that have not logged in prior to $($TimePeriod.ToString("yyyy/MM/dd"))"
    $inactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $TimePeriod -and Enabled -eq $true} -Properties *

    #Creating object and properties to output to pipeline
    [PSCustomObject]@{
        'UserName' = $inactiveUsers.SamAccountName
        'FullName' = $inactiveUsers.DisplayName
        'Description' = $inactiveUsers.Description
        'ADObject' = $inactiveUsers.DistinguishedName
        'LastLogon' = $inactiveUsers.LastLogonDate
        'Created' = $inactiveUsers.whenCreated
    }
}