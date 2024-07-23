# Despliegue 🚀

Pasos para desplegar con AWS CLI

## 1. Configurar aws cli

Crear un usuario en IAM, para este ejercicio se crea con la política *AdministratorAccess*.

Configurar usuario

```sh
aws configure
```

**AWS Access Key ID**: Clave de acceso de AWS.
**AWS Secret Access Key**: Clave secreta de acceso de AWS.
**Default region name**: La región predeterminada donde deseas que AWS CLI realice
operaciones (por ejemplo, us-east-2).
**Default output format**: El formato de salida predeterminado que prefieres al usar AWS CLI
(por ejemplo, json).

```sh
aws sts get-caller-identity
```
Deberías recibir una respuesta que incluya tu ID de cuenta de AWS y el ARN (Amazon
Resource Name).

## 2. Almacenar las variables de entorno en AWS Systems Manager Parameter Store

```sh
aws ssm put-parameter --name "VERSION" --value "your_version_value" --type "String" --region us-east-2
aws ssm put-parameter --name "GMAIL_FROM_EMAIL" --value "your_gmail_from_email" --type "String" --region us-east-2
aws ssm put-parameter --name "GMAIL_EMAIL_PASSWORD" --value "your_gmail_email_password" --type "SecureString" --region us-east-2
aws ssm put-parameter --name "GMAIL_SMTP_SERVER" --value "your_gmail_smtp_server" --type "String" --region us-east-2
aws ssm put-parameter --name "GMAIL_SMTP_PORT" --value "your_gmail_smtp_port" --type "String" --region us-east-2
aws ssm put-parameter --name "TWILIO_ACCOUNT_SID" --value "your_twilio_account_sid" --type "String" --region us-east-2
aws ssm put-parameter --name "TWILIO_AUTH_TOKEN" --value "your_twilio_auth_token" --type "SecureString" --region us-east-2
aws ssm put-parameter --name "TWILIO_PHONE" --value "your_twilio_phone" --type "String" --region us-east-2
aws ssm put-parameter --name "access_key_id" --value "your_aws_access_key_id" --type "String" --region us-east-2
aws ssm put-parameter --name "secret_access_key" --value "your_aws_secret_access_key" --type "SecureString" --region us-east-2
aws ssm put-parameter --name "region_name" --value "your_region_name" --type "String" --region us-east-2
```

## 3. Crear bucket

```sh
aws s3 mb s3:// fund-manager-front --region us-east-2
```

Configuración de Políticas de Bucket:

```sh
aws s3api put-bucket-policy --bucket fund-manager-front --policy '{
 "Version": "2012-10-17",
 "Statement": [
 {
 "Sid": "PublicReadGetObject",
 "Effect": "Allow",
 "Principal": "*",
 "Action": "s3:GetObject",
 "Resource": "arn:aws:s3::: fund-manager-front /*"
 }
 ]
}'
```

## 4. Subir front al bucket

```sh
aws s3 sync ./build s3://fund-manager-front --acl public-read --region us-east-2
```

## 5. Crear Pares de Llaves en EC2

Se crea la llave con nombre “fund-manager” para poder desplegar en EC2 desde Cloudformation


## 6. Crear Stack

Validar stack (opcional)

```sh
aws cloudformation validate-template --template-body file://template.yaml
```

Crear stack
```sh
aws cloudformation create-stack --template-body file://template.yaml --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --region us-east-2 --parameters ParameterKey=CreateDynamoDBTables,ParameterValue=false --stack-name fundmanager-stack

```