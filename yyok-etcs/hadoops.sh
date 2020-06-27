#!/bin/bash
#######Shell一键部署Hadoop集群说明手册v1.0.0########
####################################################本SHELL文件在$basic_host的$src_dir下#######################################
##前提要求1：打通ssh
##前提要求2：jdk1.8已经安装
##前提要求3：centos7 已经优化
##本文件和安装文件存放目录：src_dir

####################component 版本定义
    vjdk="jdk1.8.0_221-amd64"
    vscala="scala-2.11.12"
    vvscala="scala-2.11"
    vzk="apache-zookeeper-3.5.8-bin"
    vhadoop="hadoop-3.2.1"
    vhbase="hbase-2.2.4"
    vspark="spark-2.4.5-bin-3.4.5"
    vflink="flink-1.10.1"
    vkafka="kafka_2.11-2.3.1"
############1 文件目录定义
    basic_dir="/ddhome"
    module_dir="local var tmp"
    src_dir="$basic_dir/src"
    bin_dir="$basic_dir/bin"
    var_dir="$basic_dir/var"
    local_dir="$basic_dir/local"
    jdk_dir="/usr/java"
    zk_dir="$bin_dir/zookeeper"
    scala_dir="$bin_dir/scala"
    zk_data_dir="$local_dir/zookeeper"
    hadoop_dir="$bin_dir/hadoop"
    hadoop_data_dir="$local_dir/hadoop"
    hadoop_src_dir="$src_dir/$vhadoop-src/hadoop-dist/target"
    hbase_dir="$bin_dir/hbase"
    hbase_src_dir="$src_dir/$vhbase/hbase-assembly/target"
    spark_dir="$bin_dir/spark"
    spark_src_dir="$src_dir/spark-2.4.5"
    flink_dir="$bin_dir/flink"
    flink_src_dir="$src_dir/$vflink"
    kafka_dir="$bin_dir/kafka"
    kafka_src_dir="$src_dir/$vkafka"
####################component定义
    component_dir="zookeeper hadoop hbase flink kafka"
####################component 文件名定义
    fscala="$vscala.tgz"
    fzk="$vzk.tar.gz"
    fhadoop_bin="$vhadoop.tar.gz"
    fhbase_bin="$vhbase-bin.tar.gz"
    fspark_bin="$vspark.tgz"
    fflink_bin="$vflink-bin-scala_2.11.tgz"
    fkakfka_bin="kafka_2.11-2.3.1.tgz"
###################host name主机 资源存放主机
    basic_host="dda"
    all_hosts="dda ddb ddc ddd dde ddf ddg ddh"
    #########zk hosts主机
    zk_hosts="dda ddb ddc"
    zk_port="2181"
    zk_host_quorum="dda,ddb,ddc"
    zk_quorum="dda:2181,ddb:2181,ddc:2181"
###################hadoop name主机
    qjournal_hosts="dde:8485;ddf:8485;ddg:8485"
    #########hadoop journalnode hosts主机
    journalnode_hosts=('dde' 'ddf' 'ddg')
    #########hadoop cluster naem
    hadoop_cluster_name="yyok"
    #########hadoop name hosts主机
    hadoopname_host="dda"
    hadoopnameha_host="ddb"
    #########hadoop data host主机
    hadoopdata_hosts="ddc ddd dde ddf ddg ddh"
    #########hadoop yarn host主机
    resourcesmanager_host="ddc"
    resourcesmanagerha_host="ddd"
    yarn_name="yyok_yarn"
    nodemanager_hosts="dde ddf ddg ddh"
    #########hbase hosts masts主semaster_host机    
    hbasemaster_host="dda"
    hbasemasterha_host="ddb"
    #########hbase hosts regionservices
    regionserver_hosts="ddc ddd dde ddf ddg ddh"
    #########sparkhosts
    sparkmaster_host="dda"
    sparkmasterha_host="ddb"
    sparkwork_hosts="ddc ddd dde ddf ddg ddh"
    #########flinkhosts
    flinkmaster_host="dda"
    flinkmasterha_host="ddb"
    flink_works="ddc ddd dde ddf ddg ddh"

    #########kafka hosts
    kafka_broker_hosts="ddf ddg ddh"


    #########hive hosts
    hive_m=""
    hive_d=""

    #########hue hosts
###################host port
flinkmasterport=8081
###################sourcemanager#############################################
memorymb=10000
cpuvcores=16
minallocationmb=2000
maxallocationmb=10000
minallocationvcore=2
maxallocationvcore=8

###########################定义完完成  ###########################


############1.1 目录操作
function mkdir_dirs(){
  for hs in $all_hosts;do
    ssh $hs "mkdir $basic_dir/tmp && chmod -R 755 $basic_dir/tmp && exit;"
    for ms in $module_dir;do
     for cs in $component_dir;do
	dirc=$basic_dir/$ms/$cs 
	###############rm
	ssh $hs "rm -rf $dirc && mkdir -p  $dirc && chmod -R 755  $dirc && exit;" 
     done
   done
 done
}
########################################################################hostname


########################################################################net




########################################################################core


########################################################################yum update
function yumupdates(){
  for hs in $all_hosts;do
      ssh $hs "yum install -y libxml2-devel libxslt-devel python-devel python-setuptools python-simplejson sqlite-devel ant gmp-devel cyrus-sasl-plain cyrus-sasl-devel cyrus-sasl-gssapi libffi-devel libffi asciidoc ant gcc-c++ krb5-devel make openldap-devel cmake zlib* libssl* libsasl2-dev libgmp3-dev libkrb5-dev libffi-dev libmysqlclient-dev libssl-dev libsasl2-dev libsasl2-modules-gssapi-mit libsqlite3-dev libtidy-0.99-0 libxml2-dev libxslt-dev make libldap2-dev gcc gcc-c++ make automake redhat-lsb protobuf-devel build-essential autoconf automake libtool cmake zlib1g-dev pkg-config libssl-dev libsasl2-dev cyrus-sasl* libgsasl-devel* cmake zlib-devel openssl-devel snappy snappy-devel"
   done

}
########################################################################ssh 
function installssh(){

  for hs in $all_hosts;do
    ssh $hs "[ ! -f /root/.ssh/id_rsa.pub ] && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa &>/dev/null;cat /root/.ssh/id_rsa.pub && exit;"
   
 done

}
########################################################################jdk
function installenv(){
	echo "===========install jdk scala profile=========="

    for al in $all_hosts;do
        ssh $basic_host "scp -r ${src_dir}/jdk-8u221-linux-x64.rpm root@$al:$src_dir \
                        && scp -r ${src_dir}/$fscala root@$al:$src_dir \
                        && exit;"
                  ssh $al "tar -zxvf ${src_dir}/$fscala/ -C $bin_dir \
                    && rm -rf $bin_dir/scala \
                    && mv  $bin_dir/$vscala $bin_dir/scala \
                    && scp -r $bin_dir/scala root@$al:$src_dir \
                    && rpm -ih ${src_dir}/jdk-8u221-linux-x64.rpm && exit;"
                  ssh $al "! cat /etc/profile | grep \"JAVA_HOME\" && echo 'export JAVA_HOME=/usr/java/jdk1.8.0_221-amd64' >>/etc/profile \
                    && ! cat /etc/profile | grep \"CLASSPATH\" && echo 'export CLASSPATH=.:\$JAVA_HOME/jre/lib/rt.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar' >>/etc/profile \
                    && ! cat /etc/profile | grep \"JAVA_HOME\/bin\" && echo 'export PATH=\$PATH:\$JAVA_HOME/bin' >>/etc/profile \
                    && ! cat /etc/profile | grep \"SCALA_HOME\" && echo 'export SCALA_HOME=$bin_dir/scala' >>/etc/profile \
                    && ! cat /etc/profile | grep \"SCALA_HOME\/bin\" && echo 'export PATH=\$PATH:\$SCALA_HOME/bin' >>/etc/profile \
                    && ! cat /etc/profile | grep \"RUN_AS_USER\" && echo ' export RUN_AS_USER=root' >>/etc/profile \
                    && source /etc/profile && exit;"
           echo "===========================$al jdk install ok================="
    done
}


