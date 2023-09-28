

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