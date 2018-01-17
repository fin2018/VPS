#!/bin/bash 
# 

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
ether=`ifconfig | cut -c 1-8 | sort | uniq -u | grep venet0 | grep -v venet0:`
if [[ $ether = "" ]]; then
        ether=eth0

# go to root 
cd 

# disable ipv6 
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6 
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local 

# install wget and curl 
apt-get update;apt-get -y install wget curl; 

# set time GMT +7 
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
 
# set locale 
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config 
service ssh restart 

# set repo 
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/ForNesiaFreak/FNS_Debian7/fornesia.com/null/sources.list.debian7" 
wget "http://www.dotdeb.org/dotdeb.gpg" 
wget "http://www.webmin.com/jcameron-key.asc" 
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg 
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc 

# update 
apt-get update 

# install webserver 
apt-get -y install nginx 

# install essential package 
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter 
apt-get -y install build-essential 

# disable exim 
service exim4 stop 
sysv-rc-conf exim4 off 

# update apt-file 
apt-file update 

# install neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | sudo tee -a /etc/apt/sources.list
curl -L "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" -o Release-neofetch.key && sudo apt-key add Release-neofetch.key && rm Release-neofetch.key
apt-get update
apt-get install neofetch

# install screenfetch
cd
wget 'https://raw.githubusercontent.com/ForNesiaFreak/FNS_Debian7/fornesia.com/null/screenfetch-dev'
mv screenfetch-dev /usr/bin/screenfetch-dev
chmod +x /usr/bin/screenfetch-dev
echo "clear" >> .profile
echo "screenfetch-dev" >> .profile

# install webserver 
cd 
rm /etc/nginx/sites-enabled/default 
rm /etc/nginx/sites-available/default 
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/rizal180499/Auto-Installer-VPS/master/conf/nginx.conf" 
mkdir -p /home/vps/public_html 
echo "<pre>Setup By Pa'an Finest</pre>" > /home/vps/public_html/index.html 
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/paanfinest/debian7_32bit/master/vps.conf" 
service nginx restart 

# install openvpn 
wget -O /etc/openvpn/openvpn.tar "https://raw.github.com/arieonline/autoscript/master/conf/openvpn-debian.tar" cd /etc/openvpn/ tar xf openvpn.tar 
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/rizal180499/Auto-Installer-VPS/master/conf/1194.conf" 
service openvpn restart 
sysctl -w net.ipv4.ip_forward=1 
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf 
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE 
iptables-save > /etc/iptables_yg_baru_dibikin.conf 
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/paanfinest/debian7_32bit/master/iptables" 
chmod +x /etc/network/if-up.d/iptables 
service openvpn restart 

#konfigurasi openvpn 
cd /etc/openvpn/ 
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/panfinest/debian7_32bit/master/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn; 
cp client.ovpn /home/vps/public_html/ 

cd 
# install badvpn 
wget -O /usr/bin/badvpn-udpgw "https://github.com/ForNesiaFreak/FNS/raw/master/sett/badvpn-udpgw" 
if [ "$OS" == "x86_64" ]; then 
  wget -O /usr/bin/badvpn-udpgw "https://github.com/ForNesiaFreak/FNS/raw/master/sett/badvpn-udpgw64" 
fi 
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local 
chmod +x /usr/bin/badvpn-udpgw 
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 

# install mrtg
#apt-get update;apt-get -y install snmpd;
wget -O /etc/snmp/snmpd.conf "https://raw.githubusercontent.com/rizal180499/Auto-Installer-VPS/master/conf/snmpd.conf"
wget -O /root/mrtg-mem "https://raw.githubusercontent.com/fin2018/VPS/mrtg-mem.sh"
chmod +x /root/mrtg-mem
cd /etc/snmp/
sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd
service snmpd restart
snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost
curl $source/Debian7/mrtg.conf >> /etc/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
cd

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
#sed -i '/Port 22/a Port 80' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/#Banner/Banner/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear 
apt-get -y install dropbear 
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear 
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear 
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 80"/g' /etc/default/dropbear 
echo "/bin/false" >> /etc/shells 
echo "/usr/sbin/nologin" >> /etc/shells 
service ssh restart 
service dropbear restart 

