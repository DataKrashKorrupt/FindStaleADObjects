function Get-StaleADUser {
    [CmdletBinding()]
    param (
        [int]$LastLoginYears,
        [int]$LastLoginMonths
    )
    
    #Determine time period to query
    if ($PSBoundParameters.ContainsKey('LastLoginYears')) {

        Write-Verbose "Time of $LastLoginYears years specified"
        $TimePeriod = (Get-Date).AddYears(-$LastLoginYears)

    } elseif ($PSBoundParameters.ContainsKey('LastLoginMonths')) {

        Write-Verbose "Time of $LastLoginMonths months specified"
        $TimePeriod = (Get-Date).AddMonths(-$LastLoginMonths)

    } else {
        
        Write-Verbose "No Time Period Specified"
        return
    }

    #Get enabled users with last login date of older than specified time period
    Write-Verbose "Retrieving all users that have not logged in prior to $($TimePeriod.ToString("yyyy/MM/dd"))"
    $InactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $TimePeriod -and Enabled -eq $true} -Properties *

    #Pipe objects selecting properties and sorting by LastLogonDate
    $InactiveUsers | Select-Object SamAccountName,DisplayName,Description,DistinguishedName,LastLogonDate,whenCreated | Sort-Object LastLogonDate
    
}