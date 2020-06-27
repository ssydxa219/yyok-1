#!/bin/bash
##前提要求1：centos7
##前提要求2：网络独立IP配好，并外网已经通
##1. ssh 打通
##2. jdk1.8 安装
##3. centos7 优化

##修改ip地址、网关、主机名、DNS等
##关闭selinux，清空iptables
##添加普通用户并进行sudo授权管理
##更新yum源及必要软件安装
##定时自动更新服务器时间
##精简开机自启动服务
##定时自动清理/var/spool/clientmqueue/目录垃圾文件，放置inode节点被占满
##变更默认的ssh服务端口，禁止root用户远程连接
##锁定关键文件系统
##调整文件描述符大小
##调整字符集，使其支持中文
##去除系统及内核版本登录前的屏幕显示
##禁止ping
##历史记录
##内核参数优化
##升级具有典型漏洞的软件版本


declare run_time_1=`date "+%Y.%m.%d-%H:%M:%S"`

if [[ "$(whoami)" != "root" ]]; then
    echo "please run this script as root ." >&2
    exit 1
fi

echo -e "\033[31m 这个是centos7系统初始化脚本，请慎重运行！Please continue to enter or ctrl+C to cancel \033[0m"
sleep 5

#hostname
hostname_config(){
    HostName=$(echo "ip"-$(ip addr|grep inet|grep brd|grep scope|awk '{print $2}'|awk -F '/' '{print $1}'|sed 's/\./-/g'))
    sed -i -e '/HOSTNAME/d' /etc/sysconfig/network
    echo "HOSTNAME=$HostName" >>/etc/sysconfig/network
    echo "127.0.0.1 $HostName" >> /etc/hosts
    hostname $HostName
    hostname
}

#configure yum source
yum_config(){
    yum install wget epel-release -y
    cd /etc/yum.repos.d/ && mkdir bak && mv -f *.repo bak/
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    yum clean all && yum makecache

}
#5.定义安装常用工具的函数
yum_tools(){
yum install -y gcc gcc-c++ make automake vim wget curl curl-devel chrony bash-completion lsof iotop iostat unzip bzip2 bzip2-devel libxml2-devel autoconf openssl-devel openssl-perl net-tools
yum -y install iotop iftop lrzsz curl curl-devel unzip ntp libaio-devel ncurses-devel autoconf  zlib-devel  python-devel bash-completion lsof
source /usr/share/bash-completion/bash_completion
}


start_stop(){
#firewalld
    systemctl stop firewalld.service
    systemctl disable firewalld.service

    systemctl start chronyd.service
    systemctl enable chronyd.service
    #sed -i.bak 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
    sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
    #touch /etc/sysconfig/selinux.$run_time_1
    #cat /etc/sysconfig/selinux >> /etc/sysconfig/selinux.$run_time_1
    #echo "SELINUX=disabled">/etc/sysconfig/selinux
    #echo "SELINUXTYPE=targeted">>/etc/sysconfig/selinux


}


#system config
system_config(){

    timedatectl set-local-rtc 1 && timedatectl set-timezone Asia/Shanghai

}
ulimit_config(){
    echo "ulimit -SHn 102400" >> /etc/rc.local
    chmod +x /etc/rc.d/rc.local
    cat >> /etc/security/limits.conf << EOF
    *           soft   nofile       102400
    *           hard   nofile       102400
    *           soft   nproc        102400
    *           hard   nproc        102400
    *           soft   stack        8192
    *           hard   stack        8192
EOF
    sed -i -e '/\*/d' /etc/security/limits.d/90-nproc.conf
    echo "* soft nproc 300000" >>/etc/security/limits.d/90-nproc.conf
}

