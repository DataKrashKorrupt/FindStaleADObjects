function Get-StaleADComputer {
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
    [pscustomobject]$properties = @{
        'ComputerName' = $inactiveComputers.Name
        'OS' = $inactiveComputers.OperatingSystem
        'Description' = $inactiveComputers.Description
        'ADObject' = $inactiveComputers.DistinguishedName
        'LastLogon' = $inactiveComputers.LastLogonDate
        'Created' = $inactiveComputers.whenCreated
    } 

    Write-Output $properties
}