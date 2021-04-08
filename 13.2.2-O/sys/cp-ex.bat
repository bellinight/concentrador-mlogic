#############################
# CopyFilesIP.ps1
# Version 1.1
#
# Created by: Infinite Technica
# www.infinitetechnica.com
# Date: 2016/06/10
# 
# Licensed under Creative Commons Zero
# https://creativecommons.org/publicdomain/zero/1.0/
#############################


# Variables
# Change D:\ to any Drive letter you will put your CSV file at
$csv = Import-Csv 'C:\Mercadologic\backup-update\IP.csv'
$currentDate = get-date -format yyyyMMdd
$currentRDate = get-date -format yyyy/MM/dd
$currentTime = get-date -format hh:mm:sstt
$outputName = "Logfile-" + $currentDate + ".txt"
#############################
# Change the Drive Path; Make sure you change D:\ if you don't want it at that path
$outputPath = "C:/$outputName"
#############################

#############################
# Directory you want to copy from (You can use UNC Paths or Actual Directory Paths)
# For source, it can be a UNC path (\\server\appfolder) or normal path (C:\appfolder or D:\testdir) etc.
# For copyTo it has to be a UNC related path (ie: d$\folder or C$\folder)
$source = "\\localhost\D$\TestDir"
$copyTo = "C$\TestDir"

#############################


# Creating Initial Log File
echo "Output log for Copy Files to IP Address Script" > $outputPath
echo "Date Ran: $currentRDate" >> $outputPath
echo "Time Ran: $currentTime" >> $outputPath
echo "================================================" >> $outputPath

# For Loop
foreach ($line in $csv) {
    # Variables
    $Address = $line.IP
   
    # Tests to see if computer is on or accepts pings
    $boolConnect = Test-Connection -ComputerName $Address -BufferSize 16 -Count 1 -Quiet

    echo "Working on $Address"

    if ($boolConnect -eq 'True') {

        # This will become \\ip\path (ex: \\192.168.1.2\c$\dir)
        $destination = "\\$Address\$copyTo"

        echo "-------------------------------" >> $outputPath
        echo "$Address is Online" >> $outputPath
        echo "-------------------------------" >> $outputPath
        # Copying file to computer
        robocopy $source $destination /MIR >> $outputPath


        # (OPTIONAL) Set Permissions for the folder
        icacls ($destination) /inheritance:d  >> $outputPath
        #icacls ($destination) /remove:g "Group1" /T >> $outputPath
        #icacls ($destination) /remove:g "Group2" /T >> $outputPath

    }
    else {
        echo "$Address is Offline" >> $outputPath
    }
    
    echo "-------------------------------" >> $outputPath
}

