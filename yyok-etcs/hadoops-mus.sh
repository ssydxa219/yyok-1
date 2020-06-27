#!/bin/bash
#######Shell一键部署Hadoop集群说明手册v1.0.0########
####################################################本SHELL文件在$basic_host的$src_dir下#######################################
##前提要求1：打通ssh
##前提要求2：jdk1.8已经安装
##前提要求3：centos7 已经优化

############1 文件目录定义
    basic_dir="/ddhome"
    module_dir="local var tmp"
    src_dir="$basic_dir/src"
    bin_dir="$basic_dir/bin"
    var_dir="$basic_dir/var"
    local_dir="$basic_dir/local"
    jdk_dir="/usr/java"
    zk_dir="$bin_dir/zookeeper"
    zk_data_dir="$local_dir/zookeeper"
    hadoop_dir="$bin_dir/hadoop"
    hadoop_data_dir="$local_dir/hadoop"
    hadoop_src_dir="$src_dir/hadoop-3.2.1-src/hadoop-dist/target"
    hbase_dir="$bin_dir/hbase"
    spark_dir="$bin_dir/spark"
    flink_dir="$bin_dir/flink"
    
####################component定义
    component_dir="zookeeper hadoop hbase flink"
####################component 版本定义
    vzk="apache-zookeeper-3.5.7"
    vhadoop="hadoop-3.2.1"
    vhbase=""
####################component 文件名定义
    fzk="apache-zookeeper-3.5.7-bin.tar.gz"
    fhadoop_bin="hadoop-3.2.1.tar.gz"
    fhbase_bin=""
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
    #########hadoop cluster naem
    hadoop_cluster_name="yyok"
    #########hadoop name hosts主机
    hadoopname_host="dda"
    hadoopnameha_host="ddb"
    #########hadoop data host主机
    hadoopdata_hosts="ddc ddd dde ddf ddg ddh"
    hadoopjournal_hosts="ddg ddh"
    #########hadoop yarn host主机
    resourcesmanager_host="ddc"
    resourcesmanagerha_host="ddd"
    yarn_name="yyok_yarn"
    nodemanager_hosts="dde ddf ddg ddh"
    #########hbase hosts masts主机
    hbasemaster_host="dda"
    hbasemasterha_host="ddb"
    #########hbase hosts regionservices
    hbaseregionserver_hosts="ddc ddd dde ddf ddg ddh"
    #########sparkhosts
    sparkmaster_host="dda ddb"
    sparkwork_host="ddc ddd dde ddf ddg ddh"
    #########flinkhosts
    flink_host="dda ddb"
    flink_work="ddc ddd dde ddf ddg ddh"

############1.1 目录操作

function mkdir_dirs(){
  for hs in $all_hosts;do
    for ms in $module_dir;do
     for cs in $component_dir;do
	dirc=$basic_dir/$ms/$cs 
###############rm
	ssh $hs "rm -rf $dirc && mkdir -p  $dirc && chmod -R 755  $dirc" 
     done
   done
 done
}
########################################################################hostname


########################################################################net




########################################################################core


########################################################################yum update


########################################################################jdk
function installjdk(){
	echo "===========install jdk=========="

    for al in $all_hosts;do
       if [ $al == $basic_host ];then
        echo "$al == $basic_host"
         else
        ssh $basic_host "\
                    scp -r ${src_dir}/jdk-8u221-linux-x64.rpm root@$al:$src_dir \
                    && ls -a ${src_dir} \
                    && rpm -ih ${src_dir}/jdk-8u221-linux-x64.rpm \
                    && ! cat /etc/profile | grep \"jdk1.8.0_221-amd64\" && echo 'export JAVA_HOME=/usr/java/jdk1.8.0_221-amd64/' >>/etc/profile \
                    && ! cat /etc/profile | grep \"CLASSPATH\" && echo 'export CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar' >>/etc/profile \
                    && ! cat /etc/profile | grep \"JAVA_HOME\" && echo 'export PATH=$PATH:${JAVA_HOME}/bin' >>/etc/profile \
                    && ! cat /etc/profile | grep \"SCALA_HOME=\" && echo 'export SCALA_HOME=${BASE_HOME}/scala' >>/etc/profile \
                    && ! cat /etc/profile | grep \"SCALA_HOME\" && echo 'export PATH=$PATH:${SCALA_HOME}/bin' >>/etc/profile
		"


        fi
           echo "===========================$al jdk install ok================="
    done
}


