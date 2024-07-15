#!/bin/bash

# Definir las variables de entorno que necesitas obtener
VARIABLES=("VERSION" "GMAIL_FROM_EMAIL" "GMAIL_EMAIL_PASSWORD" "GMAIL_SMTP_SERVER" "GMAIL_SMTP_PORT" "TWILIO_ACCOUNT_SID" "TWILIO_AUTH_TOKEN" "TWILIO_PHONE" "access_key_id" "secret_access_key" "region_name")

# Archivo de salida .env
ENV_FILE=".env"

# Vaciar el archivo .env existente o crear uno nuevo
> $ENV_FILE

# Obtener cada variable de Parameter Store y agregarla al archivo .env
for VAR in "${VARIABLES[@]}"
do
    VALUE=$(aws ssm get-parameter --name "$VAR" --with-decryption --query "Parameter.Value" --output text)
    echo "$VAR=$VALUE" >> $ENV_FILE
done
