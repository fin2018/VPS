#!/bin/bash
echo "---------------------------- MEMBUAT AKUN  PPTP VPN ----------------------------"
echo ""

read -p "Isikan username baru: " USER
read -p "Isikan password akun [$USER]: " PASS

echo "$USER pptpd $PASS *" >> /etc/ppp/chap-secrets

echo ""
echo "-----------------------------------"
echo "Informasi Detail Akun PPTP VPN Anda:"
echo "-----------------------------------"
echo "Host/IP: $MYIP"
echo "Username: $USER"
echo "Password: $PASS"
echo "-----------------------------------"
