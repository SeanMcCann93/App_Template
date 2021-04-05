#!/bin/bash

echo " "
echo "       EXECUTING..."
echo "      ::::::::::::::::::::::::::::::::::::::: :::    ::: :::::::: :::    :::"
echo "    :+:    :+:   :+:        :+:    :+:    :+::+:    :+::+:    :+::+:    :+:"
echo "   +:+          +:+        +:+    +:+    +:++:+    +:++:+       +:+    +:+"
echo "  :#:          +#+        +#+    +#++:++#+ +#+    +:++#++:++#+++#++:++#++"
echo " +#+   +#+#   +#+        +#+    +#+       +#+    +#+       +#++#+    +#+"
echo "#+#    #+#   #+#        #+#    #+#       #+#    #+##+#    #+##+#    #+#"
echo "###################    ###    ###        ########  ######## ###    ###"
echo " "
echo "Launched from '$(pwd)'"
echo " "
echo "EXECUTING: Add *"
git add . # All files within currect directory is to be set for Upload to Git-Hub
echo " "
echo "----------------------------------------------------------------------------"
echo "EXECUTING: Status"
echo "----------------------------------------------------------------------------"
echo " "
git status # Display to the current user the status of the files being uploaded
echo "----------------------------------------------------------------------------"
echo " "
echo "EXECUTING: Commit..."
echo " "
read -p "Please Enter Message: " commiting # Request the user to imput a message that will be seen on Git-Hub as a commit message
echo " "
echo "****************************************************************************"
git commit -m "'${commiting}' ~ $(date +"%D @ %T")" # Sent commit message and Date+Time Stamp
echo "****************************************************************************"
echo " "
echo "----------------------------------------------------------------------------"
echo "EXECUTING: Status"
echo "----------------------------------------------------------------------------"
echo " "
git status # Show the status of the files again for the user to see its progress changed
echo "----------------------------------------------------------------------------"
echo " "
echo "EXECUTING: Push..."
echo " "
echo ">-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->"
echo " "
git push # Push the commit to Git-Hub Repository
echo " "
echo ">-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->"
echo " "
echo 'GitPUSH {successful}'
echo " "