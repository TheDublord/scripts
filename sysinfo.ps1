Write-Host ""
# Check if a default browser is set
$defaultBrowser = (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice').ProgId
if ([string]::IsNullOrEmpty($defaultBrowser)) {
    Write-Host "Setting Microsoft Edge as the default browser..."
    SetEdgeAsDefaultBrowser
}
# Function to convert size to human-readable format
function ConvertTo-HumanReadable {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [int64]$size
    )
    
    $units = "B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
    $index = 0

    while ($size -ge 1024 -and $index -lt $units.Length) {
        $size = $size / 1024
        $index++
    }

    return $size, $units[$index]
}

# Set the battery report path
$reportPath = "$env:USERPROFILE\Desktop\battery_report.html"

# Generate battery report
if (-not (Test-Path $reportPath)) {
    Write-Host "Generating battery report..."
    powercfg /batteryreport /output $reportPath
}
# Get system information
$systemInfo = Get-CimInstance -Class Win32_ComputerSystem | Select-Object Manufacturer, Model

Write-Host "$($systemInfo.Manufacturer) $($systemInfo.Model)"
Write-Host "------------------"

# Get operating system information
$osInfo = Get-CimInstance -Class Win32_OperatingSystem | Select-Object Caption

Write-Host "Operating System: $($osInfo.Caption)"


# Get CPU information
$cpuInfo = Get-CimInstance -Class Win32_Processor | Select-Object -First 1

$cpuName = $cpuInfo.Name -creplace "CPU|\(TM\)|\(R\)"
$cpuCores = $cpuInfo.NumberOfCores

Write-Host "CPU: $cpuName - $cpuCores Core(s)"


# Get GPU information
$gpuInfo = Get-CimInstance -Class Win32_VideoController | Select-Object -First 1
$gpuManufacturer = $gpuInfo.VideoProcessor
$gpuName = $gpuInfo.Name -creplace "\(R\)"

if ($gpuManufacturer -notlike "*Intel*") {
    $gpuRAM = $gpuInfo.AdapterRAM / 1GB
    Write-Host "GPU: $gpuName " -NoNewLine
    Write-Host "$gpuRAM GB" -ForegroundColor Green
} else {
    Write-Host "GPU: $gpuName "
    }
# Get RAM information
$ramInfo = Get-CimInstance -Class Win32_PhysicalMemory

$ramModules = $ramInfo.Count
$totalCapacity = ($ramInfo.Capacity | Measure-Object -Sum).Sum
$filledSlotsMatch = $ramInfo | Select-String -Pattern 'LocationDimm'
if ($filledSlotsMatch) {
    $filledSlots = ($filledSlotsMatch | Select-Object -ExpandProperty LineNumber) -join ','
} else {
    $filledSlots = ""
}
if ($ramModules -gt 0) {
    $moduleCapacity = $totalCapacity / 1GB / $ramModules

} else {
    $moduleCapacity = ""
}
$ramOutput = "RAM: $($totalCapacity / 1GB)GB"
if ($moduleCapacity -and $filledSlots) {
    $ramOutput += " ($ramModules module(s) of $moduleCapacity filled in slot(s) $filledSlots)"
} elseif ($moduleCapacity) {
    $ramOutput += " ($ramModules x $moduleCapacity GB)"
} else {
    $ramOutput += " ($ramModules module(s))"
}
Write-Host $ramOutput

# Get disk information
$diskInfo = Get-CimInstance -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object DeviceID, Size, FreeSpace

Write-Host ""
Write-Host "Disk Information:"
Write-Host "------------------"
foreach ($disk in $diskInfo) {
    Write-Host "  $($disk.DeviceID)"
    Write-Host "    Size: $(ConvertTo-HumanReadable -size $disk.Size)"
    Write-Host "    Free Space: $(ConvertTo-HumanReadable -size $disk.FreeSpace)"
}
Write-Host ""
# Parse battery report for Design Capacity
if ($reportPath -and (Test-Path $reportPath)) {
    $batteryReportContent = Get-Content $reportPath -Raw
    $designCapacityMatch = [regex]::Match($batteryReportContent, 'DESIGN CAPACITY</span></td><td>([\d,]+) mWh').Groups[1].Value -replace ',', ''
    $fullChargeCapacity = [regex]::Match($batteryReportContent, 'FULL CHARGE CAPACITY</span></td><td>([\d,]+) mWh').Groups[1].Value -replace ',', ''

    if ($designCapacityMatch -gt 0) {
        $designCapacity = $designCapacityMatch
        Write-Host "Battery Information"
        Write-Host "------------------"
        Write-Host "Full Charge Capacity: $fullChargeCapacity mWh"
        Write-Host "Design Capacity: $designCapacity mWh"
        $chargeFraction = [math]::Round(($fullChargeCapacity / $designCapacity), 2)
        $chargeFracPercent = ($chargeFraction * 100)
        Write-Host "Batery Health: $chargeFracPercent%"

        # Open battery report in default browser
    } else {
        Write-Host "Battery Information: Not available"
    }
} else {
    Write-Host "Battery Information: Not available"
}

# Add newlines
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
# Prompt the user to press Enter before closing the window
Read-Host "Press Enter to exit"
