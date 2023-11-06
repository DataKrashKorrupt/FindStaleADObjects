function Get-StaleADComputer {
    [CmdletBinding()]
    param (
        [int]$LastLoginYears,
        [int]$LastLoginMonths
    )
    
    #Determine time period to query
    if ($PSBoundParameters.ContainsKey('LastLoginYears')) {
        Write-Verbose "Time of $LastLoginYears years specified"
        $timePeriod = (Get-Date).AddYears(-$LastLoginYears)
    } elseif ($PSBoundParameters.ContainsKey('LastLoginMonths')) {
        Write-Verbose "Time of $LastLoginMonths months specified"
        $timePeriod = (Get-Date).AddMonths(-$LastLoginMonths)
    } else {
        Write-Verbose "No Time Period Specified"
        return
    }

    #Get enabled computer objects with last login date of older than specified time period
    Write-Verbose "Retrieving all computers that have not logged in prior to $($TimePeriod.ToString("yyyy/MM/dd"))"
    $inactiveComputers = Get-ADComputer -Filter {LastLogonDate -lt $TimePeriod -and Enabled -eq $true} -Properties *

    #Creating object and properties to output to pipeline
    [pscustomobject]$properties = @{
        'ComputerName' = $inactiveComputers.Name
        'OperatingSystem' = $inactiveComputers.OperatingSystem
        'Description' = $inactiveComputers.Description
        'DistinguishedName' = $inactiveComputers.DistinguishedName
        'LastLogon' = $inactiveComputers.LastLogonDate
        'Created' = $inactiveComputers.whenCreated
    } 

    Write-Output $properties
}