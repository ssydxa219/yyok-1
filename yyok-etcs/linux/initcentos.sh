#!/bin/sh
mkdir -p /ddhome/usr var bin sbin tmp etc src
basic_dir=/ddhome
bin_dir=$basic_dir/bin
usr_dir=$basic_dir/usr
var_dir=$basic_dir/var
sbin_dir=$basic_dir/sbin
tmp_dir=$basic_dir/tmp
etc_dir=$basic_dir/etc
src_dir=$basic_dir/src
systemctl status firewalld  > initcentos.log
systemctl disable firewalld
systemctl stop firewalld
systemctl status firewalld >> initcentos.log
yum install -y gcc gcc-c++ make automake wget ntp lrzsz ntpdate sysstat net-tools kde-l10n-Chinese glibc-common kernel-devel gcc-gfortran cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev libgnomeui-devel gtk2 gtk2-devel gtk2-devel-docs gnome-devel gnome-devel-docs 

gcc -v >> initcentos.log
g++ -v >> initcentos.log
fortran -v  >> initcentos.log
make -v >>initcentos.log
automake -v >>initcentos.log
cd  $src_dir
if [ ! -f "$src_dir/cmake-3.17.2.tar.gz" ];then
#echo "文件不存在"
wget https://cmake.org/files/v3.17/cmake-3.17.2.tar.gz
else
if [ ! -d "$bin_dir/cmake-3.17.2" ];then
tar -zxvf cmake-3.17.2.tar.gz -C $bin_dir
cd  $bin_dir/cmake-3.17.2
./bootstrap && make -j4 && sudo make install
cmake -v >>initcentos.log
echo "=======cmake-3.17.2 安装完成！！！！！！！" >> initcentos.log
else
echo "=======cmake-3.17.2 已安装！！！！！！" >> initcentos.log
fi
fi

ntpdate asia.pool.ntp.org
time.nist.gov
time.nuri.net
ntpdate asia.pool.ntp.org
date >> initcentos.log
timedatectl set-timezone Asia/Shanghai
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock
/etc/sysconfig/clock
#修改启动服务
#systemctl 是管制服务的主要工具,它整合了chkconfig 与 service功能于一体。
systemctl is-enabled iptables.service   #查询防火墙是否开机启动
systemctl restart sshd #有可能不需要加service
systemctl is-enabled servicename.service #查询服务是否开机启动
#systemctl enable *.service #开机运行服务
#systemctl disable *.service #取消开机运行
#systemctl start *.service #启动服务
#systemctl stop *.service #停止服务
#systemctl restart *.service #重启服务
#systemctl reload *.service #重新加载服务配置文件
#systemctl status *.service #查询服务运行状态
systemctl --failed >> initcentos.log #显示启动失败的服务
#定时自动清理 cat /var/spool/postfix/maildrop/目录垃圾文件，放置inode节点被占满
find/var/spool/clientmqueue/-typef -mtime +30|xargsrm-f
echo '*/30 * * * * /bin/sh /server/scripts/spool_clean.sh >/dev/null 2>&1' >> /var/spool/cron/root
#锁定关键文件系统,加锁，不可修改加锁文件
chattr +i /etc/passwd
lsattr /etc/passwd
#去锁，可以修改文件
#chattr -i /etc/passwd
#lsattr /etc/passwd 
#使用chattr命令后，为了安全我们需要将其改名
mv /usr/bin/chattr /usr/bin/chattrddhome
sed -i "1d" /etc/locale.conf
echo "LANG=\"zh_CN.UTF-8\"" >>/etc/locale.conf
cat /etc/redhat-release >> initcentos.log
source /etc/locale.conf
cd  $src_dir
tar -zxf protobuf-2.5.0.tar.gz
cd protobuf-2.5.0
./configure --prefix=$bin_dir/protobuf/
make && make install
echo "export PATH=$bin_dir/protobuf/:$PATH" >> /etc/profile
source /etc/profile
protoc --version >> initcentos.log
cd $src_dir
wget http://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz 
tar xvf pkg-config-0.29.2.tar.gz
cd pkg-config-0.29.2
./configure --prefix=$bin_dir/pkg --with-internal-glib
make && make instal
pkg-config --version >> initcentos.log
#ffmpeg组件安装
opencvs(){
#1、先安装epel扩展源 
yum -y install epel-release
 #2、安装其他扩展源 
yum localinstall –nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm 
yum localinstall –nogpgcheck https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm 
rpm –import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro 
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
#3、最后安装ffmpeg 
yum -y install ffmpeg ffmpeg-devel
#4、测试ffmpeg有没有安装成功 
ffmpeg -version
#编译源码ffmpeg

#1、下载：在官网上下载FFmpe源码包，解压;
 
#2、配置：生成makefile，具体如下：./configure --enable-libopencv --enable-swscale --enable-avresample--enable-gpl --enable-shared；
 
#3、编译：执行make –j8进行并行编译；
 
#4、安装：执行make install。
 
#5、添加ffmpeg到环境变量执行如下命令：
 
#PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
 
#export PKG_CONFIG_PATH
 
#备注：如果不执行，Opencv在cmake的时候不能找到对应的ffmpeg库
#4、安装opencv其他依赖项

yum -y install python-devel numpy
yum -y install libdc1394-devel
yum -y install libv4l-devel
yum -y install gstreamer-plugins-base-devel
#5 编译和安装opencv
#opencv源码编译和安装
cd opencv
mkdir build
cd build
cmake -D WITH_TBB=ON -D WITH_EIGEN=ON ..
cmake -D BUILD_DOCS=ON -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF ..
cmake -D WITH_OPENCL=OFF -D WITH_CUDA=OFF -D BUILD_opencv_gpu=OFF -D BUILD_opencv_gpuarithm=OFF -D BUILD_opencv_gpubgsegm=OFF -D BUILD_opencv_gpucodec=OFF -D BUILD_opencv_gpufeatures2d=OFF -D BUILD_opencv_gpufilters=OFF -D BUILD_opencv_gpuimgproc=OFF -D BUILD_opencv_gpulegacy=OFF -D BUILD_opencv_gpuoptflow=OFF -D BUILD_opencv_gpustereo=OFF -D BUILD_opencv_gpuwarping=OFF ..
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..

make && make install

}