function installzk(){
########################################################################zk
  rm -rf "$zk_dir"
  rm -rf "$bin_dir/apache-zookeeper-3.5.7-bin"
 # wget https://downloads.apache.org/zookeeper/zookeeper-3.5.7/apache-zookeeper-3.5.7-bin.tar.gz
  tar -zxvf $src_dir/$fzk -C $basic_dir/bin
  cd $bin_dir
  mv apache-zookeeper-3.5.7-bin zookeeper
  cp $zk_dir/conf/zoo_sample.cfg $zk_dir/conf/zoo.cfg
  sed -i "s/dataDir=\/tmp/dataDir=\/ddhome\/local/g" $zk_dir/conf/zoo.cfg
  sed -i "s/\#maxClientCnxns=60/maxClientCnxns=6000/g" $zk_dir/conf/zoo.cfg
  for zk in $zk_hosts;do
    let n++
    ssh $basic_host "echo server.$n=$zk:2888:3888 >> $zk_dir/conf/zoo.cfg"
    dirc=$basic_dir
    ssh $zk "touch $local_dir/zookeeper/myid && echo $n > $local_dir/zookeeper/myid && cat $local_dir/zookeeper/myid"
  done

  for zk in $zk_hosts;do
   if [ $zk == $basic_host ];then
	echo "$zk == $basic_host"
     else
    ssh $zk "rm -rf $zk_dir"
    ssh $basic_host "scp -r $zk_dir root@$zk:$bin_dir"
    fi
    ssh $zk "chmod -R 755 $bin_dir && chmod -R 755 $local_dir && $bin_dir/zookeeper/bin/zkServer.sh status && $bin_dir/zookeeper/bin/zkServer.sh start"
   done
}

