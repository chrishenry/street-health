#!/usr/bin/env python

print "HOOK!"

import sys
print  sys.argv[1:]


#!/usr/bin/env python3

# How to use:
#
# LE_HOSTED_ZONE=XXXXXX LE_AWS_PROFILE=dns-access ./letsencrypt.sh --cron --domain example.org --challenge dns-01 --hook /tmp/hook-dns-01-lets-encrypt-route53.py
#
# More info about letsencrypt.sh: https://github.com/lukas2511/letsencrypt.sh/wiki/Examples-for-DNS-01-hooks
# Using AWS Profiles: http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-multiple-profiles
# Obtaining your Hosted Zone ID from Route 53: http://docs.aws.amazon.com/cli/latest/reference/route53/list-hosted-zones-by-name.html

# modules declaration
import os
import sys
import boto3
from time import sleep

session = boto3.Session()
rt53_client = session.client("route53")
iam_client = boto3.client('iam')

def log(msg, level='info'):
    if level == 'info':
        header = "[+]"
    elif level == 'warning':
        header = "[-]"
    elif level == 'error':
        header = "[*]"

    print header + " " + msg

def setup_dns(hosted_zone_id, domain, txt_challenge):
    global rt53_client

    resp = rt53_client.change_resource_record_sets(
        HostedZoneId=hosted_zone_id,
        ChangeBatch={
            'Changes': [{
                'Action': 'UPSERT',
                'ResourceRecordSet': {
                    'Name': '_acme-challenge.{0}'.format(domain),
                    'Type': 'TXT',
                    'TTL': 60,
                    'ResourceRecords': [{
                        'Value': '"{0}"'.format(txt_challenge)
                    }]
                }
            }]
        }
    )

    # TODO: implement smart check and wait code
    # wait 30 seconds for DNS update
    sleep(30)

def delete_dns(hosted_zone_id, domain, txt_challenge):
    global rt53_client

    resp = rt53_client.change_resource_record_sets(
        HostedZoneId=hosted_zone_id,
        ChangeBatch={
            'Changes': [{
                'Action': 'DELETE',
                'ResourceRecordSet': {
                    'Name': '_acme-challenge.{0}'.format(domain),
                    'Type': 'TXT',
                    'TTL': 60,
                    'ResourceRecords': [{
                        'Value': '"{0}"'.format(txt_challenge)
                    }]
                }
            }]
        }
    )

def deploy_cert(domain, hosted_zone_id, cert_parts, timestamp):
    global iam_client

    # As per http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html
    #   AND
    #   http://boto3.readthedocs.io/en/latest/reference/services/iam.html#IAM.Client.upload_server_certificate
    #   The API call requires the contents of the files.
    for key, value in cert_parts.iteritems():
        with open(value, 'r') as f:
            cert_parts[key] = f.read()

    cert_name = domain + "-" + timestamp
    path = '/' + cert_name + '/'

    print "DEPLOY!!!1!"
    print domain

    response = iam_client.upload_server_certificate(
        Path=path,
        ServerCertificateName=cert_name,
        CertificateBody=cert_parts['cert'],
        PrivateKey=cert_parts['private_key'],
        CertificateChain=cert_parts['chain']
    )

    print response

def get_zone_id(domain):
    global rt53_client

    # Get the hosted zone name
    domain = domain.split('.')
    domain = domain[-2] + '.' + domain[-1]

    if domain[-1] != '.':
        domain = domain + '.'

    for zone in rt53_client.list_hosted_zones()['HostedZones']:
        if zone['Name'] == domain:
            return zone['Id'].replace('/hostedzone/', '')

if __name__ == "__main__":
    hook = sys.argv[1]

    if hook == 'exit_hook':
        exit(0)

    domain = sys.argv[2]
    hosted_zone_id = get_zone_id(domain)
    print hosted_zone_id

    print hook

    if hook == "deploy_challenge" or hook == "clean_challenge":
        txt_challenge = sys.argv[4]
        print domain
        print txt_challenge

        if hook == "deploy_challenge":
            setup_dns(hosted_zone_id, domain, txt_challenge)
        elif hook == "clean_challenge":
            delete_dns(hosted_zone_id, domain, txt_challenge)

    elif hook == 'deploy_cert':
        private_key = sys.argv[3]
        cert = sys.argv[4]
        full_chain = sys.argv[5]
        chain = sys.argv[6]
        timestamp = sys.argv[7]

        print private_key
        print cert
        print full_chain
        print chain
        print timestamp

        cert_parts = {
            "private_key": private_key,
            "cert": cert,
            "full_chain": full_chain,
            "chain": chain,
        }

        deploy_cert(domain, hosted_zone_id, cert_parts, timestamp)