#set sysctl
sysctl_config(){
    cp /etc/sysctl.conf /etc/sysctl.conf.$run_time_1
    cat > /etc/sysctl.conf << EOF
    #CTCDN系统优化参数
    #关闭ipv6
    net.ipv6.conf.all.disable_ipv6 = 1
    net.ipv6.conf.default.disable_ipv6 = 1
    #决定检查过期多久邻居条目
    net.ipv4.neigh.default.gc_stale_time=120
    #使用arp_announce / arp_ignore解决ARP映射问题
    net.ipv4.conf.default.arp_announce = 2
    net.ipv4.conf.all.arp_announce=2
    net.ipv4.conf.lo.arp_announce=2
    # 避免放大攻击
    net.ipv4.icmp_echo_ignore_broadcasts = 1
    # 开启恶意icmp错误消息保护
    net.ipv4.icmp_ignore_bogus_error_responses = 1
    #关闭路由转发
    net.ipv4.ip_forward = 0
    net.ipv4.conf.all.send_redirects = 0
    net.ipv4.conf.default.send_redirects = 0
    #开启反向路径过滤
    net.ipv4.conf.all.rp_filter = 1
    net.ipv4.conf.default.rp_filter = 1
    #处理无源路由的包
    net.ipv4.conf.all.accept_source_route = 0
    net.ipv4.conf.default.accept_source_route = 0
    #关闭sysrq功能
    kernel.sysrq = 0
    #core文件名中添加pid作为扩展名
    kernel.core_uses_pid = 1
    # 开启SYN洪水攻击保护
    net.ipv4.tcp_syncookies = 1
    #修改消息队列长度
    kernel.msgmnb = 65536
    kernel.msgmax = 65536
    #设置最大内存共享段大小bytes
    kernel.shmmax = 68719476736
    kernel.shmall = 4294967296
    #timewait的数量，默认180000
    net.ipv4.tcp_max_tw_buckets = 6000
    net.ipv4.tcp_sack = 1
    net.ipv4.tcp_window_scaling = 1
    net.ipv4.tcp_rmem = 4096        87380   4194304
    net.ipv4.tcp_wmem = 4096        16384   4194304
    net.core.wmem_default = 8388608
    net.core.rmem_default = 8388608
    net.core.rmem_max = 16777216
    net.core.wmem_max = 16777216
    #每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目
    net.core.netdev_max_backlog = 262144
    #限制仅仅是为了防止简单的DoS 攻击
    net.ipv4.tcp_max_orphans = 3276800
    #未收到客户端确认信息的连接请求的最大值
    net.ipv4.tcp_max_syn_backlog = 262144
    net.ipv4.tcp_timestamps = 0
    #内核放弃建立连接之前发送SYNACK 包的数量
    net.ipv4.tcp_synack_retries = 1
    #内核放弃建立连接之前发送SYN 包的数量
    net.ipv4.tcp_syn_retries = 1
    #启用timewait 快速回收
    net.ipv4.tcp_tw_recycle = 1
    #开启重用。允许将TIME-WAIT sockets 重新用于新的TCP 连接
    net.ipv4.tcp_tw_reuse = 1
    net.ipv4.tcp_mem = 94500000 915000000 927000000
    net.ipv4.tcp_fin_timeout = 1
    #当keepalive 起用的时候，TCP 发送keepalive 消息的频度。缺省是2 小时
    net.ipv4.tcp_keepalive_time = 1800
    net.ipv4.tcp_keepalive_probes = 3
    net.ipv4.tcp_keepalive_intvl = 15
    #允许系统打开的端口范围
    net.ipv4.ip_local_port_range = 1024    65000
    #修改防火墙表大小，默认65536
    net.netfilter.nf_conntrack_max=655350
    net.netfilter.nf_conntrack_tcp_timeout_established=1200
    # 确保无人能修改路由表
    net.ipv4.conf.all.accept_redirects = 0
    net.ipv4.conf.default.accept_redirects = 0
    net.ipv4.conf.all.secure_redirects = 0
    net.ipv4.conf.default.secure_redirects = 0
EOF
    /sbin/sysctl -p
    echo "sysctl set OK!!"
}

#ssh
ssh_config(){
    touch /etc/ssh/sshd_config.$run_time_1
    cat /etc/ssh/sshd_config >> /etc/ssh/sshd_config.$run_time_1
    sed -i 's%#UseDNS yes%UseDNS no%' /etc/ssh/sshd_config
    sed -i 's%GSSAPIAuthentication yes%GSSAPIAuthentication no%' /etc/ssh/sshd_config
}

