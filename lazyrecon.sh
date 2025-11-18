#!/bin/bash

# ---------------------------------------------------------
# Script Name: LazyRecon
# Description: Simple OSINT Automation Tool (WHOIS, DNS, HEADERS)
# Author: Developed by a Fedora User
# System: Fedora / Linux
# ---------------------------------------------------------

# Renk Tanımlamaları
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN}"
cat << "EOF"
  _                    _                         
 | |    __ _ _____   _| |____  ___  ___ ___  _ __ 
 | |   / _` |_  / | | |  _ \ / _ \/ __/ _ \| '_ \ 
 | |__| (_| |/ /| |_| | |_) |  __/ (_| (_) | | | |
 |_____\__,_/___|\__, |_|____/ \___|\___\___/|_| |_|
                 |___/                              
EOF
echo -e "${NC}"
echo -e "${BLUE}[*] OSINT Tool for Linux Users${NC}"
echo -e "${BLUE}[*] Target Locked: $1${NC}"
echo "--------------------------------------------------"

# Kullanım Kontrolü
if [ -z "$1" ]; then
    echo -e "${RED}[!] Hata: Lütfen bir domain belirtin.${NC}"
    echo -e "Kullanım: ./lazyrecon.sh example.com"
    exit 1
fi

DOMAIN=$1
DATE=$(date +"%Y-%m-%d_%H-%M")
DIR="reports/${DOMAIN}_${DATE}"

# Rapor klasörü oluştur
mkdir -p $DIR
echo -e "${GREEN}[+] Rapor klasörü oluşturuldu: $DIR ${NC}"

# 1. WHOIS SORGUSU
echo -e "\n${CYAN}[1/4] WHOIS Bilgisi çekiliyor...${NC}"
whois $DOMAIN > $DIR/whois.txt
echo -e "${GREEN}[+] Kaydedildi: $DIR/whois.txt${NC}"
grep -E "Registrar:|Creation Date:|Registry Expiry Date:" $DIR/whois.txt | head -5

# 2. DNS VE IP SORGULARI
echo -e "\n${CYAN}[2/4] DNS Kayıtları taranıyor...${NC}"
echo "--- A Kayıtları (IP Adresleri) ---" > $DIR/dns.txt
host -t A $DOMAIN >> $DIR/dns.txt
echo "--- MX Kayıtları (Mail Sunucuları) ---" >> $DIR/dns.txt
host -t MX $DOMAIN >> $DIR/dns.txt
echo "--- TXT Kayıtları ---" >> $DIR/dns.txt
host -t TXT $DOMAIN >> $DIR/dns.txt
echo -e "${GREEN}[+] Kaydedildi: $DIR/dns.txt${NC}"
cat $DIR/dns.txt | head -4

# 3. HTTP HEADER ANALİZİ
echo -e "\n${CYAN}[3/4] HTTP Header analizi yapılıyor...${NC}"
curl -I -s https://$DOMAIN > $DIR/headers.txt
echo -e "${GREEN}[+] Kaydedildi: $DIR/headers.txt${NC}"
grep -i "Server" $DIR/headers.txt

# 4. ROBOTS.TXT KONTROLÜ
echo -e "\n${CYAN}[4/4] Robots.txt dosyası indiriliyor...${NC}"
curl -s https://$DOMAIN/robots.txt > $DIR/robots.txt
if [ -s "$DIR/robots.txt" ]; then
    echo -e "${GREEN}[+] Robots.txt bulundu ve kaydedildi.${NC}"
    head -n 3 $DIR/robots.txt
else
    echo -e "${RED}[!] Robots.txt bulunamadı veya boş.${NC}"
fi

echo -e "\n--------------------------------------------------"
echo -e "${GREEN}[✓] Tarama Tamamlandı! Tüm veriler $DIR klasöründe.${NC}"
