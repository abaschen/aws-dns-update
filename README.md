<p align="center">
<img src="https://img.shields.io/docker/cloud/automated/techunter/aws-dns-update.svg" alt="Check out on docker"/>
<img src="https://img.shields.io/docker/cloud/build/techunter/aws-dns-update.svg" alt="Check out on docker"/>
<img src="https://img.shields.io/docker/pulls/techunter/aws-dns-update.svg" alt="Check out on docker"/>
 </p>
 
# aws-dns-update 

A simple container for updating your DNS domain with IP

### Usage

You need :
 - an AWS user with proper authorizations (strategies)
 - a DNS A entry in a zone you can write in. My zone here is `domain.com` my A entry is sub.domain.com bound to IP `1.2.3.4` (whatever). This script doesn't create the A entry, it only modifies it.
 - Docker installed :) Optionally docker-compose
 
 you can find the AWS_ZONE_ID I'm talking about here: https://console.aws.amazon.com/route53/home#hosted-zones:
 Click on the line of your zone NOT the url. On the right panel you should see the ID
 
#### Minimal AWS Role

Create a dedicated user for this: 
 - go to IAM console then create an user with API access, click next
 - create a new strategy (or use one you created with at least these below)
   * select service `route53`
   * Read access: `ListResourceRecordSets`
   * Write access: `ChangeResourceRecordSets`
   * Specify resource `hostedzone` restriction. copy paste the AWS_ZONE_ID. 
   * Check then give a name and create the strategy
 - back to the user creation, select the tab to attach existing strategies refresh the list of strategies then type or scroll to the name you just created then tick the checkbox
 - Next until creation confirm.
 

#### Variables

To update the DNS `sub.domain.com` I need an identity in AWS with the correct role. at the end of user creation you get an ID and the KEY: 
I would recommend setting your environment variables in a file, I use `.env` and put these in:

```
AWS_ID=AWSUSERID23487
AWS_KEY=AWSKEY80247523485je39A/+3

#you can get this one in Route53
AWS_ZONE_ID=ZONEIDINROUTE53
#
DNS_FQDN=sub.domain.com
DNS_TTL=432000
```

##### With Docker

```bash
docker run -d --env-file .env techunter/aws-dns-update:latest
```

#### With docker-compose

```bash
docker-compose up -d

```

## Building the image

Comment the image line and uncomment the build line. 

#### Thanks

I took some parts from  https://github.com/famzah/aws-dyndns so thank you :)