# install vnstat gui
cd /home/vps/public_html/
wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i 's/eth0/venet0/g' config.php
sed -i "s/\$iface_list = array('venet0', 'sixxs');/\$iface_list = array('venet0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart


# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com' 

cd 
# install squid3 
apt-get -y install squid3 
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/fin2018/VPS/master/squid3.conf" 
sed -i $MYIP2 /etc/squid3/squid.conf; 
service squid3 restart 

# install webmin 
cd 
wget -O webmin-current.deb "http://www.webmin.com/download/deb/webmin-current.deb" 
dpkg -i --force-all webmin-current.deb; 
apt-get -y -f install; 
rm /root/webmin-current.deb 
service webmin restart  

# download script
cd
wget -O /usr/bin/benchmark "https://raw.githubusercontent.com/fin2018/VPS/master/benchmark.sh"
wget -O /usr/bin/speedtest "https://raw.githubusercontent.com/ForNesiaFreak/FNS_Debian7/fornesia.com/null/speedtest_cli.py"
wget -O /usr/bin/dropmon "https://raw.githubusercontent.com/fin2018/VPS/master/dropmon.sh"
wget -O /usr/bin/menu "https://raw.githubusercontent.com/fin2018/VPS/master/menu.sh"
wget -O /usr/bin/user-active-list "https://raw.githubusercontent.com/fin2018/VPS/master/user-active-list.sh"
wget -O /usr/bin/user-add "https://raw.githubusercontent.com/fin2018/VPS/master/user-add.sh"
wget -O /usr/bin/user-add-pptp "https://raw.githubusercontent.com/fin2018/VPS/master/user-add-pptp"
wget -O /usr/bin/user-del "https://raw.githubusercontent.com/fin2018/VPS/master/user-del.sh"
wget -O /usr/bin/user-expire "https://raw.githubusercontent.com/fin2018/VPS/master/user-expire.sh"
wget -O /usr/bin/user-expire-list "https://raw.githubusercontent.com/fin2018/VPS/master/user-expire-list.sh"
wget -O /usr/bin/user-gen "https://raw.githubusercontent.com/fin2018/VPS/master/user-gen.sh"
wget -O /usr/bin/user-limit "https://raw.githubusercontent.com/fin2018/VPS/master/user-limit.sh"
wget -O /usr/bin/user-list "https://raw.githubusercontent.com/fin2018/VPS/master/user-list.sh"
wget -O /usr/bin/user-login "https://raw.githubusercontent.com/fin2018/VPS/master/user-login.sh"
wget -O /usr/bin/user-pass "https://raw.githubusercontent.com/fin2018/VPS/master/user-pass.sh"
wget -O /usr/bin/user-renew "https://raw.githubusercontent.com/fin2018/VPS/master/user-renew.sh"

chmod +x /usr/bin/benchmark
chmod +x /usr/bin/speedtest
chmod +x /usr/bin/dropmon
chmod +x /usr/bin/menu
chmod +x /usr/bin/user-active-list
chmod +x /usr/bin/user-add
chmod +x /usr/bin/user-add-pptp
chmod +x /usr/bin/user-del
chmod +x /usr/bin/user-expire
chmod +x /usr/bin/user-expire-list
chmod +x /usr/bin/user-gen
chmod +x /usr/bin/user-limit
chmod +x /usr/bin/user-list
chmod +x /usr/bin/user-login
chmod +x /usr/bin/user-pass
chmod +x /usr/bin/user-renew

echo "*/30 * * * * root service dropbear restart" > /etc/cron.d/dropbear
echo "00 23 * * * root /usr/bin/user-expire" > /etc/cron.d/user-expire
echo "0 */12 * * * root /sbin/reboot" > /etc/cron.d/reboot
#echo "@reboot root /usr/bin/user-limit" > /etc/cron.d/user-limit
#echo "@reboot root /usr/bin/autokill" > /etc/cron.d/autokill
#sed -i '$ i\screen -AmdS check /root/autokill' /etc/rc.local

