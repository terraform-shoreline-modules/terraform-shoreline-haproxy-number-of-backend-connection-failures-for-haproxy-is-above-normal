

#!/bin/bash


# Check if backend server is running

if systemctl status ${BACKEND_SERVICE_NAME} | grep -q "Active: active (running)"

then

    echo "Backend server is running."

else

    # Restart the backend server

    echo "Backend server is not running. Restarting..."

    systemctl restart ${BACKEND_SERVICE_NAME}

    echo "Backend server has been restarted."

fi



# Check if backend server is responding correctly

if curl -IsS ${BACKEND_SERVER_URL} | head -1 | grep "200 OK"

then

    echo "Backend server is responding correctly."

else

    # Restart the backend server

    echo "Backend server is not responding correctly. Restarting..."

    systemctl restart ${BACKEND_SERVICE_NAME}

    echo "Backend server has been restarted."

fi