#ntp
ntp_config(){
    ln -sf /usr/share/zoneinfo/posix/Asia/Shanghai /etc/localtime
    service ntpd stop
    chkconfig ntpd off
    ntpdate time.windows.com
    clock --systohc

    cat >> /etc/cron.daily/ntp.sh <<'EOF'
    #!/bin/bash
    ntplog=/tmp/wmbak.log
    ntpdate ntp.wumart.com 2>&1 >>$ntplog
     clock --systohc
EOF
    chmod 755 /etc/cron.daily/ntp.sh
}


#zabbix
zabbix_config(){
    sed -i 's/^Defaults.*.requiretty/#Defaults requiretty/' /etc/sudoers
    echo 'zabbix ALL=(root) NOPASSWD:/bin/netstat'>/etc/sudoers.d/zabbix
    echo 'zabbix ALL=(root) NOPASSWD:/usr/sbin/ss'>>/etc/sudoers.d/zabbix
    chmod 400 /etc/sudoers.d/zabbix
}

#6.定义升级最新内核的函数
update_kernel (){
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install -y kernel-ml
grub2-set-default 0
grub2-mkconfig -o /boot/grub2/grub.cfg
}

other_config(){
    if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
       echo never > /sys/kernel/mm/transparent_hugepage/enabled
    fi
    if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
       echo never > /sys/kernel/mm/transparent_hugepage/defrag
    fi
    cat << EOF >> /etc/rc.local
    if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
       echo never > /sys/kernel/mm/transparent_hugepage/enabled
    fi
    if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
       echo never > /sys/kernel/mm/transparent_hugepage/defrag
    fi
EOF
    echo 1 > /proc/sys/vm/swappiness
}

# 修改用户进程限制
userlimits () {
    read -r -p "是否加大普通用户限制? [y/n] " input
    case $input in
        y)
        sed -i 's#4096#65535#g'   /etc/security/limits.d/20-nproc.conf
        openfile
        ;;
        n)
        openfile
        ;;
    esac
}

# 修改主机名
modfyhostname () {
    read -r -p "是否要修改主机名? [y/n]" input
    case $input in
        y)
        read -r -p "请输入主机名:" hostname
        hostnamectl set-hostname $hostname
        userlimits
        ;;
        n)
        userlimits
        ;;
    esac
}

