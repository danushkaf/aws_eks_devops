#!/bin/bash
server_type=$1

sudo rm /etc/update-motd.d/70-available-updates
if [[ "$server_type" == "bastion" ]]
then
cat << EOFBANNER | sudo tee /etc/update-motd.d/30-banner
#!/bin/sh
cat << EOF
   ___              _    _
  / __\\  __ _  ___ | |_ (_)  ___   _ __
 /__\\// / _\\\` |/ __|| __|| | / _ \\ | '_ \\
/ \\/  \\| (_| |\\__ \\| |_ | || (_) || | | |
\\_____/ \\__,_||___/ \\__||_| \\___/ |_| |_|

EOF
EOFBANNER
sudo /usr/sbin/update-motd
fi
if [[ "$server_type" == "eks" ]]
then
cat << EOFBANNER | sudo tee /etc/update-motd.d/30-banner
#!/bin/sh
cat << EOF
       _                                  _                                    _
      | |                                | |                                  | |
  ___ | | __ ___  __      __  ___   _ __ | | __  ___  _ __   _ __    ___    __| |  ___
 / _ \\| |/ // __| \\ \\ /\\ / / / _ \\ | '__|| |/ / / _ \\| '__| | '_ \\  / _ \\  / _\\\` | / _ \\
|  __/|   < \\__ \\  \\ V  V / | (_) || |   |   < |  __/| |    | | | || (_) || (_| ||  __/
 \\___||_|\\_\\|___/   \\_/\\_/   \\___/ |_|   |_|\\_\\ \\___||_|    |_| |_| \\___/  \\__,_| \\___|

EOF
EOFBANNER
sudo /usr/sbin/update-motd
fi
if [[ "$server_type" == "sonar" ]]
then
cat << EOFBANNER | sudo tee /etc/update-motd.d/30-banner
#!/bin/sh
cat << EOF
 __
/ _\\  ___   _ __    __ _  _ __
\\ \\  / _ \\ | '_ \\  / _\\\` || '__|
_\\ \\| (_) || | | || (_| || |
\\__/ \\___/ |_| |_| \\__,_||_|

EOF
EOFBANNER
sudo /usr/sbin/update-motd
fi
if [[ "$server_type" == "jenkins" ]]
then
cat << EOFBANNER | sudo tee /etc/update-motd.d/30-banner
#!/bin/sh
cat << EOF
  __                _     _
  \\\\ \\\\   ___  _ __  | | __(_) _ __   ___
   \\\\ \\\\ / _ \\\\| '_ \\\\ | |/ /| || '_ \\\\ / __|
/\\\\_/ /|  __/| | | ||   < | || | | |\\\\__ \\\\
\\\\___/  \\\\___||_| |_||_|\\\\_\\\\|_||_| |_||___/

EOF
EOFBANNER
sudo /usr/sbin/update-motd
fi

# /etc/sysctl.conf
cat << EOF | sudo tee -a /etc/sysctl.conf
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
fs.suid_dumpable = 0
kernel.randomize_va_space = 2
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
EOF

# Run the following commands to set the active kernel parameters:
sudo sysctl -w net.ipv4.conf.all.send_redirects=0
sudo sysctl -w net.ipv4.conf.default.send_redirects=0
sudo sysctl -w net.ipv4.conf.all.accept_source_route=0
sudo sysctl -w net.ipv4.conf.default.accept_source_route=0
sudo sysctl -w net.ipv6.conf.all.accept_source_route=0
sudo sysctl -w net.ipv6.conf.default.accept_source_route=0
sudo sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sudo sysctl -w net.ipv6.conf.all.accept_ra=0
sudo sysctl -w net.ipv6.conf.default.accept_ra=0
sudo sysctl -w net.ipv4.ip_forward=0
sudo sysctl -w net.ipv6.conf.all.forwarding=0
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.default.accept_redirects=0
sudo sysctl -w net.ipv6.conf.all.accept_redirects=0
sudo sysctl -w net.ipv6.conf.default.accept_redirects=0
sudo sysctl -w net.ipv4.conf.all.log_martians=1
sudo sysctl -w net.ipv4.conf.default.log_martians=1
sudo sysctl -w net.ipv4.tcp_syncookies=1
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sudo sysctl -w net.ipv4.conf.all.secure_redirects=0
sudo sysctl -w net.ipv4.conf.default.secure_redirects=0
sudo sysctl -w fs.suid_dumpable=0
sudo sysctl -w kernel.randomize_va_space=2
sudo sysctl -w net.ipv4.conf.all.rp_filter=1
sudo sysctl -w net.ipv4.conf.default.rp_filter=1
sudo sysctl -w net.ipv4.route.flush=1
sudo sysctl -w net.ipv6.route.flush=1

# /etc/security/limits.conf
cat << EOF | sudo tee -a /etc/security/limits.conf
*  hard    core  0
EOF

# /etc/modprobe.d/blacklist.conf # create new file
cat << EOF | sudo tee /etc/modprobe.d/blacklist.conf
install hfsplus /bin/true
install hfs /bin/true
install cramfs /bin/true
install udf /bin/true
install squashfs /bin/true
EOF

sudo modprobe hfsplus
sudo modprobe hfs
sudo modprobe cramfs
sudo modprobe udf
sudo modprobe squashfs
sudo insmod /lib/modules/4.14.209-160.339.amzn2.x86_64/kernel/fs/cramfs/cramfs.ko
sudo insmod /lib/modules/4.14.209-160.339.amzn2.x86_64/kernel/fs/udf/udf.ko
sudo insmod /lib/modules/4.14.209-160.339.amzn2.x86_64/kernel/fs/hfsplus/hfsplus.ko
sudo insmod /lib/modules/4.14.209-160.339.amzn2.x86_64/kernel/fs/hfs/hfs.ko
sudo insmod /lib/modules/4.14.209-160.339.amzn2.x86_64/kernel/fs/squashfs/squashfs.ko
sudo rmmod hfsplus
sudo rmmod hfs
sudo rmmod cramfs
sudo rmmod udf
sudo rmmod squashfs

sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/s/\"$/ audit=1\"/" /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# /etc/ssh/sshd_config
sudo sed -i 's/X11Forwarding yes/# X11Forwarding yes/g' /etc/ssh/sshd_config
cat << EOF | sudo tee -a /etc/ssh/sshd_config
AllowUsers ec2-user
AllowGroups ec2-user
DenyUsers root
DenyGroups root
PermitRootLogin no
Banner /etc/issue.net
HostbasedAuthentication no
PermitUserEnvironment no
MaxAuthTries 4
IgnoreRhosts yes
X11Forwarding no
PermitUserEnvironment no
HostbasedAuthentication no
PermitEmptyPasswords no
Protocol 2
LoginGraceTime 60
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
LogLevel INFO
ClientAliveInterval 300
ClientAliveCountMax 0
EOF
sudo systemctl restart sshd

# Permission Changes
sudo chown root:root /etc/crontab
sudo chmod og-rwx /etc/crontab
sudo rm /etc/cron.deny
sudo rm /etc/at.deny
sudo touch /etc/cron.allow
sudo touch /etc/at.allow
sudo chmod og-rwx /etc/cron.allow
sudo chmod og-rwx /etc/at.allow
sudo touch /etc/at.allow
sudo chown root:root /etc/cron.allow
sudo chown root:root /etc/at.allow
echo "ec2-user" | sudo tee -a /etc/cron.allow
echo "ec2-user" | sudo tee -a /etc/at.allow
sudo chown root:root /etc/cron.d
sudo chmod og-rwx /etc/cron.d
sudo crontab -l -u root > cronlist
echo "0 5 * * * /usr/sbin/aide --check" >> cronlist
sudo crontab -u root cronlist
rm cronlist
sudo chown root:root /etc/cron.weekly
sudo chmod og-rwx /etc/cron.weekly
sudo chown root:root /etc/cron.daily
sudo chmod og-rwx /etc/cron.daily
sudo chown root:root /etc/cron.monthly
sudo chmod og-rwx /etc/cron.monthly
sudo chown root:root /etc/cron.hourly
sudo chmod og-rwx /etc/cron.hourly

sudo chown root:root /boot/grub2/grub.cfg
sudo chmod og-rwx /boot/grub2/grub.cfg

if [[ "$server_type" == "eks" ]]
then
sudo iptables -N DOCKER
sudo iptables -N DOCKER-ISOLATION-STAGE-1
sudo iptables -N DOCKER-ISOLATION-STAGE-2
sudo iptables -N DOCKER-USER
sudo iptables -N KUBE-EXTERNAL-SERVICES
sudo iptables -N KUBE-FIREWALL
sudo iptables -N KUBE-FORWARD
sudo iptables -N KUBE-KUBELET-CANARY
sudo iptables -N KUBE-PROXY-CANARY
sudo iptables -N KUBE-SERVICES
sudo iptables -A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo iptables -A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
sudo iptables -A INPUT -j KUBE-FIREWALL
sudo iptables -A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
sudo iptables -A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo iptables -A FORWARD -j DOCKER-USER
sudo iptables -A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo iptables -A OUTPUT -j KUBE-FIREWALL
sudo iptables -A DOCKER-ISOLATION-STAGE-1 -j RETURN
sudo iptables -A DOCKER-ISOLATION-STAGE-2 -j RETURN
sudo iptables -A DOCKER-USER -j RETURN
sudo iptables -A KUBE-FIREWALL -m comment --comment "kubernetes firewall for dropping marked packets" -m mark --mark 0x8000/0x8000 -j DROP
sudo iptables -A KUBE-FIREWALL ! -s 127.0.0.0/8 -d 127.0.0.0/8 -m comment --comment "block incoming localnet connections" -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j DROP
sudo iptables -A KUBE-FORWARD -m conntrack --ctstate INVALID -j DROP
sudo iptables -A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT

sudo ip6tables -N DOCKER
sudo ip6tables -N DOCKER-ISOLATION-STAGE-1
sudo ip6tables -N DOCKER-ISOLATION-STAGE-2
sudo ip6tables -N DOCKER-USER
sudo ip6tables -N KUBE-EXTERNAL-SERVICES
sudo ip6tables -N KUBE-FIREWALL
sudo ip6tables -N KUBE-FORWARD
sudo ip6tables -N KUBE-KUBELET-CANARY
sudo ip6tables -N KUBE-PROXY-CANARY
sudo ip6tables -N KUBE-SERVICES
sudo ip6tables -A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo ip6tables -A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
sudo ip6tables -A INPUT -j KUBE-FIREWALL
sudo ip6tables -A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
sudo ip6tables -A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo ip6tables -A FORWARD -j DOCKER-USER
sudo ip6tables -A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo ip6tables -A OUTPUT -j KUBE-FIREWALL
sudo ip6tables -A DOCKER-ISOLATION-STAGE-1 -j RETURN
sudo ip6tables -A DOCKER-ISOLATION-STAGE-2 -j RETURN
sudo ip6tables -A DOCKER-USER -j RETURN
sudo ip6tables -A KUBE-FIREWALL -m comment --comment "kubernetes firewall for dropping marked packets" -m mark --mark 0x8000/0x8000 -j DROP
sudo ip6tables -A KUBE-FIREWALL ! -s 127.0.0.0/8 -d 127.0.0.0/8 -m comment --comment "block incoming localnet connections" -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j DROP
sudo ip6tables -A KUBE-FORWARD -m conntrack --ctstate INVALID -j DROP
sudo ip6tables -A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
fi

sudo ip6tables -A INPUT -p tcp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -p tcp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -p udp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -p udp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A OUTPUT -p tcp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A OUTPUT -p tcp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A OUTPUT -p udp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A OUTPUT -p udp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

sudo ip6tables -P INPUT DROP
sudo ip6tables -P OUTPUT DROP
sudo ip6tables -P FORWARD DROP
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
sudo iptables -A INPUT -s 127.0.0.0/8 -j DROP
sudo ip6tables -A INPUT -i lo -j ACCEPT
sudo ip6tables -A OUTPUT -o lo -j ACCEPT
sudo ip6tables -A INPUT -s ::1 -j DROP
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP

if [[ "$server_type" == "eks" ]]
then
cat << EOF | sudo tee /usr/bin/firewallrules.sh
sudo iptables -N DOCKER
sudo iptables -N DOCKER-ISOLATION-STAGE-1
sudo iptables -N DOCKER-ISOLATION-STAGE-2
sudo iptables -N DOCKER-USER
sudo iptables -N KUBE-EXTERNAL-SERVICES
sudo iptables -N KUBE-FIREWALL
sudo iptables -N KUBE-FORWARD
sudo iptables -N KUBE-KUBELET-CANARY
sudo iptables -N KUBE-PROXY-CANARY
sudo iptables -N KUBE-SERVICES
sudo iptables -A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo iptables -A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
sudo iptables -A INPUT -j KUBE-FIREWALL
sudo iptables -A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
sudo iptables -A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo iptables -A FORWARD -j DOCKER-USER
sudo iptables -A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo iptables -A OUTPUT -j KUBE-FIREWALL
sudo iptables -A DOCKER-ISOLATION-STAGE-1 -j RETURN
sudo iptables -A DOCKER-ISOLATION-STAGE-2 -j RETURN
sudo iptables -A DOCKER-USER -j RETURN
sudo iptables -A KUBE-FIREWALL -m comment --comment "kubernetes firewall for dropping marked packets" -m mark --mark 0x8000/0x8000 -j DROP
sudo iptables -A KUBE-FIREWALL ! -s 127.0.0.0/8 -d 127.0.0.0/8 -m comment --comment "block incoming localnet connections" -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j DROP
sudo iptables -A KUBE-FORWARD -m conntrack --ctstate INVALID -j DROP
sudo iptables -A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT

sudo ip6tables -N DOCKER
sudo ip6tables -N DOCKER-ISOLATION-STAGE-1
sudo ip6tables -N DOCKER-ISOLATION-STAGE-2
sudo ip6tables -N DOCKER-USER
sudo ip6tables -N KUBE-EXTERNAL-SERVICES
sudo ip6tables -N KUBE-FIREWALL
sudo ip6tables -N KUBE-FORWARD
sudo ip6tables -N KUBE-KUBELET-CANARY
sudo ip6tables -N KUBE-PROXY-CANARY
sudo ip6tables -N KUBE-SERVICES
sudo ip6tables -A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo ip6tables -A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
sudo ip6tables -A INPUT -j KUBE-FIREWALL
sudo ip6tables -A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
sudo ip6tables -A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo ip6tables -A FORWARD -j DOCKER-USER
sudo ip6tables -A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
sudo ip6tables -A OUTPUT -j KUBE-FIREWALL
sudo ip6tables -A DOCKER-ISOLATION-STAGE-1 -j RETURN
sudo ip6tables -A DOCKER-ISOLATION-STAGE-2 -j RETURN
sudo ip6tables -A DOCKER-USER -j RETURN
sudo ip6tables -A KUBE-FIREWALL -m comment --comment "kubernetes firewall for dropping marked packets" -m mark --mark 0x8000/0x8000 -j DROP
sudo ip6tables -A KUBE-FIREWALL ! -s 127.0.0.0/8 -d 127.0.0.0/8 -m comment --comment "block incoming localnet connections" -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j DROP
sudo ip6tables -A KUBE-FORWARD -m conntrack --ctstate INVALID -j DROP
sudo ip6tables -A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
EOF
fi

cat << EOF | sudo tee -a /usr/bin/firewallrules.sh
sudo ip6tables -A INPUT -p tcp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -p tcp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -p udp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A INPUT -p udp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A OUTPUT -p tcp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A OUTPUT -p tcp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A OUTPUT -p udp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -A OUTPUT -p udp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp --match multiport -d 0.0.0.0/0 --dports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp --match multiport -d 0.0.0.0/0 --sports 0:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo ip6tables -P INPUT DROP
sudo ip6tables -P OUTPUT DROP
sudo ip6tables -P FORWARD DROP
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
sudo iptables -A INPUT -s 127.0.0.0/8 -j DROP
sudo ip6tables -A INPUT -i lo -j ACCEPT
sudo ip6tables -A OUTPUT -o lo -j ACCEPT
sudo ip6tables -A INPUT -s ::1 -j DROP
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP
EOF

sudo chmod +x /usr/bin/firewallrules.sh
sudo crontab -l -u root > cronlist
echo "@reboot /usr/bin/firewallrules.sh" >> cronlist
sudo crontab -u root cronlist
rm cronlist

# /etc/audit/rules.d/audit.rules
cat << EOF | sudo tee -a /etc/audit/rules.d/audit.rules
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete
-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete
-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale
-w /etc/sysconfig/network-scripts/ -p wa -k system-locale
-w /var/log/sudo.log -p wa -k actions
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
-a always,exit -F arch=b64 -S init_module -S delete_module -k modules
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change
-a always,exit -F arch=b64 -S clock_settime -k time-change
-a always,exit -F arch=b32 -S clock_settime -k time-change
-w /etc/localtime -p wa -k time-change
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock/ -p wa -k logins
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k logins
-w /var/log/btmp -p wa -k logins
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access
-w /etc/sudoers -p wa -k scope
-w /etc/sudoers.d/ -p wa -k scope
-e 2
-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
-w /etc/selinux/ -p wa -k MAC-policy
-w /usr/share/selinux/ -p wa -k MAC-policy
-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts
-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts
EOF
sudo augenrules --check
sudo augenrules --load

# /etc/security/pwquality.conf
cat << EOF | sudo tee -a /etc/security/pwquality.conf
minlen = 14
dcredit = -1
ucredit = -1
ocredit = -1
lcredit = -1
EOF

# profile files
cat << EOF | sudo tee -a /etc/bashrc
TMOUT=600
umask 027
EOF
cat << EOF | sudo tee -a /etc/profile
TMOUT=600
umask 027
EOF

sudo sed -i 's:^PASS_MAX_DAYS*\([ \t]*.*\)$:PASS_MAX_DAYS    90:' /etc/login.defs
sudo sed -i 's:^PASS_MIN_DAYS*\([ \t]*.*\)$:PASS_MIN_DAYS    7:' /etc/login.defs

newOptions=mode=1777,strictatime,noexec,nodev,nosuid
sudo sed -i 's:^[ \t]*Options[ \t]*=\([ \t]*.*\)$:Options = '${newOptions}':' /etc/systemd/system/local-fs.target.wants/tmp.mount
sudo systemctl unmask tmp.mount
sudo systemctl enable tmp.mount

# Create partitions in second disk and mount
if [[ "$server_type" == "jenkins" ]]
then
  sudo systemctl stop jenkins
  sudo umount /var/lib/jenkins/
fi

if [[ "$server_type" != "jenkins" && "$server_type" != "sonar" && "$server_type" != "eks" ]]
then
sudo fdisk /dev/xvdb <<EEOF
n
p
1

2099200

n
p
2

16779264

n
p
3

18876416

n
e
4



n
l
5

33556480

n
l
6



w
EEOF

sleep 10s

sudo mkfs.xfs /dev/sdb1
sudo mkdir -p /srv/home
sudo mkdir -p /srv/vartmp
sudo mount /dev/sdb1 /srv/home
sudo cp -aR /home/* /srv/home/
sudo rm -rf /home/*
sudo umount /srv/home
sudo mount /dev/sdb1 /home

sudo mkfs.xfs /dev/sdb2
sudo mkdir -p /srv/var
sudo mkdir -p /srv/var
sudo mount /dev/sdb2 /srv/var
sudo cp -aR /var/* /srv/var/
sudo rm -rf /var/*
sudo umount /srv/var
sudo mount /dev/sdb2 /var

sudo mkfs.xfs /dev/sdb3
sudo mkdir -p /srv/vartmp
sudo mount /dev/sdb3 /srv/vartmp
sudo cp -aR /var/tmp/* /srv/vartmp/
sudo rm -rf /var/tmp/*
sudo umount /srv/vartmp
sudo mount /dev/sdb3 /var/tmp

sudo mkfs.xfs /dev/sdb5
sudo mkdir -p /srv/varlog
sudo mount /dev/sdb5 /srv/varlog
sudo cp -aR /var/log/* /srv/varlog/
sudo rm -rf /var/log/*
sudo umount /srv/varlog
sudo mount /dev/sdb5 /var/log

sudo mkfs.xfs /dev/sdb6
sudo mkdir -p /srv/varlogaudit
sudo mount /dev/sdb6 /srv/varlogaudit
sudo cp -aR /var/log/audit/* /srv/varlogaudit/
sudo rm -rf /var/log/audit/*
sudo umount /srv/varlogaudit
sudo mount /dev/sdb6 /var/log/audit

sleep 10s

uuidstring=$(sudo blkid /dev/xvdb1 | sed -n 's/.* UUID=\"\([^\"]*\)\".*/\1/p' | xargs)
fstabentry="UUID=${uuidstring} /home xfs defaults,noatime,nodev  1   1"
echo ${fstabentry} | sudo tee -a /etc/fstab
uuidstring=$(sudo blkid /dev/xvdb2 | sed -n 's/.* UUID=\"\([^\"]*\)\".*/\1/p' | xargs)
fstabentry="UUID=${uuidstring} /var xfs defaults,noatime  1   1"
echo ${fstabentry} | sudo tee -a /etc/fstab
uuidstring=$(sudo blkid /dev/xvdb3 | sed -n 's/.* UUID=\"\([^\"]*\)\".*/\1/p' | xargs)
fstabentry="UUID=${uuidstring} /var/tmp xfs defaults,noatime,nosuid,nodev,noexec  1   1"
echo ${fstabentry} | sudo tee -a /etc/fstab
uuidstring=$(sudo blkid /dev/xvdb5 | sed -n 's/.* UUID=\"\([^\"]*\)\".*/\1/p' | xargs)
fstabentry="UUID=${uuidstring} /var/log xfs defaults,noatime  1   1"
echo ${fstabentry} | sudo tee -a /etc/fstab
uuidstring=$(sudo blkid /dev/xvdb6 | sed -n 's/.* UUID=\"\([^\"]*\)\".*/\1/p' | xargs)
fstabentry="UUID=${uuidstring} /var/log/audit xfs defaults,noatime  1   1"
echo ${fstabentry} | sudo tee -a /etc/fstab
fstabentry="tmpfs    /dev/shm    tmpfs   defaults,nodev,nosuid,noexec                                0 0"
echo ${fstabentry} | sudo tee -a /etc/fstab
fstabentry="tmpfs    /tmp        tmpfs   defaults,rw,noatime,nosuid,nodev,noexec,relatime,size=256m  0 0"
echo ${fstabentry} | sudo tee -a /etc/fstab
else
sudo fdisk /dev/nvme1n1 <<EEOF
n
p
1

2099200

n
p
2

16779264

n
p
3

18876416

n
e
4



n
l
5

33556480

n
l
6



w
EEOF

sleep 10s

sudo mkfs.xfs /dev/nvme1n1p1
sudo mkdir -p /srv/home
sudo mkdir -p /srv/vartmp
sudo mount /dev/nvme1n1p1 /srv/home
sudo cp -aR /home/* /srv/home/
sudo rm -rf /home/*
sudo umount /srv/home
sudo mount /dev/nvme1n1p1 /home

sudo mkfs.xfs /dev/nvme1n1p2
sudo mkdir -p /srv/var
sudo mkdir -p /srv/var
sudo mount /dev/nvme1n1p2 /srv/var
sudo cp -aR /var/* /srv/var/
sudo rm -rf /var/*
sudo umount /srv/var
sudo mount /dev/nvme1n1p2 /var

sudo mkfs.xfs /dev/nvme1n1p3
sudo mkdir -p /srv/vartmp
sudo mount /dev/nvme1n1p3 /srv/vartmp
sudo cp -aR /var/tmp/* /srv/vartmp/
sudo rm -rf /var/tmp/*
sudo umount /srv/vartmp
sudo mount /dev/nvme1n1p3 /var/tmp

sudo mkfs.xfs /dev/nvme1n1p5
sudo mkdir -p /srv/varlog
sudo mount /dev/nvme1n1p5 /srv/varlog
sudo cp -aR /var/log/* /srv/varlog/
sudo rm -rf /var/log/*
sudo umount /srv/varlog
sudo mount /dev/nvme1n1p5 /var/log

sudo mkfs.xfs /dev/nvme1n1p6
sudo mkdir -p /srv/varlogaudit
sudo mount /dev/nvme1n1p6 /srv/varlogaudit
sudo cp -aR /var/log/audit/* /srv/varlogaudit/
sudo rm -rf /var/log/audit/*
sudo umount /srv/varlogaudit
sudo mount /dev/nvme1n1p6 /var/log/audit

sleep 10s

uuidstring=$(sudo blkid /dev/nvme1n1p1 | sed -n 's/.* UUID=\"\([^\"]*\)\".*/\1/p' | xargs)
fstabentry="UUID=${uuidstring} /home xfs defaults,noatime,nodev  1   1"
echo ${fstabentry} | sudo tee -a /etc/fstab
uuidstring=$(sudo blkid /dev/nvme1n1p2 | sed -n 's/.* UUID=\"\([^\"]*\)\".*/\1/p' | xargs)
fstabentry="UUID=${uuidstring} /var xfs defaults,noatime  1   1"
echo ${fstabentry} | sudo tee -a /etc/fstab
uuidstring=$(sudo blkid /dev/nvme1n1p3 | sed -n 's/.* UUID=\"\([^\"]*\)\".*/\1/p' | xargs)
fstabentry="UUID=${uuidstring} /var/tmp xfs defaults,noatime,nosuid,nodev,noexec  1   1"
echo ${fstabentry} | sudo tee -a /etc/fstab
uuidstring=$(sudo blkid /dev/nvme1n1p5 | sed -n 's/.* UUID=\"\([^\"]*\)\".*/\1/p' | xargs)
fstabentry="UUID=${uuidstring} /var/log xfs defaults,noatime  1   1"
echo ${fstabentry} | sudo tee -a /etc/fstab
uuidstring=$(sudo blkid /dev/nvme1n1p6 | sed -n 's/.* UUID=\"\([^\"]*\)\".*/\1/p' | xargs)
fstabentry="UUID=${uuidstring} /var/log/audit xfs defaults,noatime  1   1"
echo ${fstabentry} | sudo tee -a /etc/fstab
fstabentry="tmpfs    /dev/shm    tmpfs   defaults,nodev,nosuid,noexec                                0 0"
echo ${fstabentry} | sudo tee -a /etc/fstab
fstabentry="tmpfs    /tmp        tmpfs   defaults,rw,noatime,nosuid,nodev,noexec,relatime,size=256m  0 0"
echo ${fstabentry} | sudo tee -a /etc/fstab
fi

sudo mount -a

sudo find -L /var/log -type f -exec chmod g-wx,o-rwx {} +
line="0 0 * * * find -L /var/log -type f -exec chmod g-wx,o-rwx {} +"
(sudo crontab -l; echo "$line" ) | sudo crontab -

# /etc/audit/auditd.conf
sudo sed -i 's:^[ \t]*space_left_action[ \t]*=\([ \t]*.*\)$:space_left_action = email:' /etc/audit/auditd.conf
sudo sed -i 's:^[ \t]*action_mail_acct[ \t]*=\([ \t]*.*\)$:action_mail_acct = root:' /etc/audit/auditd.conf
sudo sed -i 's:^[ \t]*admin_space_left_action[ \t]*=\([ \t]*.*\)$:admin_space_left_action = halt:' /etc/audit/auditd.conf
sudo sed -i 's:^[ \t]*max_log_file_action[ \t]*=\([ \t]*.*\)$:max_log_file_action = keep_logs:' /etc/audit/auditd.conf

# User security
# /etc/pam.d/password-auth and /etc/pam.d/system-auth
sudo sed -i 's|^auth*\([ \t]*.*\)sufficient*\([ \t]*.*\)pam_unix.so*\([ \t]*.*\)$|auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900\nauth [success=1 default=bad] pam_unix.so\nauth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900\nauth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900|g' /etc/pam.d/password-auth
sudo sed -i 's|^auth*\([ \t]*.*\)sufficient*\([ \t]*.*\)pam_unix.so*\([ \t]*.*\)$|auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900\nauth [success=1 default=bad] pam_unix.so\nauth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900\nauth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900|g' /etc/pam.d/system-auth
sudo sed -i 's|^password*\([ \t]*.*\)sufficient*\([ \t]*.*\)pam_unix.so*\([ \t]*.*\)$|& remember=5|' /etc/pam.d/system-auth
sudo sed -i 's|^password*\([ \t]*.*\)sufficient*\([ \t]*.*\)pam_unix.so*\([ \t]*.*\)$|& remember=5|' /etc/pam.d/password-auth

sudo sed -i '/^account*\([ \t]*.*\)sufficient*\([ \t]*.*\)$/i auth            required        pam_wheel.so use_uid' /etc/pam.d/su
sudo sed -i 's|^wheel:x:10:*\([ \t]*.*\)$|wheel:x:10:root,ec2-user|' /etc/group

sudo useradd -D -f 30
sudo chage --inactive 30

# Syslog changes
sudo sed -i '1i$FileCreateMode 0640' /etc/rsyslog.conf
sudo sed -i '1i$FileCreateMode 0640' /etc/rsyslog.d/*.conf

if [[ "$server_type" != "jenkins" && "$server_type" != "sonar" ]]
then
  sudo yum -y remove xorg-x11*
fi

sudo sed -i 's:^[ \t]*SELINUX[ \t]*=\([ \t]*.*\)$:SELINUX=enforcing:' /etc/selinux/config

sudo yum install -y aide
sudo aide --init
sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

# /etc/rsyslog.conf and /etc/rsyslog.d/*.conf files
sudo sed -i '1i$FileCreateMode 0640' /etc/rsyslog.conf
sudo sed -i '1i$FileCreateMode 0640' /etc/rsyslog.d/*.conf
echo '*.* @@localhost' | sudo tee -a /etc/rsyslog.conf
echo '*.* @@localhost' | sudo tee -a /etc/rsyslog.d/*.conf

sudo reboot
