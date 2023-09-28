
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# SSL certificate probe failure
---

This incident type refers to a situation where the SSL certificate probe failed for a particular instance, which means that the SSL certificate for that instance could not be verified or was found to be invalid. This could be a potential security risk and needs to be investigated and resolved promptly.

### Parameters
```shell
export INSTANCE="PLACEHOLDER"

export SERVICE_OR_APPLICATION_NAME="PLACEHOLDER"

export OLD_CERTIFICATE_FILE="PLACEHOLDER"

export PATH_TO_NEW_SSL_CERTIFICATE_PRIVATE_KEY_FILE="PLACEHOLDER"

export INSTANCE_NAME_OR_IP_ADDRESS="PLACEHOLDER"

export PATH_TO_NEW_SSL_CERTIFICATE_FILE="PLACEHOLDER"

export OLD_CERTIFICATE_KEY_FILE="PLACEHOLDER"
```

## Debug

### Check the SSL certificate for the instance
```shell
openssl s_client -connect ${INSTANCE}:443
```

### Check the SSL certificate expiry date
```shell
openssl s_client -servername ${INSTANCE} -connect ${INSTANCE}:443 2>/dev/null | openssl x509 -noout -enddate
```

### Check the SSL certificate chain
```shell
openssl s_client -connect ${INSTANCE}:443 -showcerts
```

### Check the domain name matches the SSL certificate
```shell
openssl s_client -connect ${INSTANCE}:443 | openssl x509 -noout -text | grep DNS
```

### Check the issuer of the SSL certificate
```shell
openssl s_client -connect ${INSTANCE}:443 | openssl x509 -noout -text | grep Issuer
```

### Check the SSL certificate revocation status
```shell
openssl s_client -connect ${INSTANCE}:443 | openssl x509 -noout -text | grep -A 2 "Revocation"
```

### Check the SSL certificate using SSLyze
```shell
sslyze --regular ${INSTANCE}:443
```

## Repair

### Update the SSL certificate for the affected instance and re-run the certificate probe to ensure that it is being recognized correctly.
```shell


#!/bin/bash



# Set variables

INSTANCE=${INSTANCE_NAME_OR_IP_ADDRESS}

CERT_FILE=${PATH_TO_NEW_SSL_CERTIFICATE_FILE}

CERT_KEY=${PATH_TO_NEW_SSL_CERTIFICATE_PRIVATE_KEY_FILE}



# Stop the service or application using the SSL certificate

sudo systemctl stop ${SERVICE_OR_APPLICATION_NAME}



# Backup the old SSL certificate and private key

sudo cp /etc/ssl/certs/${OLD_CERTIFICATE_FILE} /etc/ssl/certs/${OLD_CERTIFICATE_FILE}.bak

sudo cp /etc/ssl/private/${OLD_CERTIFICATE_KEY_FILE} /etc/ssl/private/${OLD_CERTIFICATE_KEY_FILE}.bak



# Copy the new SSL certificate and private key to the correct directories

sudo cp $CERT_FILE /etc/ssl/certs/

sudo cp $CERT_KEY /etc/ssl/private/



# Set the correct permissions on the new SSL certificate and private key

sudo chmod 644 /etc/ssl/certs/$CERT_FILE

sudo chmod 600 /etc/ssl/private/$CERT_KEY



# Restart the service or application using the SSL certificate

sudo systemctl start ${SERVICE_OR_APPLICATION_NAME}


```