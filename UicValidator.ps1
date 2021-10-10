Write-Host '------------------------------' -ForegroundColor Yellow
Write-Host '     UIC Validator v1.00      ' -ForegroundColor Yellow
Write-Host '------------------------------' -ForegroundColor Yellow

function Get-UicSelfCheckDigit
{
    Param ([string] $uic)   

    $uicSum = 0
    $iterator = 0;

    $matchesNumber = ([regex]'[0-9]{1}').Matches($uic)

    # Check UIC number length
    If ($uic.Length -ne 11) {
        Write-Host 'UIC number has not valid length of 11 numbers!' $uic -ForegroundColor Red
        exit
    }

    foreach ($match in $matchesNumber) {
        If ($iterator % 2 -eq 0) {
            $oddNumber = 2 * $match.Value
            If ($oddNumber -gt 9) {
                $uicSum += $oddNumber - 9
            }
            Else {
                $uicSum += $oddNumber
            }
        }
        Else {
            $uicSum += $match.Value        
        }
        $iterator++
    }

    $uicSelfCheckDigit = 0
    If (($uicSum % 10) -gt 0) {
        $uicSelfCheckDigit = 10 - ($uicSum % 10)
    }
    return $uicSelfCheckDigit
}


# Check If 1st paramter was given.
If ($args.Count -ne 1)
{
    Write-Host 'Please provide UIC number!' -ForegroundColor Red
    exit
}

# UIC is given as 1st parameter
$uic = $args[0]

$uicRawNumber = ''

# Convert UIC to raw number.
$matchesUic = ([regex]'[0-9]+').Matches($uic)

foreach ($match in $matchesUic) {
    $uicRawNumber = $uicRawNumber + $match.Value
}

# Check UIC number length
If (($uicRawNumber.Length -lt 11) -or ($uicRawNumber.Length -gt 12)) {
    Write-Host 'UIC number has invalid length of' $uicRawNumber.Length 'numbers! Only 11 or 12 numbers are allowed.' -ForegroundColor Red
    exit
}

# Check how many number are in UIC
$matchesNumber = ([regex]'[0-9]{1}').Matches($uic)

# In case of 11 numbers length, calculate self-check digit.
If ($matchesNumber.Count -eq 11) {
    
    Write-Host 'Calculating UIC...' $uicRawNumber

    $uicSelfCheck = Get-UicSelfCheckDigit -uic $uicRawNumber
    Write-Host 'UIC:' $uicRawNumber '-' $uicSelfCheck -ForegroundColor Green
}

# In case of 12 numbers validate the self-check digit.
If ($matchesNumber.Count -eq 12) {

    Write-Host 'Testing UIC...' $uicRawNumber

    $scDigit = $uicRawNumber.Substring($uicRawNumber.Length - 1, 1)
    $uicSelfCheck = Get-UicSelfCheckDigit -uic $uicRawNumber.Substring(0, 11)

    $isValid = $false

    If($scDigit -eq $uicSelfCheck) {
        $isValid = $true
    }

    If ($isValid) { 
        Write-Host 'UIC:' $uicRawNumber 'is valid.' -ForegroundColor Green
    }
    Else {
        Write-Host 'UIC:' $uicRawNumber 'is invalid.' -ForegroundColor Red
        
        $uicRawNoCheck = $uicRawNumber.Substring(0, $uicRawNumber.Length - 1)

        Write-Host 'Calculating UIC...' 
        $uicSelfCheck = Get-UicSelfCheckDigit($uicRawNoCheck)
       
        Write-Host 'UIC:' $uicRawNoCheck '-' $UicSelfCheck -ForegroundColor Green
    }
}


