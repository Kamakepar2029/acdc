apt update&&apt install -y nano smbclient aptitude
apt remove samba
aptitude install -y samba
service bind9 stop && update-rc.d bind9 disable
mv /etc/samba/smb.conf /etc/samba/smb.conf.org
read -p 'Enter realm: [your realm] ' REA
read -p 'Enter domain: [your domain] ' DOMA
read -p 'Enter Server Role [dc or something else]' SRVROLE
read -p 'Enter Server Hostname [your hostname] ' HOSTSN
samba-tool domain provision --realm=$REA --domain $DOMA --adminpass=$ADM --dns-backend=SAMBA_INTERNAL --server-role=$SRVROLE --host-name=$HOSTSN --use-rfc2307 --interactive
systemctl enable smbd samba-ad-dc
systemctl restart smbd samba-ad-dc
apt-get install krb5-user resolvconf
echo "nameserver 127.0.0.1" >> /etc/resolvconf/resolv.conf.d/head
service resolvconf restart
echo 'Put the next things to [global] section at /etc/samba/smb.conf'
echo '#-------------------------------------------------'
echo 'allow dns updates = nonsecure and secure'
echo 'printing = bsd'
echo 'printcap name = /dev/null'
echo '#-------------------------------------------------'
mv /etc/krb5.conf /etc/krb5.conf.old
cp /usr/local/samba/private/krb5.conf /etc/krb5.conf
echo 'Now you should restart the computer'
read -p 'Press Enter to restart the computer'
restart
