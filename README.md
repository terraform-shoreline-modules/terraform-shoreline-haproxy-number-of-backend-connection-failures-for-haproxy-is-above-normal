
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# HAProxy number of backend connection failures for host is above normal.
---

This incident type occurs when the number of failed backend connections for a particular host in HAProxy is above normal. This could indicate issues with the backend server or other errors, such as a backend without an active frontend. Correlating this metric with other metrics like `haproxy.backend.errors.resp_rate` and response codes from both frontend and backend servers can give a better understanding of the causes of the increase in backend connection errors.

### Parameters
```shell
# Environment Variables

export CONFIG_FILE="PLACEHOLDER"

export HAPROXY_LOG_FILE="PLACEHOLDER"

export BACKEND_SERVER_PORT="PLACEHOLDER"

export BACKEND_SERVER_IP="PLACEHOLDER"

export BACKEND_SERVER_NAME="PLACEHOLDER"

export FRONTEND_SERVER_NAME="PLACEHOLDER"

export BACKEND_SERVER_URL="PLACEHOLDER"

export BACKEND_SERVICE_NAME="PLACEHOLDER"
```

## Debug

### Check HAProxy's overall status
```shell
systemctl status haproxy
```

### Check the haproxy configuration file
```shell
haproxy -c -f ${CONFIG_FILE}
```

### Check haproxy's log files
```shell
tail -f ${HAPROXY_LOG_FILE}
```

### Check the number of backend connections
```shell
echo "show stat" | socat stdio /var/run/haproxy.sock | awk -F',' '{print $1,$2,$5,$18}' | column -t
```

### Check the backend servers' status
```shell
echo "show backend" | socat stdio /var/run/haproxy.sock
```

### Check for general backend errors
```shell
grep -i "backend errors" ${HAPROXY_LOG_FILE}
```

### Check the frontend and backend servers' response codes
```shell
grep -i "HTTP/1.1" ${HAPROXY_LOG_FILE} | awk '{print $9}'
```

### The backend server is experiencing some issues or downtime, causing connection failures.
```shell


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


```

## Repair

### Verify that the backend server is running and responding correctly to requests.
```shell


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


```