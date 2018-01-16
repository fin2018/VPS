#!/bin/bash

while :
do
	#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
	#if [ "$MYIP" = "" ]; then
		#MYIP=$(wget -qO- ipv4.icanhazip.com)
	#fi

	clear

	echo "--------------- Selamat Datang Di Server Finest Media - IP: $MYIP ---------------"
    echo "Script Created By Pa'an Finest"
    echo "Support By : Finest Media - Phreakers Jateng Official"
    echo ""
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')

	echo "CPU model : $cname"
	echo "Number of cores : $cores"
	echo "CPU frequency : $freq MHz"
	echo "Total amount of ram : $tram MB"
	echo "Total amount of swap : $swap MB"
	echo "System uptime : $up"
	echo "------------------------------------------------------------------------------"
	echo "Apa yang ingin Anda lakukan?"
	echo " 1) Buat Akun SSH/OpenVPN (user-add)"
	echo " 2) Generate Akun SSH/OpenVPN (user-gen)"
	echo " 3) Ganti Password Akun SSH/OpenVPN (user-pass)"
	echo " 4) Tambah Masa Aktif Akun SSH/OpenVPN (user-renew)"
	echo " 5) Hapus Akun SSH/OpenVPN (user-del)"
	echo " 6) Buat Akun PPTP VPN (user-add-pptp)"
	echo " 7) Monitoring Dropbear (dropmon [PORT])"
	echo " 8) Cek Login Dropbear, OpenSSH, PPTP VPN dan OpenVPN (user-login)"
	echo " 9) Kill Multi Login Manual (1-2 Login) (user-limit [x])"
	echo "10) Daftar Akun dan Expire Date (user-list)"
	echo "11) Daftar Akun Aktif (user-active-list)"
	echo "12) Daftar Akun Expire (user-expire-list)"
	echo "13) Disable Akun Expire (user-expire)"
	echo "14) Memory Usage (ps-mem)"
	echo "15) Speedtest (speedtest --share)"
	echo "16) Benchmark (benchmark)"
	echo "17) Reboot Server (reboot)"
	echo ""
	echo " x) Exit"
	echo ""
	read -p "Masukkan pilihan anda, kemudian tekan tombol ENTER: " option1
	case $option1 in
		1)
		clear
		user-add
		exit
		;;
		2)
		clear
		user-gen
		exit
		;;
		3)
		clear
		user-pass
		exit
		;;
		4)
		clear
		user-renew
		exit
		;;
		5)
		clear
		user-del
		exit
		;;
		6)
		clear
		user-add-pptp
		exit
		;;
		7)
		clear
		read -p "Isikan Port Dropbear yang akan dimonitor: " PORT
		dropmon $PORT
		exit
		;;
		8)
		clear
		user-login
		exit
		;;
		9)
		clear
		read -p "Isikan Maximal Login (1-2): " MULTILOGIN
		user-limit $MULTILOGIN
		exit
		;;
		10)
		clear
		user-list
		exit
		;;
		11)
		clear
		user-active-list
		exit
		;;
		12)
		clear
		user-expire-list
		exit
		;;
		13)
		clear
		user-expire
		exit
		;;
		14)
		clear
		ps-mem
		exit
		;;
		15)
		clear
		speedtest --share
		exit
		;;
		16)
		clear
		benchmark
		exit
		;;
		17)
		clear
		reboot
		exit
		;;
		x)
		clear
		exit
		;;
	esac
done
