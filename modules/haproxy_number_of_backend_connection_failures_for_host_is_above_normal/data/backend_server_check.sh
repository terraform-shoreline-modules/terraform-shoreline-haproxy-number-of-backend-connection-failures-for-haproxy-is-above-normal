

#!/bin/bash



# Define variables

BACKEND_SERVER=${BACKEND_SERVER_IP}

BACKEND_PORT=${BACKEND_SERVER_PORT}




# Check if backend server is reachable

if ping -c 1 -W 30 $BACKEND_SERVER &>/dev/null; then

  echo "Backend server is reachable."

else

  echo "Backend server is unreachable. Check network connectivity."

  exit 1

fi



# Check if backend server is up and listening on specified port

if nc -z -w $PING_TIMEOUT $BACKEND_SERVER $BACKEND_PORT; then

  echo "Backend server is up and listening on port $BACKEND_PORT."

else

  echo "Backend server is down or not listening on port $BACKEND_PORT."

  exit 1

fi



# Check if backend server is experiencing any issues or downtime

if curl -sSf $BACKEND_SERVER:$BACKEND_PORT &>/dev/null; then

  echo "Backend server is responding to HTTP requests."

else

  echo "Backend server is not responding to HTTP requests. Check server logs for errors."

fi