dev_env_install(){
mkdir -p /ddhome/{tools,tmp,bin,usr,log}
chmod -R 777 /ddhome
cd /ddhome/src

#cd /ddhome/tools/
echo "-------down ----------"
#rpm -ivh install/jdk-8u192-linux-x64.rpm
tart -zxvf install/scala.tar.gz

cat >> /etc/profile << EOF
export JAVA_HOME=/usr/java/jdk1.8.0_222-amd64
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
export SCALA_HOME=/ddhome/bin/scala
export PATH=$PATH:$SCALA_HOME/bin
export HADOOP_HOME/ddhome/bin/hadoop
export HADOOP_PREFIX=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
#export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_INSTALL=$HADOOP_HOME
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin

EOF
source /etc/profile

#----------------down tar -zxvf mv -------------------

echo " -----------------jdk------------------"
ls /ddhome/src | while read files;do
echo "==================$files======================="
#------------------maven---------------
	if [[ $files =~ 'maven' ]]; then
			echo "====================exeits the " ${files#*.tar}  
			tar -zxvf $files
			mv ${files#*.tar} maven
		elif [[ $files =~ 'zookeeper' ]]; then
			echo "====================exeits the " $files
			tar -zxvf $files
			mv ${files#*.tar} zookeeper
		elif [[ $files =~ 'hadoop' ]]; then
			echo "====================exeits the " $files
			tar -zxvf $files
			#mv ${files#*.tar} hadoop
		elif [[ $files =~ 'hbase' ]]; then
			echo "====================exeits the " $files
			tar -zxvf $files
				#mv ${files#*.tar} hbase
		elif [[ $files =~ 'hive' ]]; then
			echo "====================exeits the " $files
			tar -zxvf $files
			mv ${files#*.tar} hive
		elif [[ $files =~ 'spark' ]]
			then
			echo "====================exeits the " $files
			tar -zxvf $files
		else
			if [[ $files =~ 'maven' || ! -d 'maven' ]]; then
				wget http://mirrors.hust.edu.cn/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
				tar -zxvf apache-maven-3.6.0-bin.tar.gz
				mv apache-maven-3.6.0-bin maven
			fi
			if [[ $files =~ 'zookeeper' || ! -d 'zookeeper' ]]; then
				wget http://mirrors.hust.edu.cn/apache/zookeeper/zookeeper-3.4.13/zookeeper-3.4.13.tar.gz
				tar -zxvf zookeeper-3.4.13.tar.gz
				mv
			fi
			if [[ $files =~ 'hadoop' || ! -d 'hadoop' ]]; then
					wget http://mirrors.shu.edu.cn/apache/hadoop/common/hadoop-2.9.2/hadoop-2.9.2-src.tar.gz
					tar -zxvf hadoop-2.9.2-src.tar.gz
					wget http://mirrors.shu.edu.cn/apache/hadoop/common/hadoop-3.1.1/hadoop-3.1.1-src.tar.gz
					tar -zxvf hadoop-3.1.1-src.tar.gz
			fi
			if [[ $files =~ 'hbase' || ! -d 'hbase' ]]; then
					wget http://mirrors.shu.edu.cn/apache/hbase/2.1.1/hbase-2.1.1-bin.tar.gz
					tar -zxvf hbase-2.1.1-bin.tar.gz
					mv hbase-2.1.1-bin hbase
					wget http://mirrors.shu.edu.cn/apache/hbase/2.1.1/hbase-2.1.1-src.tar.gz
					tar -zxvf hbase-2.1.1-src.tar.gz
			fi
			if [[ $files =~ 'hive' || ! -d 'hive' ]]; then
				wget http://mirrors.shu.edu.cn/apache/hive/stable-2/apache-hive-2.3.4-bin.tar.gz
				tar -zxvf apache-hive-2.3.4-bin.tar.gz
				mv apache-hive-2.3.4-bin hive
			fi
			if [[ $files =~ 'spark' || ! -d 'spark' ]]; then
					wget http://mirrors.shu.edu.cn/apache/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz
					tar -zxvf spark-2.4.0-bin-hadoop2.7.tgz
					wget https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0.tgz
					tar -zxvf spark-2.4.0.tgz
			fi
		fi	
	#----------------down tar -zxvf mv -------------------
	echo "------------------maven---------------"
	echo "------------------maven---------------"
	echo "------------------maven---------------"
	echo "------------------maven---------------"
	echo "------------------maven---------------"
	echo "------------------maven---------------"
done

}


close_servers(){

#系统服务优化,可适当选择下列服务
SERVICES="acpid atd auditd avahi-daemon avahi-dnsconfd bluetooth conman cpuspeed cups dnsmasq dund firstboot hidd httpd ibmasm ip6tables irda kdump lm_sensors mcstrans messagebus microcode_ctl netconsole netfs netplugd nfs nfslock nscd oddjobd pand pcscd portmap psacct rdisc restorecond rpcgssd rpcidmapd rpcsvcgssd saslauthd sendmail setroubleshoot smb vncserver winbind wpa_supplicant ypbind"
for service in $SERVICES
do
#关闭所选服务随系统启动
systemctl disable $SERVICES
#停止所选的服务
syatemctl stop $SERVICES
done

echo "------------------优化完成--------------------"

}
main(){
    #修改字符集
    #sed -i 's/LANG="en_US.UTF-8"/LANG="zh_CN.UTF-8"/' /etc/locale.conf
    hostname_config
    yum_config
    yum_tools
    start_stop
    system_config
    ulimit_config
    sysctl_config
    ssh_config
    ntp_config
    zabbix_config
    update_kernel
    other_config
    dev_env_install
    close_servers
}
main