---
external help file: FindStaleADObjects-help.xml
Module Name: FindStaleADObjects
online version: 
schema: 2.0.0
---

# Get-StaleADUser

## SYNOPSIS
This tool will query AD for enabled user objects that have not authenticated with the Domain Controller within the specified timeframe of either months or years.

## SYNTAX

### Months (Default)
```
Get-StaleADUser [-LastLoginMonths <Int32>] [<CommonParameters>]
```

### Years
```
Get-StaleADUser [-LastLoginYears <Int32>] [<CommonParameters>]
```

## DESCRIPTION
A simple tool that queries Active Directory for active user objects that have not authenticated with the Domain Controller within a specified time period.
This module must be either run locally on Domain Controller or on endpoint with the ActiveDirectory module installed to run the query.

The tool uses LastLogonDate property of the user object to determine the results returned based on input.

## EXAMPLES

### EXAMPLE 1
```
6 months, will sort objects by LastLogon timestamp with oldest at the top, and export the results to a CSV file:
```

Get-StaleADuser -LastLoginMonths 6 | Sort-Object LastLogon | Export-CSV C:\temp\staleADusers.csv

### EXAMPLE 2
```
1 year (default value) and display results in table in the console:
```

Get-StaleADuser -LastLoginYears

### EXAMPLE 3
```
2 months (positional parameter in default parameter set) and will display results in table in the console with oldest at the top:
```

Get-StaleADuser 2 | Sort-Object LastLogon

## PARAMETERS

### -LastLoginYears
Enter number of years in past time as threshold.
Will return any object with a login time stamp older than this.

```yaml
Type: Int32
Parameter Sets: Years
Aliases:

Required: False
Position: Named
Default value: 1 Year
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastLoginMonths
Enter number of months (1-11) in past time as threshold.
Will return any object with a login time stamp older than this.

```yaml
Type: Int32
Parameter Sets: Months
Aliases:

Required: False
Position: Named
Default value: 3 Months
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this module.
## OUTPUTS

### PSObject
## NOTES

## RELATED LINKS

[Get-StaleADComputer](Get-StaleADComputer.md)

[Active Directory Module](https://learn.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2022-ps)