function installhadoop(){
#####################################################################################hadoop
rm -rf "$hadoop_dir/"
tar -zxvf $hadoop_src_dir/$fhadoop_bin -C $basic_dir/bin
mv $bin_dir/hadoop-3.2.1 $hadoop_dir
##JAVA_HOME=
#export JAVA_HOME=/usr/java/jdk1.8.0_221-amd64/
#export CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
#export PATH=$PATH:${JAVA_HOME}/bin
grep "JAVA_HOME=\/usr\/java\/jdk1.8.0_221-amd64" $hadoop_dir/etc/hadoop/hadoop-env.sh > /dev/null
if [ $? -eq 0 ]; then
    echo "JAVA_HOME Found!"
else
############################ hadoop-env.sh ############################
   sed -i "55a export JAVA_HOME=/usr/java/jdk1.8.0_221-amd64" $hadoop_dir/etc/hadoop/hadoop-env.sh
   sed -i "58a export HADOOP_HOME=$hadoop_dir" $hadoop_dir/etc/hadoop/hadoop-env.sh
   sed -i "68a export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop" $hadoop_dir/etc/hadoop/hadoop-env.sh
   sed -i "75a export HADOOP_HEAPSIZE_MAX=3072" $hadoop_dir/etc/hadoop/hadoop-env.sh
   sed -i "82a export HADOOP_HEAPSIZE_MIN=1024" $hadoop_dir/etc/hadoop/hadoop-env.sh
  # sed -i "126a export HADOOP_CLASSPATH=\`hadoop classpath\`" $hadoop_dir/etc/hadoop/hadoop-env.sh
   sed -i "194a export HADOOP_LOG_DIR=${var_dir}/hadoop" $hadoop_dir/etc/hadoop/hadoop-env.sh
   sed -i "205a export HADOOP_PID_DIR=$local_dir/tmp " $hadoop_dir/etc/hadoop/hadoop-env.sh
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
   sed -i "34a export YARN_RESOURCEMANAGER_USER=root" $hadoop_dir/etc/hadoop/yarn-env.sh
   sed -i "35a export YARN_NODEMANAGER_USER=root" $hadoop_dir/etc/hadoop/yarn-env.sh
   sed -i "36a export HADOOP_YARN_USER=${HADOOP_YARN_USER:-yarn}" $hadoop_dir/etc/hadoop/yarn-env.sh
   sed -i "37a export YARN_RESOURCEMANAGER_USER=root" $hadoop_dir/etc/hadoop/yarn-env.sh
   sed -i "38a export YARN_NODEMANAGER_USER=root" $hadoop_dir/etc/hadoop/yarn-env.sh
  # sed -i "39a export YARN_CONF_DIR=\"${YARN_CONF_DIR:-$HADOOP_YARN_HOME/conf}\"" $hadoop_dir/etc/hadoop/yarn-env.sh
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
    echo "<value>128000000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.namenode.handler.count</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>1000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.datanode.handler.count</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>1000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
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
    echo "<value>60000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
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
    echo "<value>30000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>ha.failover-controller.cli-check.rpc-timeout.ms</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>60000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.client.file-block-storage-locations.timeout.millis</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>10000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
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
    echo "<value>750</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.block.local-path-access.user</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>impala</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<name>dfs.client.file-block-storage-locations.timeout</name>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
    echo "<value>3000</value>" >>$hadoop_dir/etc/hadoop/hdfs-site.xml
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
    echo "<value>15000</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<description>每个Map任务的物理内存限制</description>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.reduce.memory.mb</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>15000</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<description>每个Reduce任务的物理内存限制</description>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.map.java.opts</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>-Xmx3586M</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.reduce.java.opts</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>-Xmx10586M</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapred.child.env</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>LD_LIBRARY_PATH=$hadoop_dir/lzo/lib</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.cluster.acls.enabled</name>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/mapred-site.xml
    echo "</configuration>" >>$hadoop_dir/etc/hadoop/mapred-site.xml

############################ yarn-site.xml ############################
    sed -i '19d' $hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.cluster-id</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${yarn_name}</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.env-whitelist</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.connect.retry-interval.ms</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>2000</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.ha.enabled</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.ha.rm-ids</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>rma,rmb</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>ha.zookeeper.quorum</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${zk_quorum}</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.ha.automatic-failover.enabled</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
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
    echo "<name>yarn.resourcemanager.recovery.enabled</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!--org.apache.hadoop.yarn.server.resourcemanager.recovery.FileSystemRMStateStore,ZKRMStateStore  -->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.store.class</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.yarn.server.resourcemanager.recovery.ZKRMStateStore</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
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
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo " <name>yarn.nodemanager.resource.detect-hardware-capabilities</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.app.mapreduce.am.scheduler.connection.wait.interval-ms</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>5000</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.address.rma</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanager_host}:8032</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.scheduler.address.rma</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanager_host}:8030</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.webapp.address.rma</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanager_host}:8088</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.resource-tracker.address.rma</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanager_host}:8031</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.admin.address.rma</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanager_host}:8033</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.ha.admin.address.rma</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanager_host}:8034</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.address.rmb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanagerha_host}:8032</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.scheduler.address.rmb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanagerha_host}:8030</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.webapp.address.rmb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanagerha_host}:8088</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.resource-tracker.address.rmb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanagerha_host}:8031</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.admin.address.rmb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanagerha_host}:8033</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.ha.admin.address.rmb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${resourcesmanagerha_host}:8034</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.aux-services</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>mapreduce_shuffle</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.mapred.ShuffleHandler</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.local-dirs</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${local_dir}/hadoop/yarn</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.log-dirs</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${local_dir}/hadoop/log</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.shuffle.port</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>23080</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.log.retain-seconds</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>10800</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.fs.state-store.uri</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${local_dir}/hadoop/yarn/rmstore</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.client.failover-proxy-provider</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.yarn.client.ConfiguredRMFailoverProxyProvider</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.ha.automatic-failover.zk-base-path</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${local_dir}/hadoop/yarn-leader-election</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>Optional setting. The default value is /yarn-leader-election</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>Classpath for typical applications.</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.application.classpath</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
   # echo "\$YARN_CONF_DIR," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "\$HADOOP_COMMON_HOME/share/hadoop/common/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "\$HADOOP_COMMON_HOME/share/hadoop/common/lib/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "\$HADOOP_HDFS_HOME/share/hadoop/hdfs/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "\$HADOOP_HDFS_HOME/share/hadoop/hdfs/lib/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "\$YARN_HOME/share/hadoop/yarn/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "\$YARN_HOME/share/hadoop/yarn/lib/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "\$YARN_HOME/share/hadoop/mapreduce/*," >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "\$YARN_HOME/share/hadoop/mapreduce/lib/*" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.am.max-attempts</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>13</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "The maximum number of application master execution attempts." >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.log-aggregation-enable</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.log-aggregation.retain-check-interval-seconds</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>10800</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.log-aggregation.retain-seconds</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>106800</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.minimum-allocation-mb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>1024</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.maximum-allocation-mb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>15000</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.resource.cpu-vcores</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>13</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.minimum-allocation-vcores</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>2</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.maximum-allocation-vcores</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>8</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>Amount of physical memory, in MB, that can be allocated for containers.</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.resource.memory-mb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>15000</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.pmem-check-enabled</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.vmem-check-enabled</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>false</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>Whether virtual memory limits will be enforced for containers</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>Ratio between virtual memory to physical memory when" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "setting memory limits for containers. Container allocations are" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "expressed in terms of physical memory, and virtual memory usage" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "is allowed to exceed this allocation by this ratio." >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.vmem-pmem-ratio</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>2.1</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.log.server.url</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>http://${resourcesmanager_host}:19888/jobhistory/logs</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.map.memory.mb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>15000</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.reduce.memory.mb</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>15000</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.map.java.opts</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>-Xmx15000m</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>mapreduce.reduce.java.opts</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>-Xmx15000m</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.scheduler.monitor.enable</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml

    echo "<!--  指定我们的任务调度使用fairScheduler的调度方式" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler</value>-->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.resourcemanager.scheduler.class</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml

    echo "<!--  指定我们的任务调度的配置文件路径  -->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.allocation.file</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${bin_dir}/hadoop/etc/hadoop/fair-scheduler.xml</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml

    echo "<!-- 是否启用资源抢占，如果启用，那么当该队列资源使用" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "yarn.scheduler.fair.preemption.cluster-utilization-threshold 这么多比例的时候，就从其他空闲队列抢占资源-->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.preemption</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.preemption.cluster-utilization-threshold</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>0.8f</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!-- 默认提交到default队列  -->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.user-as-default-queue</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>default is True</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!-- 如果提交一个任务没有到任何的队列，是否允许创建一个新的队列，设置false不允许  -->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.allow-undeclared-pools</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>false</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<description>default is True</description>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.remote-app-log-dir</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>${var_dir}/hadoop</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.remote-app-log-dir-suffix</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>logs</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.nodemanager.delete.debug-delay-sec</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>600</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!--property><name>yarn.nodemanager.localizer.cache.target-size-mb</name><value>2048</value></property-->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<!--多租户配置，新增，用于队列的权限管理，和mapred-site.xml配置文件配合使用，例如不同租户不能随意kill任务，只能kill属于自己的队列任务，超级用户除外-->" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.acl.enable</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>true</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.admin.acl</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>hadoop</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<name>yarn.scheduler.fair.sizebasedweight</name>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "<value>false</value>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</property>" >>$hadoop_dir/etc/hadoop/yarn-site.xml
    echo "</configuration>" >>$hadoop_dir/etc/hadoop/yarn-site.xml

############################ fair-scheduler.xml ############################
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
############################ stop-yarn.sh ############################
    sed -i "17a YARN_RESOURCEMANAGER_USER=\"root\"" $hadoop_dir/sbin/stop-yarn.sh
    sed -i "18a HDFS_DATANODE_SECURE_USER=\"root\"" $hadoop_dir/sbin/stop-yarn.sh
    sed -i "19a YARN_NODEMANAGER_USER=\"root\"" $hadoop_dir/sbin/stop-yarn.sh
#echo "======================================================"
	rm -rf  $local_dir/hadoop
	mkdir -p $local_dir/hadoop
        mkdir -p $hadoop_dir/tmp
   echo "===========================HADOOP install ok================="
fi

    for scps in $all_hosts;do
       if [ $scps == $basic_host ];then
            echo "$scps == $basic_host"
         else
            ssh $scps "rm -rf $hadoop_dir && rm -rf $local_dir/hadoop/* && rm -rf $var_dir/hadoop/* && chmod -R 755 $basic_dir && exit;"
	    scp -r $hadoop_dir root@$scps:$bin_dir;
            echo "===========================$scps HADOOP install ok================="
        fi
    done
################################################################################################hbase
}

################################################################################################h
function installhbase(){
echo "===========install jdk=========="
}

################################################################################################h
function installspark(){
echo "===========install jdk=========="


}

################################################################################################h
function installflink(){
echo "===========install jdk=========="

}

################################################################################################h
function installkafka(){
echo "===========install jdk=========="


}

################################################################################################h
function installes(){
echo "===========install jdk=========="
}

################################################################################################h
function installhive(){
echo "===========install jdk=========="

}

################################################################################################h
function installhue(){
echo "===========install jdk=========="
}

################################################################################################h
function installredis(){
echo "===========install jdk=========="

}

################################################################################################h
function initinstalls(){
echo "===========start=========="

}

function chmods(){
    for chms in $all_hosts;do
	ssh $chms "chmod -R 755 $basic_dir && chown root:root $hadoop_dir && chown root:root $local_dir/hadoop && chown root:root $var_dir/hadoop"
    done


}

#mkdir_dirs
#installjdk
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