function installzk(){
########################################################################zk
  rm -rf "$zk_dir"
  rm -rf "$bin_dir/apache-zookeeper*"
  tar -zxvf $src_dir/$fzk -C $bin_dir
  cd $bin_dir
  mv $vzk zookeeper
  cp $zk_dir/conf/zoo_sample.cfg $zk_dir/conf/zoo.cfg
  sed -i "s/dataDir=\/tmp\/zookeeper/dataDir=\/ddhome\/local\/zookeeper\/data/g" $zk_dir/conf/zoo.cfg
  sed -i "s/\#maxClientCnxns=60/maxClientCnxns=6000/g" $zk_dir/conf/zoo.cfg
  for zk in $zk_hosts;do
    let n++
    ssh $basic_host "echo server.$n=$zk:2888:3888 >> $zk_dir/conf/zoo.cfg && exit;"
    ssh $zk "rm -rf $local_dir/zookeeper/* $var_dir/zookeeper/* && mkdir -p $local_dir/zookeeper/data/ && touch $local_dir/zookeeper/data/myid && echo $n > $local_dir/zookeeper/data/myid && cat $local_dir/zookeeper/data/myid && exit;"
  done

  for zk in $zk_hosts;do
    ssh $zk "! cat /etc/profile | grep \"ZOOKEEPER_HOME\" && echo 'export ZOOKEEPER_HOME=$bin_dir/zookeeper' >>/etc/profile \
          && ! cat /etc/profile | grep \"ZOOKEEPER_HOME\/bin\" && echo 'export PATH=\$PATH:\$ZOOKEEPER_HOME/bin' >>/etc/profile \
          && exit;"
   if [ $zk == $basic_host ];then
	echo "$zk == $basic_host"
     else
    ssh $zk "rm -rf $zk_dir && exit;"
    ssh $basic_host "scp -r $zk_dir root@$zk:$bin_dir && exit;"
    fi
    
    ssh $zk "chmod -R 755 $bin_dir && chmod -R 755 $local_dir && exit;"
## && $bin_dir/zookeeper/bin/zkServer.sh status && $bin_dir/zookeeper/bin/zkServer.sh start && exit;"
   done
}

