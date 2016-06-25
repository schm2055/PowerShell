#Random password generator
function New-Password {
    param(
        [Parameter()]
        [ValidateRange(8,32767)]
        [int16]$Length="8",

        #Each parameter validates that the total specified number of individual character types doesn't exceed $Length.
        [Parameter()]
        [ValidateScript({if ($_ -le ($Length - ($Uppercase + $Number + $Symbol))) {
            $true
        } else {
            Throw "Total value of uppercase, lowercase, symbol, and number cannot be greater than count."
        }})]
        [int16]$Lowercase="1",

        [Parameter()]
        [ValidateScript({if ($_ -le ($Length - ($Lowercase + $Symbol + $Number))) {
            $true
        } else {
            Throw "Total value of uppercase, lowercase, symbol, and number cannot be greater than count."
        }})]
        [int16]$Uppercase="1",

        [Parameter()]
        [ValidateScript({if ($_ -le ($Length - ($Lowercase + $Uppercase + $Number))) {
            $true
        } else {
            Throw "Total value of uppercase, lowercase, symbol, and number cannot be greater than count."
        }})]
        [int16]$Symbol="1",

        [Parameter()]
        [ValidateScript({if ($_ -le ($Length - ($Lowercase + $Uppercase + $Symbol))) {
            $true
        } else {
            Throw "Total value of uppercase, lowercase, symbol, and number cannot be greater than count."
        }})]
        [int16]$Number="1"
    )

    #Put all the character types into happy little buckets.
    $lowers=(100..122).foreach{[char]$_}
    $uppers=(65..90).ForEach{[char]$_}
    $symbols=(33..47).foreach{[char]$_}+(58..64).foreach{[char]$_}
    $numbers=(48..57).foreach{[char]$_}

    #Plunder the buckets!
    $lowRand=$lowers | Get-Random -Count $Lowercase
    $upRand=$uppers | Get-Random -Count $Uppercase
    $symRand=$symbols | Get-Random -Count $Symbol
    $numRand=$numbers | Get-Random -Count $Number

    <#Now we're going to blend our bucket plunder into a password that's as random
    as Get-Random can make it.  If the total number of specified character types is
    less than the length, we'll plunder the happy little buckets for enough characters
    to fill it out.#>
    $totalChars = ($Lowercase+$Uppercase+$Number+$Symbol)

    if ($Length -gt $totalChars) {
        $extra=($lowers,$uppers,$symbols,$numbers) | Get-Random -Count ($Length - $totalChars)
        $password=-join ($lowRand,$upRand,$symRand,$numRand,$extra | Get-Random -Count $Length)
    }
    else {
        $password=-join ($lowRand,$upRand,$symRand,$numRand | Get-Random -Count $Length)
    }

    #Here's your password.  I hope you're happy, because the little buckets aren't.
    $password
}