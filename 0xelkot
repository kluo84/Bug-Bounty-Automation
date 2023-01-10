#!/bin/bash 

domain=$1
mkdir /home/AMBERJACK/y39ufxvolu/Documents/$1
mkdir /home/AMBERJACK/y39ufxvolu/Documents/$1/xray

subfinder -d $1 -silent | anew /home/AMBERJACK/y39ufxvolu/Documents/$1/subs.txt
assetfinder -subs-only $1 | anew /home/AMBERJACK/y39ufxvolu/Documents/$1/subs.txt
amass enum -passive -d $1 | anew /home/AMBERJACK/y39ufxvolu/Documents/$1/subs.txt
cat /home/AMBERJACK/y39ufxvolu/Documents/$1/subs.txt | httpx -silent | anew /home/AMBERJACK/y39ufxvolu/Documents/$1/alive.txt              
## Test by Xray 
cd /usr/local/bin
for i in $(cat /home/AMBERJACK/y39ufxvolu/Documents/$1/alive.txt); do xray_linux_amd64 ws --basic-crawler $i --plugins xss,sqldet,xxe,ssrf,cmd-injection,path-traversal --ho $(date +"%T").html ; done 
  

## test for nuclei 

cat /home/AMBERJACK/y39ufxvolu/Documents/$1/alive.txt | nuclei -t /home/AMBERJACK/y39ufxvolu/Documents/cent-nuclei-templates -es info,unknown -etags ssl,network | anew /home/AMBERJACK/y39ufxvolu/Documents/$1/nuclei.txt