function installhadoop(){
#####################################################################################hadoop
rm -rf "$hadoop_dir/"
tar -zxvf $hadoop_src_dir/$fhadoop_bin -C $bin_dir
mv $bin_dir/$vhadoop $hadoop_dir
grep "JAVA_HOME=\/usr\/java\/jdk1.8.0_221-amd64" $hadoop_dir/etc/hadoop/hadoop-env.sh > /dev/null
if [ $? -eq 0 ]; then
    echo "JAVA_HOME Found!"
else
############################ hadoop-env.sh ############################
   sed -i "55a export JAVA_HOME=/usr/java/jdk1.8.0_221-amd64" $hadoop_dir/etc/hadoop/hadoop-env.sh
   sed -i "58a export HADOOP_HOME=$hadoop_dir" $hadoop_dir/etc/hadoop/hadoop-env.sh
   sed -i "68a export HADOOP_CONF_DIR=\${HADOOP_HOME}/etc/hadoop" $hadoop_dir/etc/hadoop/hadoop-env.sh
   sed -i "75a export HADOOP_HEAPSIZE_MAX=4096" $hadoop_dir/etc/hadoop/hadoop-env.sh
   sed -i "82a export HADOOP_HEAPSIZE_MIN=1024" $hadoop_dir/etc/hadoop/hadoop-env.sh
  # sed -i "126a export HADOOP_CLASSPATH=\`hadoop classpath\`" $hadoop_dir/etc/hadoop/hadoop-env.sh
   sed -i "194a export HADOOP_LOG_DIR=${var_dir}/hadoop" $hadoop_dir/etc/hadoop/hadoop-env.sh
   #sed -i "205a export " $hadoop_dir/etc/hadoop/hadoop-env.sh
   echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\${HADOOP_HOME}/lib/native" >>$hadoop_dir/etc/hadoop/hadoop-env.sh
   echo "export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib:\$HADOOP_COMMON_LIB_NATIVE_DIR\"" >>$hadoop_dir/etc/hadoop/hadoop-env.sh
   echo "export HADOOP_PID_DIR=\${HADOOP_HOME}/tmp" >>$hadoop_dir/etc/hadoop/hadoop-env.sh
   echo "export HADOOP_SECURE_PID_DIR=\${HADOOP_HOME}/tmp" >>$hadoop_dir/etc/hadoop/hadoop-env.sh
############################ mapred-env.sh ############################
   sed -i "55a export JAVA_HOME=/usr/java/jdk1.8.0_221-amd64" $hadoop_dir/etc/hadoop/mapred-env.sh
   sed -i "31a export HADOOP_MAPRED_PID_DIR=$local_dir/tmp" $hadoop_dir/etc/hadoop/mapred-env.sh
   sed -i "30a export HADOOP_MAPRED_LOG_DIR=${var_dir}/hadoop" $hadoop_dir/etc/hadoop/mapred-env.sh
############################ yarn-env.sh ############################
   sed -i "27a export JAVA_HOME=/usr/java/jdk1.8.0_221-amd64" $hadoop_dir/etc/hadoop/yarn-env.sh
   sed -i "28a export HADOOP_YARN_HOME=$hadoop_dir" $hadoop_dir/etc/hadoop/yarn-env.sh
   sed -i "29a export YARN_HOME=$hadoop_dir" $hadoop_dir/etc/hadoop/yarn-env.sh
   sed -i "30a export HADOOP_CONF_DIR=$hadoop_dir/etc/hadoop" $hadoop_dir/etc/hadoop/yarn-env.sh
  # sed -i "31a export YARN_CONF_DIR=$hadoop_dir/etc/hadoop" $hadoop_dir/etc/hadoop/yarn-env.sh
   sed -i "32a export HDFS_CONF_DIR=$hadoop_dir/etc/hadoop" $hadoop_dir/etc/hadoop/yarn-env.sh
   sed -i "33a export HADOOP_PID_DIR=$hadoop_dir/tmp" $hadoop_dir/etc/hadoop/yarn-env.sh
  # echo "export YARN_PID_DIR=\${HADOOP_HOME}/tmp" >>$hadoop_dir/etc/hadoop/yarn-env.sh
########################### #workers  ############################
  sed -i '1d' $hadoop_dir/etc/hadoop/workers 
  for dns in $hadoopdata_hosts;do
     echo $dns >> $hadoop_dir/etc/hadoop/workers
  done

############################ core-site.xml ############################

    sed -i "19a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "20a <name>fs.defaultFS</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "21a <value>hdfs://$hadoop_cluster_name</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "22a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "23a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "24a <name>io.file.buffer.size</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "25a <value>1281072</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "26a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "27a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "28a <name>hadoop.tmp.dir</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "29a <value>$local_dir/hadoop/tmp</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "30a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "31a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "32a <name>dfs.journalnode.edits.dir</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "33a <value>$local_dir/hadoop/journalnode</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "34a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "35a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "36a <name>ha.zookeeper.quorum</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "37a <value>$zk_quorum</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "38a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "39a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "40a <name>ipc.client.connect.max.retrifairScheduler的调度方式es</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "41a <value>5000</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "42a <description>Indicates the number of retries a client will make to establish a server connection.</description>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "43a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "44a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "45a <name>ipc.client.connect.retry.interval</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "46a <value>10000</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "47a <description>Indicates the number of milliseconds a client will wait for before retrying to establish a server connection.</description>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "48a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "49a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "50a <name>hadoop.native.lib</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "51a <value>true</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "52a <description>Should native hadoop libraries, if present, be used.</description>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "53a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "54a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "55a <name>hadoop.proxyuser.hdfs.hosts</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "56a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "57a <description>Defines the Unix user, hdfs, that will run the HttpFS server as a proxyuser.</description>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "58a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "59a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "60a <name>hadoop.proxyuser.hdfs.groups</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "61a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "62a <description>Replaces hdfs with the Unix user that will start the HttpFS server.</description>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "63a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "64a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "65a <name>hadoop.proxyuser.root.hosts</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "66a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "67a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "68a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "69a <name>hadoop.proxyuser.root.groups</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "70a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "71a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "72a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "73a <name>hadoop.proxyuser.hive.hosts</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "74a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "75a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "76a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "77a <name>hadoop.proxyuser.hive.groups</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "78a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "79a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "80a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "81a <name>hadoop.proxyuser.admin.hosts</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "82a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "83a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "84a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "85a <name>hadoop.proxyuser.admin.groups</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "86a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "87a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "88a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "89a <name>hadoop.proxyuser.hue.hosts</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "90a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "91a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "92a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "93a <name>hadoop.proxyuser.hue.groups</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "94a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "95a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "96a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "97a <name>httpfs.proxyuser.hue.hosts</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "98a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "99a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "100a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "101a <name>httpfs.proxyuser.hue.groups</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "102a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "103a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "104a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "105a <name>hadoop.proxyuser.httpfs.hosts</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "106a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "107a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "108a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "109a <name>hadoop.proxyuser.httpfs.groups</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "110a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "111a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "112a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "113a <name>hadoop.proxyuser.superuser.hosts</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "114a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "115a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "116a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "117a <name>hadoop.proxyuser.superuser.groups</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "118a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "119a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "120a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "121a <name>hadoop.proxyuser.hbase.hosts</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "122a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "123a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "124a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "125a <name>hadoop.proxyuser.hbase.groups</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "126a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "127a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "128a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "129a <name>hadoop.proxyuser.oozie.hosts</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "130a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "131a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "132a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "133a <name>hadoop.proxyuser.oozie.groups</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "134a <value>*</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "135a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "136a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "137a <name>ha.zookeeper.session-timeout.ms</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "138a <value>30000</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "139a <description>ms</description>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "140a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "141a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "142a <name>fs.trash.interval</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "143a <value>10320</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "144a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "145a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "146a <name>fs.trash.checkpoint.interval</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "147a <value>10</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "148a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "149a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "150a <name>dfs.ha.fencing.methods</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "151a <value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "152a sshfence" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "153a shell(/bin/true)" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "154a </value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "155a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "156a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "157a <name>ha.zookeeper.quorum.hadoop-cluster</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "158a <value>$zk_quorum</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "159a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "160a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "161a <name>io.compression.codecs</name>>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "162a <value>org.apache.hadoop.io.compress.GzipCodec," $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "163a org.apache.hadoop.io.compress.DefaultCodec," $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "164a org.apache.hadoop.io.compress.BZip2Codec," $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "165a org.apache.hadoop.io.compress.SnappyCodec" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "166a </value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "167a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "168a <!--开启map阶段文件压缩-->" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "169a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "170a <name>mapreduce.map.output.compress</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "171a <value>true</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "172a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "173a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "174a <name>mapreduce.map.output.compress.codec</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "175a <value>org.apache.hadoop.io.compress.SnappyCodec</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "176a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "177a <!--开启MapReduce输出文件压缩-->" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "178a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "179a <name>mapreduce.output.fileoutputformat.compress</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "180a <value>true</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "181a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "182a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "183a <name>mapreduce.output.fileoutputformat.compress.codec</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "184a <value>org.apache.hadoop.io.compress.BZip2Codec</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "185a </property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "186a <property>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "187a <name>topology.script.file.name</name>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "188a <value>$hadoop_dir/etc/hadoop/racks.sh</value>" $hadoop_dir/etc/hadoop/core-site.xml
    sed -i "189a </property>" $hadoop_dir/etc/hadoop/core-site.xml

 #echo "</configuration>" >>$hadoop_dir/etc/hadoop/core-site.xml

#################### hdfs-site.xml ############################
    sed -i '21d' $hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.nameservices</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>${hadoop_cluster_name}</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.ha.automatic-failover.enabled.appcluster</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.ha.namenodes.${hadoop_cluster_name}</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>nna,nnb</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.namenode.rpc-address.${hadoop_cluster_name}.nna</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>${hadoopname_host}:9000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.namenode.rpc-address.${hadoop_cluster_name}.nnb</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>${hadoopnameha_host}:9000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.namenode.http-address.${hadoop_cluster_name}.nna</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>${hadoopname_host}:50070</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.namenode.http-address.${hadoop_cluster_name}.nnb</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>${hadoopnameha_host}:50070</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.namenode.shared.edits.dir</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>qjournal://${qjournal_hosts}/${hadoop_cluster_name}</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.journalnode.edits.dir</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>$local_dir/hadoop/journal</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.ha.automatic-failover.enabled</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.client.failover.proxy.provider.${hadoop_cluster_name}</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.ha.fencing.methods</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "sshfence" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "shell(/bin/true)" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.ha.fencing.ssh.private-key-files</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>/root/.ssh/id_rsa</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.namenode.name.dir</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>$local_dir/hadoop/name</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.blocksize</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>256000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.namenode.handler.count</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>10000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.datanode.handler.count</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>10000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.datanode.data.dir</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>$local_dir/hadoop/data</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.replication</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>3</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.permissions</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>false</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.webhdfs.enabled</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>ha.zookeeper.quorum</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>${zk_quorum}</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.qjournal.start-segment.timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>600000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo " <property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo " <name>dfs.qjournal.prepare-recovery.timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo " <value>600000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo " </property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.qjournal.accept-recovery.timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>600000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo " <property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo " <name>dfs.qjournal.prepare-recovery.timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo " <value>600000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.qjournal.accept-recovery.timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo " <value>600000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.qjournal.finalize-segment.timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>600000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.qjournal.select-input-streams.timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>600000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.qjournal.get-journal-state.timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>600000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.qjournal.new-epoch.timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>600000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.qjournal.write-txns.timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>600000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.permissions.enabled</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>false</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.support.append</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.balance.bandwidthPerSec</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>3000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.ha.fencing.ssh.connect-timeout</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>60000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>ha.failover-controller.cli-check.rpc-timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>60000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.client.file-block-storage-locations.timeout.millis</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>10000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.client.read.shortcircuit.skip.checksum</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>false</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.datanode.hdfs-blocks-metadata.enabled</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.client.use.legacy.blockreader.local</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>false</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.datanode.data.dir.perm</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>755</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.client.read.shortcircuit</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.client.use.legacy.blockreader.local</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.datanode.data.dir.perm</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>750</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.block.local-path-access.user</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>root,hadoop</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.client.file-block-storage-locations.timeout</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>300000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.datanode.balance.bandwidthPerSec</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>1500457860</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>hadoop.native.lib</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<description>Should nativehadoop libraries, if present, be used.</description>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.datanode.max.transfer.threads</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>8192</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.datanode.max.xcievers</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>4096</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</configuration>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml

############################ mapred-site.xml ############################
    sed -i '21d' $hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.framework.name</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>yarn</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.jobhistory.address</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>$resourcesmanager_host:10020</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.jobhistory.webapp.address</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>$resourcesmanager_host:19888</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.application.classpath</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "$hadoop_dir/etc/hadoop:" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "$hadoop_dir/share/hadoop/common/*:" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "$hadoop_dir/share/hadoop/common/lib/*:" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "$hadoop_dir/share/hadoop/hdfs/*:" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "$hadoop_dir/share/hadoop/hdfs/lib/*:" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "$hadoop_dir/share/hadoop/mapreduce/*:" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "$hadoop_dir/share/hadoop/mapreduce/lib/*:" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "$hadoop_dir/share/hadoop/yarn/*:" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "$hadoop_dir/share/hadoop/yarn/lib/*" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.jobhistory.done-dir</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>$local_dir/hadoop/yarn/history/done</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.jobhistory.intermediate-done-dir</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>$local_dir/hadoop/yarn/history/done_intermediate</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.reduce.shuffle.parallelcopies</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>10</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.map.memory.mb</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>5000</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<description>每个Map任务的物理内存限制</description>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.reduce.memory.mb</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>5000</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<description>每个Reduce任务的物理内存限制</description>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.map.java.opts</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>-Xmx5000M</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.reduce.java.opts</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>-Xmx5000M</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapred.child.env</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>LD_LIBRARY_PATH=$hadoop_dir/lzo/lib</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.cluster.acls.enabled</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>yarn.app.mapreduce.am.env</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>HADOOP_MAPRED_HOME=\$HADOOP_HOME</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.map.env</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>HADOOP_MAPRED_HOME=\$HADOOP_HOME</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.reduce.env</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>HADOOP_MAPRED_HOME=\$HADOOP_HOME</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</configuration>" >>$hadoop_dir/etc/hadoop/mapred-site.xml

############################ yarn-site.xml ############################
    sed -i '19d' $hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.ha.enabled</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.cluster-id</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${yarn_name}</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.ha.rm-ids</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>rma,rmb</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.hostname.rma</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanager_host}</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.hostname.rmb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanagerha_host}</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.webapp.address.rma</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanager_host}:8088</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.webapp.address.rmb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanagerha_host}:8088</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>ha.zookeeper.quorum</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${zk_quorum}</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.zk-address</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${zk_quorum}</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.zk-state-store.address</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${zk_quorum}</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo " <name>hadoop.zk.address</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${zk_quorum}</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!--org.apache.hadoop.yarn.server.resourcemanager.recovery.FileSystemRMStateStore,ZKRMStateStore  -->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.store.class</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.yarn.server.resourcemanager.recovery.ZKRMStateStore</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.connect.retry-interval.ms</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>20000</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.app.mapreduce.am.scheduler.connection.wait.interval-ms</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>50000</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.recovery.enabled</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.ha.automatic-failover.enabled</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.client.failover-proxy-provider</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.yarn.client.ConfiguredRMFailoverProxyProvider</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.ha.automatic-failover.zk-base-path</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${local_dir}/hadoop/yarn-leader-election</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.aux-services</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>mapreduce_shuffle,spark_shuffle</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.mapred.ShuffleHandler</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!-- spark on yarn 动态资源分配调度模型类  -->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.aux-services.spark_shuffle.class</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.spark.network.yarn.YarnShuffleService</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!-- spark on yarn 动态资源分配服务接口  -->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>spark.shuffle.service.port</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>6066</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.local-dirs</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${local_dir}/hadoop/yarn</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.log-dirs</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${var_dir}/hadoop/log</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.application.classpath</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "$hadoop_dir/etc/hadoop," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "$hadoop_dir/share/hadoop/common/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "$hadoop_dir/share/hadoop/common/lib/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "$hadoop_dir/share/hadoop/hdfs/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "$hadoop_dir/share/hadoop/hdfs/lib/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "$hadoop_dir/share/hadoop/mapreduce/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "$hadoop_dir/share/hadoop/mapreduce/lib/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "$hadoop_dir/share/hadoop/yarn/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "$hadoop_dir/share/hadoop/yarn/lib/*" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.minimum-allocation-mb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>$minallocationmb</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.maximum-allocation-mb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>$maxallocationmb</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>Amount of physical memory, in MB, that can be allocated for containers.</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.resource.memory-mb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>$memorymb</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>允许的虚拟内存倍数 .Ratio between virtual memory to physical memory when" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "setting memory limits for containers. Container allocations are" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "expressed in terms of physical memory, and virtual memory usage" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "is allowed to exceed this allocation by this ratio." >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.vmem-pmem-ratio</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>4.2</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.resource.cpu-vcores</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>$cpuvcores</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!-- 开启mapreduce中间过程压缩  -->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.map.output.compress</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.map.output.compress.codec</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.io.compress.SnappyCodec</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.output.fileoutputformat.compress</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.output.fileoutputformat.compress.codec</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.io.compress.SnappyCodec</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>数据的压缩类型,这里使用Snappy压缩</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.output.fileoutputformat.compress.type</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>BLOCK</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>数据的压缩级别,这里设置按数据块压缩</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.timeline-service.enabled</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>false</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.log-aggregation-enable</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.log-aggregation.retain-seconds</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>259200</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>设置聚合日志保存时间3天</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.log-aggregation.retain-check-interval-seconds</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>86400</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>清理过期聚合日志程序的执行间隔时间</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.remote-app-log-dir</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${var_dir}/hadoop</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>聚合日志在hdfs上的目录</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!--<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.remote-app-log-dir-suffix</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>logs</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>聚合日志在hdfs上的目录分层方式</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>-->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.log.server.url</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>http://${resourcesmanager_host}:19888/jobhistory/logs</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>历史日志对应路径</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo " <name>yarn.nodemanager.resource.detect-hardware-capabilities</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!-- 开启容量调度模式 -->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.scheduler.class</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>配置yarn启用容量调度模式(默认即是容量调度),配置文件为capacity-scheduler.xml</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!--  指定我们的任务调度使用fairScheduler的调度方式-->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!--" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.scheduler.class</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.allocation.file</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${bin_dir}/hadoop/etc/hadoop/fair-scheduler.xml</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.sizebasedweight</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>false</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.preemption</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>是否启用资源抢占，如果启用，那么当该队列资源使用 yarn.scheduler.fair.preemption.cluster-utilization-threshold 这么多比例的时候，就从其他空闲队列抢占资源</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.preemption.cluster-utilization-threshold</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>0.8f</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.user-as-default-queue</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>false</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>默认提交到default队列,default is True</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.allow-undeclared-pools</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>false</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>如果提交一个任务没有到任何的队列，是否允许创建一个新的队列，设置false不允许,default is True</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "-->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.scheduler.monitor.enable</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.minimum-allocation-vcores</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>$minallocationvcore</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.maximum-allocation-vcores</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>$maxallocationvcore</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.map.memory.mb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>5098</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.reduce.memory.mb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>5098</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.map.java.opts</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>-Xmx5098m</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.reduce.java.opts</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>-Xmx5098m</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
   echo "<!--多租户配置，新增，用于队列的权限管理，和mapred-site.xml配置文件配合使用，例如不同租户不能随意kill任务，只能kill属于自己的队列任务，超级用户除外-->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.acl.enable</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.admin.acl</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>root</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</configuration>" >>$hadoop_dir/etc/hadoop/yarn-site.xml

