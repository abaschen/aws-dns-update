#!/bin/bash

#OLD_IP="$(dig +short "$DNS_FQDN")"
OLD_IP=$(aws route53 list-resource-record-sets --hosted-zone-id $AWS_ZONE_ID | jq -r ".[] | map(select(.Type == \"A\" and .Name == \"$DNS_FQDN.\" )) | map(select(any(.ResourceRecords[]; .Value))) | .[] | .ResourceRecords[0].Value")
NEW_IP="$(curl -sS --max-time 5 https://api.ipify.org)"
function validate_ip {
        [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

if ! validate_ip "$OLD_IP" ; then
  echo "Invalid OLD_IP: $OLD_IP"
  exit;
fi

if ! validate_ip "$NEW_IP" ; then
  echo "Invalid NEW_IP: $NEW_IP"
  exit
fi

if [ "$OLD_IP" == "$NEW_IP" ]; then
  echo "No IP change detected: $OLD_IP"
  exit
fi

DNS_TTL=432000
# http://stackoverflow.com/questions/1167746/how-to-assign-a-heredoc-value-to-a-variable-in-bash
read -r -d '' JSON_CMD << EOF
        {
                "Comment": "DynDNS update",
                "Changes": [
                        {
                                "Action": "UPSERT",
                                "ResourceRecordSet": {
                                        "Name": "$DNS_FQDN.",
                                        "Type": "A",
                                        "TTL": $DNS_TTL,
                                        "ResourceRecords": [
                                                {
                                                        "Value": "$NEW_IP"
                                                }
                                        ]
                                }
                        }
                ]
        }
EOF

echo "Updating IP to: $NEW_IP ($DNS_FQDN); OLD=$OLD_IP"

aws route53 change-resource-record-sets --hosted-zone-id "$AWS_ZONE_ID" --change-batch "$JSON_CMD"

echo "Done. Request sent to update IP to: $NEW_IP ($DNS_FQDN)"
