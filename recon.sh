#!/bin/bash

domain=$1

if [ -z "$domain" ]; then
    echo "Usage: ./recon.sh example.com"
    exit 1
fi

echo "[+] Starting Recon on $domain"

mkdir -p output/$domain

echo "[+] Finding subdomains..."
subfinder -d $domain -silent > output/$domain/subs.txt

echo "[+] Checking live hosts..."
cat output/$domain/subs.txt | httpx -silent > output/$domain/live.txt

echo "[+] Scanning ports..."
nmap -iL output/$domain/live.txt -T4 -oN output/$domain/nmap.txt

echo "[+] Collecting URLs..."
cat output/$domain/live.txt | waybackurls > output/$domain/urls.txt

echo "[+] Running nuclei scan..."
nuclei -l output/$domain/live.txt -o output/$domain/nuclei.txt

echo "[+] Recon Completed! Results saved in output/$domain"
