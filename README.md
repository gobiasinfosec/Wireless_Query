# Wireless_Query
Query Active Directory for Workstations and then Pull their Wireless Network Passwords

This tool is designed to pull a list of machines from AD and then use psexec to pull their wireless network passwords. This should be run with either a DOMAIN or WORKSTATION Admin account.

After it runs, the full output can be found at your $Output variable location.

### Instructions

Edit the variables on lines 7-9 of the script per your needs. 

This can be used as a blue team tool to ensure that your users are not connecting to networks that use weak passwords (or slightly modified to pull the wireless network type as well).

It can also be used as a red team tool to harvest potential passwords that are being used on the network or wireless hotspots that may not use RADIUS. But this is going to be super loud -> probably better to pick targets and just run the commands ad hoc.

### Notes/Dependencies:
-Written for Powershell 4.0, may work with other versions

-Requires PSExec

### Disclaimer:
-This tool has been provided for testing and academic purposes only. Do not use this tool on accounts that you do not own or have express/strict written consent to test against. Do not use for illegal purposes!

