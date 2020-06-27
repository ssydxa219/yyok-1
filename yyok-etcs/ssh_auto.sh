#!/bin/sh
hostlist="10.13.2.11~ddaa~root~hxpti 10.13.2.12~ddab~root~hxpti 10.13.2.13~ddac~root~hxpti 10.13.2.14~ddba~root~hxpti 10.13.2.15~ddbb~root~hxpti 10.13.2.16~ddbc~root~hxpti 10.13.2.17~ddca~root~hxpti 10.13.2.18~ddcb~root~hxpti 10.13.2.19~ddcc~root~hxpti 10.13.2.20~ddda~root~hxpti 10.13.2.21~dddb~root~hxpti 10.13.2.22~dddc~root~hxpti 10.13.2.23~dddd~root~hxpti 10.13.2.24~ddea~root~hxpti 10.13.2.25~ddeb~root~hxpti 10.13.2.26~ddec~root~hxpti"
#hostlist=("10.13.2.11~ddaa~root~hxpti" "10.13.2.12~ddaa~root~hxpti" "10.13.2.13~ddaa~root~hxpti")

function sshrdk(){
for h in ${hostlist[@]};do
        ip=`echo $h | cut -d "~" -f1`             # 提取文件中的ip
        host_name=`echo $h | cut -d "~" -f2`      # 提取文件中的机器名
        user_name=`echo $h | cut -d "~" -f3`      # 提取文件中的用户名
        pass_word=`echo $h | cut -d "~" -f4`      # 提取文件中的密码
#echo "======$ip===$host_name=====$user_name======$pass_word================"
hosta="$ip $host_name"
echo "=======================hosts: $hosta =========================================="
! cat /etc/hosts | grep "$hosta" && echo $hosta >> /etc/hosts
ssh $host_name <<EOF
echo "===========$host_name================"
cat /etc/hostname
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
! cat /etc/ssh/ssh_config | grep "StrictHostKeyChecking no"  && echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config
[ ! -f /root/.ssh/id_rsa.pub ] && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
ntpdate 0.asia.pool.ntp.org
hwclock --systohc
hwclock -w
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
systemctl disable firewalld.service
systemctl stop firewalld.service
exit 0;
EOF
done
}


#sshrdk

for hh in ${hostlist[@]};do
host_name=`echo $hh | cut -d "~" -f2`
scp -r /etc/hosts $host_name:/etc/
done
