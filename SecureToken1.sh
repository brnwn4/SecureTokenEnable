#!/bin/sh
# This script is intended to be used with JAMF Self Service. It will enable SecureToken for the currently logged in user account
# and either add it to the list of to FileVault enabled users or enable FileVault using a Personal Recovery Key.

# Your policy must include script parameters for a SecureToken enabled administrator username and password. For more information
# on using script parameters, please see https://www.jamf.com/jamf-nation/articles/146/script-parameters.

adminUser="$4"
adminPassword="$5"
userName1="$3"

# Uses AppleScript to prompt the currently logged in user for their account password.
userPassword1=$(/usr/bin/osascript <<EOT
tell application "System Events"
activate
display dialog "Please enter your login password for $userName1 :" default answer "" buttons {"Continue"} default button 1 with hidden answer
if button returned of result is "Continue" then
set pwd to text returned of result
return pwd
end if
end tell
EOT ) 
 
# Enables SecureToken for the currently logged in user account.

enableSecureToken() {
    sudo sysadminctl -adminUser $adminUser -adminPassword $adminPassword -secureTokenOn $userName1 -password $userPassword1
}
enableSecureToken