########################racks.sh ############################
    rm -rf $hadoop_dir/etc/hadoop/racks.sh
    touch $hadoop_dir/etc/hadoop/racks.sh
    echo "#!/bin/bash" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "HADOOP_CONF_DIR=$hadoop_dir/etc/hadoop" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "while [ $# -gt 0 ] ; do" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "  nodeArg=\$1" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "  exec<\$HADOOP_CONF_DIR/racks.data" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "  result=\"\"" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "  while read line ; do" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "    ar=( \$line )" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "    if [ "\${ar[0]}" = \"$nodeArg\" ]||[ \"\${ar[1]}\" = \"\$nodeArg\" ]; then" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "      result=\"\${ar[2]}\"" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "    fi" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "  done" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "  shift" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "  if [ -z \"\$result\" ] ; then" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "    echo -n \"/default-rack\"" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "  else" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "    echo -n \"$result\"" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "  fi" >>$hadoop_dir/etc/hadoop/racks.sh
    echo "done" >>$hadoop_dir/etc/hadoop/racks.sh
    chmod -R $hadoop_dir/etc/hadoop/racks.sh
############################racks.data############################
#############格式为：节点（ip或主机名） /交换机xx/机架xx#########
#192.168.147.91 tbe192168147091 /dc1/rack1
 touch $hadoop_dir/etc/hadoop/racks.data
 for ah in $all_hosts;do
   cat /etc/hosts | while read line;do
    if [[ $line =~ $ah ]];then
     echo "$line /yyoka/rack$ah" >> $hadoop_dir/etc/hadoop/racks.data
    fi
   done
 done
 ###################### fair-scheduler.xml ############################
    rm -rf $hadoop_dir/etc/hadoop/fair-scheduler.xml
    touch $hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<allocations>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"root\">" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"default\">" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclSubmitApps>*</aclSubmitApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<minResources>10000 mb, 10vcores</minResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclAdministerApps>*</aclAdministerApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<weight>1</weight>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxRunningApps>10</maxRunningApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxAMShare>0.5</maxAMShare>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxResources>200000 mb, 80vcores</maxResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "</queue>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"prod\">" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<weight>40</weight>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<schedulingPolicy>fifo</schedulingPolicy>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "</queue>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"dev\">" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<weight>60</weight>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"eng\"/>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"science\"/>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "</queue>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"hdfs\">" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<schedulingPolicy>fair</schedulingPolicy>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclSubmitApps>*</aclSubmitApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclAdministerApps>*</aclAdministerApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<weight>8</weight>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxAMShare>0.5</maxAMShare>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<minResources>10000 mb, 10vcores</minResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxResources>190000 mb, 60vcores</maxResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxRunningApps>50</maxRunningApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "</queue>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"spark\">" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<schedulingPolicy>fair</schedulingPolicy>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclSubmitApps>*</aclSubmitApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclAdministerApps>*</aclAdministerApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<weight>6</weight>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxAMShare>0.8</maxAMShare>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<minResources>10000 mb, 10vcores</minResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxResources>200000 mb, 50vcores</maxResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxRunningApps>30</maxRunningApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "</queue>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"dailys\">" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<schedulingPolicy>fair</schedulingPolicy>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclSubmitApps>*</aclSubmitApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclAdministerApps>*</aclAdministerApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<weight>6</weight>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<minResources>10000 mb, 10vcores</minResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxResources>200000 mb, 80vcores</maxResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxRunningApps>20</maxRunningApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "</queue>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"weeks\">" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<weight>8</weight>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<minResources>10000 mb, 10vcores</minResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxResources>130000 mb, 45vcores</maxResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxRunningApps>20</maxRunningApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxAMShare>0.5</maxAMShare>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<schedulingPolicy>fair</schedulingPolicy>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclSubmitApps>*</aclSubmitApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclAdministerApps>*</aclAdministerApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "</queue>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"months\">" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<weight>8</weight>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<minResources>10000 mb, 10vcores</minResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxResources>130000 mb, 45vcores</maxResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxRunningApps>20</maxRunningApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "</queue>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queue name=\"flink\">" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<schedulingPolicy>fair</schedulingPolicy>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclSubmitApps>*</aclSubmitApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<aclAdministerApps>*</aclAdministerApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<weight>8</weight>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<minResources>100000 mb, 50vcores</minResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxResources>500000 mb, 150vcores</maxResources>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxRunningApps>50</maxRunningApps>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<maxAMShare>0.5</maxAMShare>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<schedulingPolicy>fair</schedulingPolicy>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "</queue>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "</queue>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<defaultQueueSchedulingPolicy>fair</defaultQueueSchedulingPolicy>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<userMaxAppsDefault>50</userMaxAppsDefault>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queueMaxAppsDefault>50</queueMaxAppsDefault>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<queueMaxAMShareDefault>0.5</queueMaxAMShareDefault>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<defaultFairSharePreemptionThreshold>0.5</defaultFairSharePreemptionThreshold>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<defaultFairSharePreemptionTimeout>9223372036854775807</defaultFairSharePreemptionTimeout>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "<defaultMinSharePreemptionTimeout>9223372036854775807</defaultMinSharePreemptionTimeout>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml
    echo "</allocations>" >>$hadoop_dir/etc/hadoop/fair-scheduler.xml