# finishing
chown -R www-data:www-data /home/vps/public_html
service cron restart
service nginx start
service php5-fpm start
service vnstat restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart
cd
rm -f /root/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo "Autoscript Include:" | tee log-install.txt
echo "=======================================================" | tee -a log-install.txt
echo "Service :" | tee -a log-install.txt
echo "---------" | tee -a log-install.txt
echo "OpenSSH  : 22, 143" | tee -a log-install.txt
echo "Dropbear : 443, 110, 109" | tee -a log-install.txt
echo "Squid3   : 80, 8000, 8080, 3128 (limit to IP $MYIP)" | tee -a log-install.txt
#echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client.ovpn)" | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300" | tee -a log-install.txt
echo "PPTP VPN : TCP 1723" | tee -a log-install.txt
echo "nginx    : 81" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "Tools :" | tee -a log-install.txt
echo "-------" | tee -a log-install.txt
echo "axel, bmon, htop, iftop, mtr, rkhunter, nethogs: nethogs $ether" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "Script :" | tee -a log-install.txt
echo "--------" | tee -a log-install.txt
echo "screenfetch" | tee -a log-install.txt
echo "menu (Menu Script VPS via Putty) :" | tee -a log-install.txt
echo "  - Buat Akun SSH/OpenVPN (user-add)" | tee -a log-install.txt
echo "  - Generate Akun SSH/OpenVPN (user-gen)" | tee -a log-install.txt
echo "  - Ganti Password Akun SSH/OpenVPN (user-pass)" | tee -a log-install.txt
echo "  - Tambah Masa Aktif Akun SSH/OpenVPN (user-renew)" | tee -a log-install.txt
echo "  - Hapus Akun SSH/OpenVPN (user-del)" | tee -a log-install.txt
echo "  - Buat Akun PPTP VPN (user-add-pptp)" | tee -a log-install.txt
echo "  - Monitoring Dropbear (dropmon [PORT])" | tee -a log-install.txt
echo "  - Cek Login Dropbear, OpenSSH, PPTP VPN dan OpenVPN (user-login)" | tee -a log-install.txt
echo "  - Kill Multi Login Manual (1-2 Login) (user-limit [x])" | tee -a log-install.txt
echo "  - Daftar Akun dan Expire Date (user-list)" | tee -a log-install.txt
echo "  - Daftar Akun Aktif (user-active-list)" | tee -a log-install.txt
echo "  - Daftar Akun Expire (user-expire-list)" | tee -a log-install.txt
echo "  - Disable Akun Expire (user-expire)" | tee -a log-install.txt
echo "  - Memory Usage (ps-mem)" | tee -a log-install.txt
echo "  - Speedtest (speedtest --share)" | tee -a log-install.txt
echo "  - Benchmark (benchmark)" | tee -a log-install.txt
echo "  - Reboot Server (reboot)" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "Fitur lain :" | tee -a log-install.txt
echo "------------" | tee -a log-install.txt
echo "Webmin         : http://$MYIP:10000/" | tee -a log-install.txt
echo "vnstat         : http://$MYIP:81/vnstat/ (Cek Bandwith)" | tee -a log-install.txt
echo "MRTG           : http://$MYIP:81/mrtg/" | tee -a log-install.txt
echo "Timezone       : Asia/Jakarta (GMT +7)" | tee -a log-install.txt
echo "Fail2Ban       : [on]" | tee -a log-install.txt
echo "(D)DoS Deflate : [on]" | tee -a log-install.txt
echo "Block Torrent  : [off]" | tee -a log-install.txt
echo "IPv6           : [off]" | tee -a log-install.txt
#echo "Autolimit 2 bitvise per IP to all port (port 22, 143, 109, 110, 443, 1194, 7300 TCP/UDP)" | tee -a log-install.txt
echo "Auto Lock User Expire tiap jam 00:00" | tee -a log-install.txt
echo "Auto Reboot tiap jam 00:00 dan jam 12:00" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "Script Modified Pa'an Finest" | tee -a log-install.txt
echo "All Support By : Finest Media - Phreakers Jateng Official - Family KPN Jogja" | tee -a log-install.txt
echo "Thanks to Original Creator Kang Arie & Mikodemos" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "Log Instalasi --> /root/log-install.txt" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "SILAHKAN REBOOT VPS ANDA !" | tee -a log-install.txt
echo "=======================================================" | tee -a log-install.txt
cd
rm -f /root/Debs7.sh
rm -f /root/pptp.sh
rm -f /root/dropbear-2012.55.tar.bz2
rm -rf /root/dropbear-2012.55
