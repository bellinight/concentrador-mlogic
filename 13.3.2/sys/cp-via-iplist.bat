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
# Altere D:\ para qualquer letra da unidade em que você colocará seu arquivo CSV
$csv = Import-Csv 'C:\Mercadologic\sys\iplist.csv'
$currentDate = get-date -format yyyyMMdd
$currentRDate = get-date -format yyyy/MM/dd
$currentTime = get-date -format hh:mm:sstt
$outputName = "Logfile-" + $currentDate + ".txt"
#############################
# Mude o caminho da unidade; Certifique-se de alterar se você não quiser nesse caminho.
$outputPath = "C:\Mercadologic"
#############################

#############################
# Diretório que deseja copiar (você pode usar caminhos UNC ou caminhos de diretório reais)
# For source, it can be a UNC path (\\server\appfolder) or normal path (C:\appfolder or D:\testdir) etc.
# For copyTo it has to be a UNC related path (ie: d$\folder or C$\folder)
$source = "c:\Mercadologic$\temp\*.*"
$copyTo = "C:\Mercadologic$\"

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

