#!/usr/bin/env python

import os
import stat
import requests
import subprocess
import boto3

import pprint

def log(msg, level='info'):
    if level == 'info':
        header = "[+]"
    elif level == 'warning':
        header = "[-]"
    elif level == 'error':
        header = "[*]"

    print header + " " + msg

def get_letsencrypt():

    url = 'https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated'

    r = requests.get(url)

    filename = os.path.basename(url)

    if r.status_code != 200:
        log("Non-200 HTTP code!!", level='error')
        exit()

    with open(filename, 'wb') as f:
        f.write(r.text)

    st = os.stat(filename)
    os.chmod(filename, st.st_mode | stat.S_IEXEC)

    log("%s file is in place and executable" % filename)

    return filename

def load_config():

    myvars = {}
    with open("config") as myfile:
        for line in myfile:

            line = line.strip()

            if len(line.strip()) == 0:
                continue

            if line.strip()[0] == "#":
                continue

            name, var = line.partition("=")[::2]

            if var.startswith('"') and var.endswith('"'):
                var = var[1:-1]
            if var.startswith('\'') and var.endswith('\''):
                var = var[1:-1]

            myvars[name.strip()] = var.strip()

    log("Found config")

    return myvars

def load_domains():

    domains = {}

    with open("domains.txt") as d_file:
        for line in d_file:
            all_ds = line.split()
            domains[all_ds[0]] = all_ds

    log("Found domains")
    return domains

def clear_certs_dir(domains):

    for domain, subs in domains.iteritems():

        folder = os.path.join('certs', domain)

        if not os.path.isdir(folder):
            log("Path %s doesn't exist!!" % folder, level="error")
            exit()

        for the_file in os.listdir(folder):
            file_path = os.path.join(folder, the_file)
            try:
                if os.path.isfile(file_path) or os.path.islink(file_path):
                    os.unlink(file_path)
                log("Removing %s..." % file_path)
            except Exception as e:
                log(e, level="error")

        log("%s cleared" % folder)

def run_letsencrypt(cmd):
    proc = subprocess.Popen(cmd, shell=True)
    proc.communicate()

if __name__ == "__main__":
    config = load_config()
    domains = load_domains()
    clear_certs_dir(domains)
    filename = get_letsencrypt()
    run_letsencrypt("./%s --register --accept-terms" % filename)
    run_letsencrypt("./%s --cron" % filename)


