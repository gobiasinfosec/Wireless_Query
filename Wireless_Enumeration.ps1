# Retrieve Machine List from AD and then run psexec to gather SSID names and passwords accross a domain
# Requires Local Admin rights on the machine (Workstation/Domain Admin rights)

Import-Module ActiveDirectory

# Set filepaths and options for variables
$ou = "*"                                                              # "*" to pull information from all OU's
$psexec = "C:\PSTools\PsExec.exe"                                      # path to psexec.exe executable
$output = "C:\temp\wireless_networks.csv"                              # path to output file (will be in csv format)

# Create a new empty array for results
$results = @()

# Do the lookup and create the output file
echo "AD-Lookup running, do not close window"
$workstations = Get-ADComputer -filter {Enabled -eq $true} | Where-Object{$_.DistinguishedName -like $ou } | Select-Object Name

# Iterate through each workstation to get SSID names
foreach ($workstation in $workstations) {

    # Reset array to null (in case machine is not available on the network)
    $network_ids = @()
    
    echo "Running lookup on $workstation"
    $network_ids = & $psexec \\$workstation netsh.exe wlan show all | findstr c:/"SSID name" | %{$_.split('"')[1]} | ? {$_} | sort -uniq

    # Iterate through each SSID name and pull the password
    foreach ($network_id in $network_ids) {
        echo "Running lookup on $network_id"
        $details = & $psexec \\$workstation netsh.exe wlan show profile name="$network_id" key=clear 
        $password = $details | findstr /c:"Key Content" | %{$_.split('::')[1]}
        $auth = $details | findstr /c:"Authentication" | %{$_.split('::')[1]}
        
        # Write all data to the results array
        $results += New-Object PsObject -Property @{
            Workstation = $workstation
            Password = $password
            Network = $network_id
            Authentication = $auth
        }
    }
}

# Write the results array to a csv file
$results | convertto-csv -NoTypeInformation -Delimiter "," | % { $_ -replace '"', ""} | out-file $output -Encoding ascii
