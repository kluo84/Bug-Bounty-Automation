#!/usr/bin/env python3

"""
This script will capture the hostname in a file -> convert it to IP address -> then compare with the in-scope IP address
Finally, generate the in-scope domains list
"""

import socket
import sys
import argparse
import subprocess
import colorama
from colorama import Fore, Style
import requests
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

#Get subdomain from tool like subfinder, assetfinder, and amass
def get_subdomain(domain):
    subdomains = []
    print(f"{Fore.GREEN}[+] Getting subfinder result...{Style.RESET_ALL}")
    subfinder_response = subprocess.check_output(f'subfinder -d {domain} -silent', shell=True)
    for sub in subfinder_response.splitlines():
        print(sub.decode())
        subdomains.append(sub.decode())
    print(f"{Fore.GREEN}[+] Getting assetfinder result...{Style.RESET_ALL}")
    assetfinder_response = subprocess.check_output(f'assetfinder -subs-only {domain}', shell=True)
    for sub in assetfinder_response.splitlines():
        print(sub.decode())
        subdomains.append(sub.decode())
    print(f"{Fore.GREEN}[+] Getting amass result...{Style.RESET_ALL}")
    amass_reponse = subprocess.check_output(f'amass enum -passive -d {domain}', shell=True)
    for sub in amass_reponse.splitlines():
        print(sub.decode())
        subdomains.append(sub.decode())
    #runSublist3r module
    #subdomains = sublist3r.main(f'{domain}', 40, ports= None, silent=False, verbose= False, enable_bruteforce= False, engines=None)
    return sorted(set(subdomains))

def check_valid_in_scope(subdomain, ip):
    try:
        subdomain_ip = socket.gethostbyname(subdomain)
        if subdomain_ip == ip:
            return True
    except:
        pass
def check_live_subdomain(subdomain):
    try:
        https_check = requests.get("https://" + subdomain, verify=False)
        if(https_check.status_code == 200):
            return subdomain
        else:
            pass
        #http_check = requests.get("http://" + subdomain)
        #if(http_check.status_code == 200):
        #    return subdomain
        #else:
        #    pass
    except:
        pass

def get_urls(subdomain):
    urls = []
    
    print(f"{Fore.GREEN}[+] Getting urls from gau...{Style.RESET_ALL}")
    gau_urls = subprocess.check_output(f'echo {subdomain} | gau --blacklist png,jpg,gif,jpeg,swf,woff,svg,pdf,tiff,tif,bmp,webp,ico,mp4,mov,js,css,eps,raw | uro', shell=True)
    for url in gau_urls.splitlines():
        print(url.decode())
        urls.append(url.decode())

    print(f"{Fore.GREEN}[+] Getting urls from katana...{Style.RESET_ALL}")
    katana_urls = subprocess.check_output(f'katana -u https://{subdomain} -d 4 -ef png,jpg,gif,jpeg,swf,woff,svg,pdf,tiff,tif,bmp,webp,ico,mp4,mov,css,eps,raw -jc --proxy http://127.0.0.1:8080 | uro', shell=True)
    for url in katana_urls.splitlines():
        print(url.decode())
        urls.append(url.decode())

    with open("all_urls_gau_katana.txt", 'w') as f:
        for url in sorted(set(urls)):
            f.write(url+"\n")

    return sorted(set(urls))

def main():
    if len(sys.argv) <= 1:
        print('usage: bb_automate.py [-h] [-d domain]')
    
    parser = argparse.ArgumentParser()
    parser.add_argument("--domain", "-d", nargs="?", help="Enter your Domain Name")
    parser.add_argument("-i", dest="in_scope_ip_file", required=True, nargs="?", default="-", metavar="inscope_ip_file.txt", type=argparse.FileType("r"), help="path to the inscope_ip_file.txt")
    args = parser.parse_args()

    subdomains = get_subdomain(args.domain)
    print(f"{Fore.GREEN}[+] Found {len(subdomains)} subdomains {Style.RESET_ALL}")

    #check in scope for subdomain
    in_scope_subdomains = []
    for ip in args.in_scope_ip_file.read().split("\n"):
       for subdomain in subdomains:
           if check_valid_in_scope(subdomain,ip):
               in_scope_subdomains.append(subdomain)
    print(f"{Fore.GREEN}[+] Found {len(in_scope_subdomains)} in-scope subdomains{Style.RESET_ALL}")


    #check live subdomains that in scope
    in_scope_live_subdomains = []
    for sub in in_scope_subdomains:
       if check_live_subdomain(sub) != None:
           in_scope_live_subdomains.append(check_live_subdomain(sub))
    
    print(f"{Fore.GREEN}[+] Found {len(in_scope_live_subdomains)} live in-scope subdomains{Style.RESET_ALL}")

    #write in-scope live subdomains to a file
    with open("in_scope_live_subdomains.txt", 'w') as f:
        for subdomain in in_scope_live_subdomains:
            f.write(subdomain+"\n")
    print(f"{Fore.GREEN}[+] Check in_scope_live_subdomains.txt for live in-scope subdomains{Style.RESET_ALL}")

    # Get gau and katana data:
    #for subdomain in in_scope_live_subdomains:
    #    get_urls(subdomain)
    #print(f"{Fore.GREEN}[+] Check file all_urls_gau_katana.txt for all gathered URLs{Style.RESET_ALL}")

if __name__ == "__main__":
    main()
