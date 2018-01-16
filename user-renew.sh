#!/bin/bash

echo "-------------------------- TAMBAH MASA AKTIF AKUN SSH --------------------------"
echo "-----------------------------------"
echo "USERNAME              EXP DATE     "
echo "-----------------------------------"

while read expired
do
	AKUN="$(echo $expired | cut -d: -f1)"
	ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
	exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
	if [[ $ID -ge 1000 ]]; then
		printf "%-21s %2s\n" "$AKUN" "$exp"
	fi
done < /etc/passwd
echo "-----------------------------------"
echo ""
# end of user-list

read -p "Isikan username: " USER

egrep "^$USER" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
	#read -p "Isikan password akun [$USER]: " PASS
	read -p "Berapa hari akun [$USER] aktif: " AKTIF
	
	expiredate=$(chage -l $USER | grep "Account expires" | awk -F": " '{print $2}')
	today=$(date -d "$expiredate" +"%Y-%m-%d")
	expire=$(date -d "$today + $AKTIF days" +"%Y-%m-%d")
	chage -E "$expire" $USER
	#useradd -M -N -s /bin/false -e $expire $USER

	echo ""
	echo "-----------------------------------"
	echo "Informasi Detail Akun Renew Anda:"
	echo "-----------------------------------"
	echo "Host/IP: $MYIP"
	echo "Dropbear Port: 443, 110, 109"
	echo "OpenSSH Port: 22, 143"
	echo "Squid Proxy: 80, 8080, 3128"
	echo "OpenVPN Config: http://$MYIP:81/client.ovpn"
	echo "Username: $USER"
	#echo "Password: $PASS"
	echo "Valid s/d: $(date -d "$today + $AKTIF days" +"%d-%m-%Y")"
    echo "Created By Pa'an Finest"
	echo "-----------------------------------"
else
	echo "Username [$USER] belum terdaftar!"
	exit 1
fi
