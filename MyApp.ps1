
# Nick Pufko 2022

# path / to file on disk. example:                          'MyApp.ps1'
# string / defines the type of sorted values requested.     'alpha', 'numeric', 'both'
# string / defines sort order.                              'ascending', 'descending'

# Requires Positional Parameters:
# ./Script.ps1 "MyDoc.txt" "alpha" "ascending"

param(
    $path,
    $type,  # positional parameters
    $order
)

$data = Get-Content $path       # grabs content from the txt file
$dataarray = $data.split(",")   # converts to array from each comma split

$cleanarray = @()   # create an empty array for combined string and ints

foreach ($item in $dataarray) {
    $item = $item -replace " ",""       # remove any excess spaces from each value
    $item = $item -replace '["]',""     # remove any double quotes from the beginning and end values ("1,2,3") (just in case)
    if ($item -match "^[a-zA-Z]") {
        $item = $item -as [string]
        $cleanarray = $cleanarray += $item
    }
    elseif (!$item.Contains("'")) {     # check if item does not have a '' symbol, convert to double
        $item = $item -as [double]
        $cleanarray = $cleanarray += $item
    }
    else {
        $cleanarray = $cleanarray += $item # by default these will be strings
    }
}

if ($order -eq "descending") {  # sort by descending or ascending
    $sorteddata = $cleanarray | Sort-Object -CaseSensitive -descending
}
else {
    $sorteddata = $cleanarray | Sort-Object -CaseSensitive
}

$cleandata = @()    # create clean data array for next step

foreach ($value in $sorteddata) {
    if ($type -eq "alpha") {
        if ($value -is [string]) {              # if value is string, add it to the cleandata array
            $cleandata = $cleandata += $value
        }
    }
    elseif ($type -eq "numeric") {
        if ($value -is [double]) {
            $cleandata = $cleandata += $value
        }
    }
    elseif ($type -eq "both") {
        $cleandata = $cleandata += $value       # add all values to clean data array since its set to both
    }
    else {
        "Invalid type was entered. Ending script." # Just in case.
        exit
    }
}

$cleandata = $cleandata -join ","   # make it look pretty with commas

# Write-Host "Cleaned Data:"
$cleandata  # print the data!