############################ sbin/start-dfs.sh ############################
    sed -i "22a HDFS_DATANODE_USER=\"root\"" $hadoop_dir/sbin/start-dfs.sh
    sed -i "23a HDFS_DATANODE_SECURE_USER=\"hdfs\"" $hadoop_dir/sbin/start-dfs.sh
    sed -i "24a HDFS_NAMENODE_USER=\"root\"" $hadoop_dir/sbin/start-dfs.sh
    sed -i "25a HDFS_SECONDARYNAMENODE_USER=\"root\"" $hadoop_dir/sbin/start-dfs.sh
    sed -i "26a HDFS_JOURNALNODE_USER=\"root\"" $hadoop_dir/sbin/start-dfs.sh
    sed -i "27a HDFS_ZKFC_USER=\"root\"" $hadoop_dir/sbin/start-dfs.sh
############################ sbin/stop-dfs.sh ############################
    sed -i "22a HDFS_DATANODE_USER=\"root\"" $hadoop_dir/sbin/stop-dfs.sh
    sed -i "23a HDFS_DATANODE_SECURE_USER=\"hdfs\"" $hadoop_dir/sbin/stop-dfs.sh
    sed -i "24a HDFS_NAMENODE_USER=\"root\"" $hadoop_dir/sbin/stop-dfs.sh
    sed -i "25a HDFS_SECONDARYNAMENODE_USER=\"root\"" $hadoop_dir/sbin/stop-dfs.sh
    sed -i "26a HDFS_JOURNALNODE_USER=\"root\"" $hadoop_dir/sbin/stop-dfs.sh
    sed -i "27a HDFS_ZKFC_USER=\"root\"" $hadoop_dir/sbin/stop-dfs.sh
############################ start-yarn.sh ############################
    sed -i "17a YARN_RESOURCEMANAGER_USER=\"root\"" $hadoop_dir/sbin/start-yarn.sh
    sed -i "18a HDFS_DATANODE_SECURE_USER=\"root\"" $hadoop_dir/sbin/start-yarn.sh
    sed -i "19a YARN_NODEMANAGER_USER=\"root\"" $hadoop_dir/sbin/start-yarn.sh
    sed -i "20a YARN_PROXYSERVER_USER=\"root\"" $hadoop_dir/sbin/start-yarn.sh
############################ stop-yarn.sh ############################
    sed -i "17a YARN_RESOURCEMANAGER_USER=\"root\"" $hadoop_dir/sbin/stop-yarn.sh
    sed -i "18a HDFS_DATANODE_SECURE_USER=\"root\"" $hadoop_dir/sbin/stop-yarn.sh
    sed -i "19a YARN_NODEMANAGER_USER=\"root\"" $hadoop_dir/sbin/stop-yarn.sh
    sed -i "20a YARN_PROXYSERVER_USER=\"root\"" $hadoop_dir/sbin/stop-yarn.sh
#echo "======================================================"
    rm -rf  $local_dir/hadoop
    mkdir -p $local_dir/hadoop/tmp $local_dir/hadoop/name $local_dir/hadoop/data $local_dir/hadoop/journalnode $hadoop_dir/tmp $local_dir/hadoop/journal/$hadoop_cluster_name
   
   echo "===========================HADOOP install ok================="
