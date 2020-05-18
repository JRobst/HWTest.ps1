function bitCount {
    if ((Get-WmiObject win32_processor).description | select-string "64") {
        echo "CPU is 64Bit"
        cpuName
    } else {
        echo "This is trash"
        break
    }
}

function cpuName {
    (Get-WMIObject win32_Processor).Name | select-string -pattern "i5|i7" | out-null
    $cpu = (Get-WMIObject win32_Processor).Name
    if ($?) {
        echo "CPU is atleast an i5"
        driveTest
    } else {
        echo "CPU is $cpu."
        $cont = read-host -prompt "Continue? y / N"
        if ($cont = "Y|y") {
            ramCount
        } else {
            break
        }
    }
}

function driveTest {
    if (wmic diskdrive get caption | select-string "NVMe|SSD") {
        echo "Drive is good"
        ramCount
    } else {
        echo "Will need new drive"
        ramCount
    }
}

function ramCount {
    $PhysicalRAM = (Get-WMIObject -class Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | % {[Math]::Round(($_.sum / 1GB),2)})
    if ($PhysicalRAM -gt 8) {
        echo "RAM is good"
        break
    } else {
        echo "Will need RAM"
        ramType
    }
}

function ramType {
    $type = (Get-WmiObject Win32_PhysicalMemory | Select-object MemoryType)
    echo $type
    echo "0 is unknown `n24 is DDR3 `n26 is DDR4"
}

bitCount