Write-Host '------------------------------' -ForegroundColor Yellow
Write-Host '     UIC Validator v1.00      ' -ForegroundColor Yellow
Write-Host '------------------------------' -ForegroundColor Yellow

function Get-UicSelfCheckDigit
{
    Param ([string] $UicNumber)   

    $uicSum = 0
    $iterator = 0;

    $matchesSingleNumber = ([regex]'[0-9]{1}').Matches($UicNumber)

    # Check UIC number length
    If ($UicNumber.Length -ne 11)
    {
        Write-Host 'UIC number has not valid length of 11 numbers!' $UicNumber -ForegroundColor Red
        exit
    }

    foreach ($match in $matchesSingleNumber)
    {
        If ($iterator % 2 -eq 0)
        {
            $oddNumber = 2 * $match.Value
            If ($oddNumber -gt 9)
            {
                $uicSum += $oddNumber - 9
            }
            Else
            {
                $uicSum += $oddNumber
            }
        }
        Else
        {
            $uicSum += $match.Value        
        }
        $iterator++
    }

    $uicSelfCheckDigit = 0
    If (($uicSum % 10) -gt 0)
    {
        $uicSelfCheckDigit = 10 - ($uicSum % 10)
    }
    return $uicSelfCheckDigit
}


# Check if a 1st paramter was given.
If ($args.Count -ne 1)
{
    Write-Host 'Please provide UIC number!' -ForegroundColor Red
    exit
}

# UIC is given as 1st parameter
$uic = $args[0]

# UIC with no spaces and dashes
$uicRawNumber = ''

# Convert UIC to raw number.
$matchesUic = ([regex]'[0-9]+').Matches($uic)

foreach ($match in $matchesUic)
{
    $uicRawNumber = $uicRawNumber + $match.Value
}

# Check UIC number length
If (($uicRawNumber.Length -lt 11) -or ($uicRawNumber.Length -gt 12))
{
    Write-Host 'UIC number has invalid length of' $uicRawNumber.Length 'numbers!' -ForegroundColor Red
    Write-Host 'Only 11 or 12 numbers are allowed.' -ForegroundColor Red
    exit
}

# In case of 11 numbers length, calculate self-check digit.
If ($uicRawNumber.Length -eq 11)
{  
    Write-Host 'Calculating UIC...' $uicRawNumber

    $uicSelfCheck = Get-UicSelfCheckDigit -uic $uicRawNumber
    Write-Host "UIC: $uicRawNumber-$uicSelfCheck" -ForegroundColor Green
}

# In case of 12 numbers validate the self-check digit.
If ($uicRawNumber.Length -eq 12)
{
    Write-Host 'Testing UIC...' $uicRawNumber

    $selfCheckInput = $uicRawNumber.Substring($uicRawNumber.Length - 1, 1)
    $selfCheckCalculated = Get-UicSelfCheckDigit -uic $uicRawNumber.Substring(0, 11)

    # Calculated Self-checked digit is the same, means that UIC is valid.
    If ($selfCheckInput -eq $selfCheckCalculated)
    { 
        Write-Host 'UIC:' $uicRawNumber 'is valid.' -ForegroundColor Green
    }
    Else
    {
        Write-Host 'UIC:' $uicRawNumber 'is invalid.' -ForegroundColor Red
        
        # Remove last digit and calculate it.
        $uicRawNoCheck = $uicRawNumber.Substring(0, $uicRawNumber.Length - 1)

        Write-Host 'Calculating UIC...' $uicRawNoCheck
        $uicSelfCheck = Get-UicSelfCheckDigit($uicRawNoCheck)
       
        Write-Host "UIC: $uicRawNoCheck-$uicSelfCheck" -ForegroundColor Green
    }
}