fi

 echo "===========================HADOOP $hadoopname_host etc profile add the HADOOP ================="
      ssh $hadoopname_host "chmod -R 755 $hadoop_dir/etc/hadoop/racks.sh && ntpdate time.nist.gov \
    && ! cat /etc/profile | grep \"HADOOP_HOME\" && echo 'export HADOOP_HOME=$bin_dir/hadoop' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_HDFS_HOME\" && echo 'export HADOOP_HDFS_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_MAPRED_HOME\" && echo 'export HADOOP_MAPRED_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_COMMON_HOME\" && echo 'export HADOOP_COMMON_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"YARN_HOME\" && echo 'export YARN_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_CONF_DIR\" && echo 'export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop' >>/etc/profile \
    && ! cat /etc/profile | grep \"HDFS_CONF_DIR\" && echo 'export HDFS_CONF_DIR=\$HADOOP_HOME/etc/hadoop' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_PID_DIR\" && echo 'export HADOOP_PID_DIR=\$HADOOP_HOME/tmp' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_COMMON_LIB_NATIVE_DIR\" && echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_OPTS\" && echo 'export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib:\$HADOOP_COMMON_LIB_NATIVE_DIR\"' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_HOME\/sbin\" && echo 'export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin' >>/etc/profile \
    && ! cat /etc/profile | grep \"LD_LIBRARY_PATH\" && echo 'export LD_LIBRARY_PATH=\$JAVA_HOME/jre/lib/amd64/server:/usr/local/lib:$hadoop_dir/lib/native' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_CLASSPATH\" && echo 'export HADOOP_CLASSPATH=\`hadoop classpath\`' >>/etc/profile \
    && source /etc/profile && exit;"

 echo "===========================HADOOP $hadoopnameha_host etc profile add the HADOOP ================="
    cp $spark_src_dir/common/network-yarn/target/$vvscala/spark-2.4.5-yarn-shuffle.jar   $hadoop_dir/share/hadoop/yarn/
    ssh $hadoopnameha_host "ntpdate time.nist.gov \
    && ! cat /etc/profile | grep \"HADOOP_HOME\" && echo 'export HADOOP_HOME=$bin_dir/hadoop' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_HDFS_HOME\" && echo 'export HADOOP_HDFS_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_MAPRED_HOME\" && echo 'export HADOOP_MAPRED_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_COMMON_HOME\" && echo 'export HADOOP_COMMON_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"YARN_HOME\" && echo 'export YARN_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_CONF_DIR\" && echo 'export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop' >>/etc/profile \
    && ! cat /etc/profile | grep \"HDFS_CONF_DIR\" && echo 'export HDFS_CONF_DIR=\$HADOOP_HOME/etc/hadoop' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_PID_DIR\" && echo 'export HADOOP_PID_DIR=\$HADOOP_HOME/tmp' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_COMMON_LIB_NATIVE_DIR\" && echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_OPTS\" && echo 'export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib:\$HADOOP_COMMON_LIB_NATIVE_DIR\"' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_HOME\/sbin\" && echo 'export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin' >>/etc/profile \
    && ! cat /etc/profile | grep \"LD_LIBRARY_PATH\" && echo ' export LD_LIBRARY_PATH=\$JAVA_HOME/jre/lib/amd64/server:/usr/local/lib:$hadoop_dir/lib/native' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_CLASSPATH\" && echo 'export HADOOP_CLASSPATH=`hadoop classpath`' >>/etc/profile \
    && source /etc/profile && rm -rf $hadoop_dir $var_dir/hadoop/* $local_dir/hadoop/* &&mkdir -p $local_dir/hadoop/tmp $local_dir/hadoop/name $local_dir/hadoop/data $local_dir/hadoop/journalnode $hadoop_dir/tmp && exit;"
    scp -r $hadoop_dir root@$hadoopnameha_host:$bin_dir;
      for scps in $hadoopdata_hosts;do
       if [ $scps == $basic_host ];then
            echo "$scps == $basic_host"
         else
            ssh $scps "ntpdate time.nist.gov \
                && ! cat /etc/profile | grep \"HADOOP_HOME\" && echo 'export HADOOP_HOME=$bin_dir/hadoop' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_HDFS_HOME\" && echo 'export HADOOP_HDFS_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_MAPRED_HOME\" && echo 'export HADOOP_MAPRED_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_COMMON_HOME\" && echo 'export HADOOP_COMMON_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"YARN_HOME\" && echo 'export YARN_HOME=\$HADOOP_HOME' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_CONF_DIR\" && echo 'export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop' >>/etc/profile \
    && ! cat /etc/profile | grep \"HDFS_CONF_DIR\" && echo 'export HDFS_CONF_DIR=\$HADOOP_HOME/etc/hadoop' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_PID_DIR\" && echo 'export HADOOP_PID_DIR=\$HADOOP_HOME/tmp' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_COMMON_LIB_NATIVE_DIR\" && echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_OPTS\" && echo 'export HADOOP_OPTS=\"-Djava.library.path=\$HADOOP_HOME/lib:\$HADOOP_COMMON_LIB_NATIVE_DIR\"' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_HOME\/sbin\" && echo 'export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin' >>/etc/profile \
    && ! cat /etc/profile | grep \"LD_LIBRARY_PATH\" && echo ' export LD_LIBRARY_PATH=\$JAVA_HOME/jre/lib/amd64/server:/usr/local/lib:$hadoop_dir/lib/native' >>/etc/profile \
    && ! cat /etc/profile | grep \"HADOOP_CLASSPATH\" && echo 'export HADOOP_CLASSPATH=`hadoop classpath`' >>/etc/profile \ 
    && source /etc/profile && rm -rf $hadoop_dir $local_dir/hadoop/* $var_dir/hadoop/* && mkdir -p $local_dir/hadoop/tmp $local_dir/hadoop/name $local_dir/hadoop/data $local_dir/hadoop/journalnode $hadoop_dir/tmp && chmod -R 755 $basic_dir && exit;"
    scp -r $hadoop_dir root@$scps:$bin_dir;
            echo "===========================$scps HADOOP install ok================="
        fi
    done
################################################################################################hbase
}

################################################################################################h
function installhbase(){
rm -rf  $hbase_dir 
rm -rf $local_dir/hbase 
rm -fr $var_dir/hbase
mkdir -p $local_dir/hbase/tmp $var_dir/hbase
echo "===========install hbase=========="
#if [ ! -f $hbase_src_dir/$fhbase_bin ];then
#wget https://mirrors.tuna.tsinghua.edu.cn/apache/hbase/stable/$vhbase-bin.tar.gz
#mkdir -p $hbase_src_dir
#cp $vhbase-bin.tar.gz $hbase_src_dir
#fi
tar -zxvf $hbase_src_dir/$fhbase_bin -C $bin_dir/
mv $bin_dir/$vhbase $bin_dir/hbase
touch $hbase_dir/conf/backup-masters
    sed -i '1d' $hbase_dir/conf/regionservers
echo "${hbasemasterha_host}" >> $hbase_dir/conf/backup-masters
 for regs in $regionserver_hosts;do
    echo "$regs" >> $hbase_dir/conf/regionservers
 done
    sed -i "25a export HADOOP_HOME=$hadoop_dir" $hbase_dir/conf/hbase-env.sh
    sed -i "26a export HBASE_HOME=$hbase_dir" $hbase_dir/conf/hbase-env.sh
    sed -i "29a export JAVA_HOME=$jdk_dir/$vjdk" $hbase_dir/conf/hbase-env.sh
    sed -i "32a export HBASE_CLASSPATH=$hadoop_dir/etc/hadoop" $hbase_dir/conf/hbase-env.sh
    sed -i "39a export HBASE_HEAPSIZE=5G" $hbase_dir/conf/hbase-env.sh
    sed -i "46d" $hbase_dir/conf/hbase-env.sh
    sed -i "47d" $hbase_dir/conf/hbase-env.sh
   # sed -i "48a export HBASE_OPTS=\" -Xmx5g -Xms5g -Xmn512m -Xss256k -XX:SurvivorRatio=2 -XX:MaxTenuringThreshold=15 -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSInitiatingOccupancyOnly -XX:-DisableExplicitGC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -XX:+PrintTenuringDistribution -Xloggc:$var_dir/hbase/gc.log\"" $hbase_dir/conf/hbase-env.sh
   sed -i "48a export HBASE_OPTS=\"$HBASE_OPTS -Xmx3g -Xms3g -Xmn512m -Xss256k -XX:SurvivorRatio=2 -XX:MaxTenuringThreshold=15 -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:-DisableExplicitGC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -XX:+PrintTenuringDistribution -Xloggc:$var_dir/hbase/gc.log\"" $hbase_dir/conf/hbase-env.sh
    sed -i "103a export HBASE_LOG_DIR=${var_dir}/hbase" $hbase_dir/conf/hbase-env.sh
    sed -i "119a export HBASE_PID_DIR=$local_dir/hbase" $hbase_dir/conf/hbase-env.sh
    sed -i "127a export HBASE_MANAGES_ZK=false" $hbase_dir/conf/hbase-env.sh
   # echo "export HBASE_MASTER_OPTS=\"\$HBASE_MASTER_OPTS -XX:PermSize=128m -XX:MaxPermSize=128m\"" >>$hbase_dir/conf/hbase-env.sh
   # echo "export HBASE_REGIONSERVER_OPTS=\"\$HBASE_REGIONSERVER_OPTS -XX:PermSize=128m -XX:MaxPermSize=128m\"" >>$hbase_dir/conf/hbase-env.sh
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HADOOP_HOME/lib/native/Linux-amd64-64/" >>$hbase_dir/conf/hbase-env.sh
    echo "export HBASE_LIBRARY_PATH=\$HBASE_LIBRARY_PATH:\$HBASE_HOME/lib/native/Linux-amd64-64/" >>$hbase_dir/conf/hbase-env.sh
    echo "export HBASE_MASTER_OPTS=\"\$HBASE_MASTER_OPTS \$HBASE_JMX_BASE -Xmx2g -Xms2g -Xmn750m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70\"" >>$hbase_dir/conf/hbase-env.sh
    echo "export HBASE_REGIONSERVER_OPTS=\"\$HBASE_REGIONSERVER_OPTS \$HBASE_JMX_BASE -Xmx5g -Xms5g -Xmn1g -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70\"" >>$hbase_dir/conf/hbase-env.sh
    sed -i '24d' $hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.rootdir</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>hdfs://$hadoop_cluster_name/hbase</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.cluster.distributed</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>true</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.master.info.port</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>60010</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.zookeeper.quorum</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>$zk_host_quorum</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.zookeeper.property.dataDir</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>$local_dir/zookeeper/data</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>dfs.support.append</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>true</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.coprocessor.abortonerror</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>false</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>zookeeper.session.timeout</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>90000</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.zookeeper.property.clientPort</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>$zk_port</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.master.maxclockskew</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>180000</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.regionserver.handler.count</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>100000000</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.master</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>60000</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.tmp.dir</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>$local_dir/hbase/tmp</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<property>" >>$hbase_dir/conf/hbase-site.xml
    echo "<name>hbase.unsafe.stream.capability.enforce</name>" >>$hbase_dir/conf/hbase-site.xml
    echo "<value>false</value>" >>$hbase_dir/conf/hbase-site.xml
    echo "</property>" >>$hbase_dir/conf/hbase-site.xml
    echo "</configuration>" >>$hbase_dir/conf/hbase-site.xml
    mkdir -p $local_dir/hbase/tmp
    # cp $bin_dir/hbase/lib/client-facing-thirdparty/htrace-core4-4.2.0-incubating.jar $bin_dir/hbase/lib
    ssh $hbasemaster_host "! cat /etc/profile | grep \"HBASE_HOME=\" && echo 'export HBASE_HOME=$bin_dir/hbase' >>/etc/profile \
                           && ! cat /etc/profile | grep \"HBASE_HOME\/bin\" && echo 'export PATH=\$PATH:\$HBASE_HOME/bin' >>/etc/profile \
         		   && ! cat /etc/profile | grep \"HBASE_LOG_DIR\" && echo 'export HBASE_LOG_DIR=\$HBASE_HOME/hbase/log' >>/etc/profile \
  			   && source /etc/profile && exit;
                           "
    ssh $hbasemasterha_host "! cat /etc/profile | grep \"HBASE_HOME=\" && echo 'export HBASE_HOME=$bin_dir/hbase' >>/etc/profile \
                           && ! cat /etc/profile | grep \"HBASE_HOME\/bin\" && echo 'export PATH=\$PATH:\$HBASE_HOME/bin' >>/etc/profile \
                           && ! cat /etc/profile | grep \"HBASE_LOG_DIR\" && echo 'export HBASE_LOG_DIR=\$HBASE_HOME/hbase/log' >>/etc/profile \
                           && source /etc/profile && exit;
                           "
    scp -r $bin_dir/hbase root@$hbasemasterha_host:/$bin_dir
    for scps in $regionserver_hosts;do
         ssh $scps "! cat /etc/profile | grep \"HBASE_HOME=\" && echo 'export HBASE_HOME=$bin_dir/hbase' >>/etc/profile \
                           && ! cat /etc/profile | grep \"HBASE_HOME\/bin\" && echo 'export PATH=\$PATH:\$HBASE_HOME/bin' >>/etc/profile \
                           && ! cat /etc/profile | grep \"HBASE_LOG_DIR\" && echo 'export HBASE_LOG_DIR=$var_dir/hbase' >>/etc/profile \
                           && source /etc/profile && rm -rf $hbase_dir $local_dir/hbase/* $var_dir/hbase/* && chmod -R 755 $basic_dir && exit;"
	 scp -r $hbase_dir root@$scps:$bin_dir;
         echo "===========================$scps HBASE install ok================="
    done
#hdfs -mkdir -p /$hadoop_cluster_name/hbase
}

################################################################################################h
function installspark(){
rm -rf  $spark_dir/ $local_dir/spark $var_dir/spark
mkdir $local_dir/spark $var_dir/spark
echo "===========install spark=========="
tar -zxvf $spark_src_dir/$fspark_bin -C $bin_dir/
mv $bin_dir/$vspark  $bin_dir/spark
rm -rf $spark_dir/conf/slaves $spark_dir/conf/spark-defaults.conf $spark_dir/conf/spark-env.sh
cp $spark_dir/conf/slaves.template $spark_dir/conf/slaves
#cp $spark_dir/conf/spark-defaults.conf.template $spark_dir/conf/spark-defaults.conf
cp $spark_dir/conf/spark-env.sh.template $spark_dir/conf/spark-env.sh

sed -i '19d' $spark_dir/conf/slaves
for slave in $sparkwork_hosts;do
    echo "$slave" >> $spark_dir/conf/slaves
 done
    echo "export JAVA_HOME=$jdk_dir/$vjdk" >>$spark_dir/conf/spark-env.sh
    echo "export SCALA_HOME=$scala_dir" >>$spark_dir/conf/spark-env.sh
    echo "export HADOOP_HOME=$hadoop_dir" >>$spark_dir/conf/spark-env.sh
#    echo "export SPARK_MASTER_IP=${sparkmh[0]}" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_MASTER_PORT=7077" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_MASTER_WEBUI_PORT=7070" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_WORKER_CORES=2" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_WORKER_MEMORY=2g" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_EXECUTOR_MEMORY=2g" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_DRIVER_MEMORY=2g" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_WORKER_INSTANCES=1" >>$spark_dir/conf/spark-env.sh
    echo "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_YARN_USER_ENV=\"CLASSPATH=\$HADOOP_HOME/etc/hadoop\"" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_CLASSPATH=\$HADOOP_HOME/etc/hadoop:\$HADOOP_HOME/share/hadoop/common/lib/*:\$HADOOP_HOME/share/hadoop/common/*:\$HADOOP_HOME/share/hadoop/hdfs:\$HADOOP_HOME/share/hadoop/hdfs/lib/*:\$HADOOP_HOME/share/hadoop/hdfs/*:\$HADOOP_HOME/share/hadoop/yarn/lib/*:\$HADOOP_HOME/share/hadoop/yarn/*:\$HADOOP_HOME/share/hadoop/mapreduce/lib/*:\$HADOOP_HOME/share/hadoop/mapreduce/*:\$HADOOP_HOME/contrib/capacity-scheduler/*.jar:\$HBASE_HOME/lib/hbase-*.jar:\$HBASE_HOME/lib/htrace-core-3.1.0-incubating.jar:\$HBASE_HOME/lib/metrics-core-2.2.0.jar:\$SPARK_CLASSPATH" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_LOCAL_DIR=\"$local_dir/spark\"" >>$spark_dir/conf/spark-env.sh  
    echo "export YARN_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_JAVA_OPTS=\"-Dspark.storage.blockManagerHeartBeatMs=60000-Dspark.local.dir=\$SPARK_LOCAL_DIR -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:$var_dir/spark/gc.log -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:CMSInitiatingOccupancyFraction=60\"" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_DAEMON_JAVA_OPTS=\"-Dspark.deploy.recoveryMode=ZOOKEEPER -Dspark.deploy.zookeeper.url=$zk_quorum -Dspark.deploy.zookeeper.dir=/spark/ha\"" >>$spark_dir/conf/spark-env.sh
    echo "export SPARK_PID_DIR=$spark_dir/tmp" >>$spark_dir/conf/spark-env.sh
    mkdir -p $spark_dir/tmp
#    echo "spark.master                     spark://${sparkmh[0]}:7077" >>$spark_dir/conf/spark-defaults.conf
#    echo "spark.eventLog.enabled           true" >>$spark_dir/conf/spark-defaults.conf
#    echo "spark.eventLog.dir               hdfs://$hadoop_cluster_name/spark/logs" >>$spark_dir/conf/spark-defaults.conf
#    echo "spark.serializer                 org.apache.spark.serializer.KryoSerializer" >>$spark_dir/conf/spark-defaults.conf
#    echo "spark.driver.memory              5g" >>$spark_dir/conf/spark-defaults.conf
#    echo "spark.executor.extraJavaOptions  -XX:+PrintGCDetails -Dkey=value -Dnumbers=\"one two three\"" >>$spark_dir/conf/spark-defaults.conf
#wget https://repo1.maven.org/maven2/com/google/guava/guava/23.6-jre/guava-23.6-jre.jar
cp $src_dir/guava-23.6-jre.jar $spark_dir/jars
rm -rf $spark_dir/jars/guava-14.0.1.jar
    ssh $sparkmaster_host "! cat /etc/profile | grep \"SPARK_HOME=\" && echo 'export SPARK_HOME=$bin_dir/spark' >>/etc/profile \
                           && ! cat /etc/profile | grep \"SPARK_HOME\/bin\" && echo 'export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin' >>/etc/profile \
                           && source /etc/profile && exit;"

    ssh $sparkmasterha_host "! cat /etc/profile | grep \"SPARK_HOME=\" && echo 'export SPARK_HOME=$bin_dir/spark' >>/etc/profile \
                           && ! cat /etc/profile | grep \"SPARK_HOME\/bin\" && echo 'export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin' >>/etc/profile \
                           && source /etc/profile && exit;"
    for scps in $sparkwork_hosts;do
        ssh $scps "! cat /etc/profile | grep \"SPARK_HOME=\" && echo 'export SPARK_HOME=$bin_dir/spark' >>/etc/profile \
                           && ! cat /etc/profile | grep \"SPARK_HOME\/bin\" && echo 'export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin' >>/etc/profile \
                           && source /etc/profile && rm -rf $spark_dir $local_dir/spark/* $var_dir/spark/* && chmod -R 755 $basic_dir && exit;"
        scp -r $spark_dir root@$scps:$bin_dir;
        echo "===========================$scps SPARK install ok================="
    done
}

################################################################################################
function installflink(){
rm -rf $flink_dir $flink_src_dir
tar -zxvf  $src_dir/$fflink_bin -C $bin_dir
mv $bin_dir/$vflink  $flink_dir
sed -i '1d' $flink_dir/conf/slaves
sed -i '1d' $flink_dir/conf/masters
echo "$flinkmaster_host:$flinkmasterport" >> $flink_dir/conf/masters
echo "$flinkmasterha_host:$flinkmasterport" >> $flink_dir/conf/masters
echo "export HADOOP_CLASSPATH=`hadoop classpath`" >> $flink_dir/bin/config.sh
cp -r $zk_dir/conf/zoo.cfg $flink_dir/conf/
cp $hadoop_dir/etc/hadoop/core-site.xml  $flink_dir/conf/
cp $hadoop_dir/etc/hadoop/hdfs-site.xml  $flink_dir/conf/
##############################基础
sed -i "31a env.java.home: $jdk_dir/$vjdk" $flink_dir/conf/flink-conf.yaml
sed -i "32a env.hadoop.conf.dir: $hadoop_dir/etc/hadoop" $flink_dir/conf/flink-conf.yaml
sed -i "s/jobmanager.rpc.address: localhost/jobmanager.rpc.address: $flinkmaster_host/g" $flink_dir/conf/flink-conf.yaml
sed -i "s/jobmanager.heap.size: 1024m/jobmanager.heap.size: 3096m/g" $flink_dir/conf/flink-conf.yaml
sed -i "s/taskmanager.heap.size: 1024m/taskmanager.heap.size: 3096m/g" $flink_dir/conf/flink-conf.yaml
sed -i "s/taskmanager.numberOfTaskSlots: 1/taskmanager.numberOfTaskSlots: 5/g" $flink_dir/conf/flink-conf.yaml
sed -i "s/parallelism.default: 1/parallelism.default: 8/g" $flink_dir/conf/flink-conf.yaml
sed -i "67a taskmanager.tmp.dirs: $local_dir/yarn" $flink_dir/conf/flink-conf.yaml
################################## 指定使用 zookeeper 进行 HA 协调
sed -i "s/# high-availability: zookeeper/high-availability: zookeeper/g" $flink_dir/conf/flink-conf.yaml
sed -i "s/# high-availability.storageDir: hdfs:\/\/\/flink\/ha\//high-availability.storageDir: hdfs:\/\/$hadoop_cluster_name\/flink\/ha\/storage\//g" $flink_dir/conf/flink-conf.yaml
sed -i "s/# high-availability.zookeeper.quorum: localhost:2181/high-availability.zookeeper.quorum: $zk_quorum/g" $flink_dir/conf/flink-conf.yaml
sed -i "s/# high-availability.zookeeper.client.acl: open/high-availability.zookeeper.client.acl: open/g" $flink_dir/conf/flink-conf.yaml
sed -i "98a high-availability.zookeeper.path.root: /flink" $flink_dir/conf/flink-conf.yaml
sed -i "99a high-availability.cluster-id: yyok_flink" $flink_dir/conf/flink-conf.yaml
#==============================================================================
# recovery zookeeper
#==============================================================================
#sed -i "99a recovery.mode: zookeeper" $flink_dir/conf/flink-conf.yaml
#sed -i "99a recovery.zookeeper.quorum: ddac:2181,ddbc:2181,ddcc:2181" $flink_dir/conf/flink-conf.yaml
#sed -i "99a recovery.zookeeper.path.root: /flink" $flink_dir/conf/flink-conf.yaml
#sed -i "99a recovery.zookeeper.path.namespace: /cluster_yarn" $flink_dir/conf/flink-conf.yaml
################################### 指定 checkpoint 的类型和对应的数据存储目录
sed -i "s/# state.backend: filesystem/state.backend: filesystem/g" $flink_dir/conf/flink-conf.yaml
sed -i "s/# state.checkpoints.dir: hdfs:\/\/namenode-host:port\/flink-checkpoints/state.checkpoints.dir: hdfs:\/\/$hadoop_cluster_name\/flink\/ha\/checkpoints\//g" $flink_dir/conf/flink-conf.yaml
sed -i "s/# state.savepoints.dir: hdfs:\/\/namenode-host:port\/flink-checkpoints/state.savepoints.dir: hdfs:\/\/$hadoop_cluster_name\/flink\/ha\/svapoints\//g" $flink_dir/conf/flink-conf.yaml
############################## Rest和网络配置
sed -i "s/#rest.port: 8081/rest.port: 28081/g" $flink_dir/conf/flink-conf.yaml
sed -i "s/#rest.address: 0.0.0.0/rest.address: $flinkmaster_host/g" $flink_dir/conf/flink-conf.yaml
 
############################## 高级配置，临时文件目录
sed -i "175a io.tmp.dirs: $basic_dir\/tmp" $flink_dir/conf/flink-conf.yaml
sed -i "176a classloader.resolve-order: parent-first" $flink_dir/conf/flink-conf.yaml
############################## 配置 HistoryServer
sed -i "s/#jobmanager.archive.fs.dir: hdfs:\/\/\/completed-jobs\//jobmanager.archive.fs.dir: hdfs:\/\/$hadoop_cluster_name\/flink\/ha\\/jobmanager-jobs\//g" $flink_dir/conf/flink-conf.yaml
sed -i "s/#historyserver.web.address: 0.0.0.0/historyserver.web.address: $flinkmaster_host/g" $flink_dir/conf/flink-conf.yaml
sed -i "s/#historyserver.web.port: 8082/historyserver.web.port: 18082/g" $flink_dir/conf/flink-conf.yaml
sed -i "s/#historyserver.archive.fs.dir: hdfs:\/\/\/completed-jobs\//historyserver.archive.fs.dir: hdfs:\/\/$hadoop_cluster_name\/flink\/ha\\/historyserver-jobs\//g" $flink_dir/conf/flink-conf.yaml
sed -i "s/#historyserver.archive.fs.refresh-interval: 10000/historyserver.archive.fs.refresh-interval: 10000/g" $flink_dir/conf/flink-conf.yaml
echo "yarn.client.failover-proxy-provider: org.apache.hadoop.yarn.client.ConfiguredRMFailoverProxyProvider" >>$flink_dir/conf/flink-conf.yaml
echo "yarn.application-attempts: 10" >>$flink_dir/conf/flink-conf.yaml
echo "yarn.reallocate-failed: true" >>$flink_dir/conf/flink-conf.yaml
echo "yarn.maximum-failed-containers: 10" >>$flink_dir/conf/flink-conf.yaml

for slavess in $flink_works;do
   echo "$slavess" >>$flink_dir/conf/slaves
done
#hdfs dfs -mkdir -p /flink/ha/storage /flink/ha/checkpoints /flink/ha/jobmanager-jobs /flink/ha/historyserver-jobs
source /etc/profile
cp $src_dir/flink-shaded-hadoop-2-2.8.3-10.0.jar $flink_dir/lib/
cp $src_dir/commons-lang-2.6.jar $flink_dir/lib/
cp $src_dir/commons-logging-1.2.jar $flink_dir/lib/
cp $src_dir/curator-client-4.0.1.jar $flink_dir/lib/
cp $src_dir/curator-recipes-4.0.1.jar $flink_dir/lib/
#hdfs dfs -chmod -R 755 /flink/ha
echo "===========install flink ========="

   ssh $flinkmaster_host "! cat /etc/profile | grep \"FLINK_HOME\" && echo 'export FLINK_HOME=$bin_dir/flink' >>/etc/profile \
			&& ! cat /etc/profile | grep \"FLINK_HOME\/bin\" && echo 'export PATH=\$PATH:\$FLINK_HOME/bin' >>/etc/profile  && exit;"
   
   ssh $flinkmasterha_host "! cat /etc/profile | grep \"FLINK_HOME\" && echo 'export FLINK_HOME=$bin_dir/flink' >>/etc/profile \
                        && ! cat /etc/profile | grep \"FLINK_HOME\/bin\" && echo 'export PATH=\$PATH:\$FLINK_HOME/bin' >>/etc/profile && rm -rf $flink_dir && exit;"
     for scps in $flink_works;do
       ssh $scps "! cat /etc/profile | grep \"FLINK_HOME\" && echo 'export FLINK_HOME=$bin_dir/flink' >>/etc/profile \
                        && ! cat /etc/profile | grep \"FLINK_HOME\/bin\" && echo 'export PATH=\$PATH:\$FLINK_HOME/bin' >>/etc/profile && rm -rf $flink_dir && exit;"
       scp -r $flink_dir root@$scps:$bin_dir;
       echo "===========================$scps Flink install ok================="
    done
    scp -r $flink_dir root@$flinkmasterha_host:$bin_dir;

}

################################################################################################
function installkafka(){
echo "===========install kafka=========="
#tar -zxvf $kafka_s

}

################################################################################################
function installes(){
echo "===========install jdk=========="
}

################################################################################################
function installhive(){
echo "===========install jdk=========="

}

################################################################################################
function installhue(){
echo "===========install jdk=========="
}

################################################################################################
function installredis(){
echo "===========install jdk=========="

}


################################################################################################

function chmods(){
    for chms in $all_hosts;do
        ssh $chms "source /etc/profile && chmod -R 755 $basic_dir && chown root:root $hadoop_dir && chown root:root $local_dir/hadoop && chown root:root $var_dir/hadoop"
    done
}

function initevn(){
stop-all.sh
stop-hbase.sh
ssh $hbasemasterha_host $bin_dir/hbase/bin/stop-hbase.sh
$bin_dir/spark/sbin/stop-all.sh

for h in ${zk_hosts[@]}
do
echo "--------------$h-zk start---------------"
ssh $h $bin_dir/zookeeper/bin/zkServer.sh stop
done

for h in ${zk_hosts[@]}
do
echo "--------------$h-zk start---------------"
ssh $h $bin_dir/zookeeper/bin/zkServer.sh start
done

for j in ${journalnode_hosts[@]}
do
echo "--------------init journalnode $j  start----------------"
#ssh $j /ddhome/bin/hadoop/sbin/hadoop-daemon.sh start journalnode
ssh $j "rm -rf $local_dir/hadoop/journal/*"
ssh $j "rm -rf $local_dir/hadoop/* && rm -rf $var_dir/hadoop/* && mkdir -p $local_dir/hadoop/journal/$hadoop_cluster_name  && $bin_dir/hadoop/bin/hdfs --daemon start journalnode"
done
source /etc/profile
hadoop namenode -format
hdfs zkfc -formatZK
hdfs --daemon start namenode
#hdfs --daemon start
ssh $hadoopnameha_host $bin_dir/hadoop/bin/hdfs namenode -bootstrapStandby
ssh $hadoopnameha_host $bin_dir/hadoop/bin/hdfs  --daemon start namenode

}


########################### install start reg functions  ###########################
function installstart(){
#source /etc/profile
#stop-all.sh
#stop-hbase.sh
#ssh $hbasemasterha_host $bin_dir/hbase/bin/stop-hbase.sh
#$bin_dir/spark/sbin/stop-all.sh
#for h in ${zk_hosts[@]}
#do
#echo "--------------$h-zk start---------------"
#ssh $h $bin_dir/zookeeper/bin/zkServer.sh stop
#done

#mkdir_dirs
#yumupdates
#installssh
installenv
installzk
installhadoop
installhbase
installspark
installflink
installkafka
installes
installhive
installhue
installredis
chmods
#initevn
}
#installhbase
#installspark
installflink
#installstart
