zk_hosts=('dda' 'ddb' 'ddc')
journalnode_hosts=('dde' 'ddf' 'ddg')
    basic_dir="/ddhome"
    module_dir="local var tmp"
    src_dir="$basic_dir/src"
    bin_dir="$basic_dir/bin"
    var_dir="$basic_dir/var"
    local_dir="$basic_dir/local"
all_hosts="dda ddb ddc ddd dde ddf ddg ddh"
function mkdir_dirs(){
  for hs in $all_hosts;do
    ssh $hs "rm -rf $var_dir/* $local_dir/hadoop/* $local_dir/hbase/* $local_dir/spark/* $local_dir/flink/* $local_dir/kafka/* && mkdir -p $var_dir/hadoop $local_dir/hadoop/name $local_dir/hadoop/data && exit;"
    for ms in $module_dir;do
     for cs in $component_dir;do
        dirc=$basic_dir/$ms/$cs
        ssh $hs "source /etc/profile && mkdir -p $dirc && chmod -R 755 $dirc && exit;"
     done
   done
 done
}
echo "===================running pp record==============================="
./cluster.sh jps  >> orgcluster.txt
echo "===================running ==============================="
mkdir_dirs
############################################
source /etc/profile
stop-cluster.sh
stop-hbase.sh
$bin_dir/spark/sbin/stop-all.sh
stop-all.sh
for h in ${zk_hosts[@]}
do
echo "--------------$h----------------"
ssh $h "/ddhome/bin/zookeeper/bin/zkServer.sh stop"
done
echo "====================stop over=================================="
./cluster.sh jps
##########################################
for h in ${zk_hosts[@]}
do
echo "--------------$h----------------"
ssh $h "/ddhome/bin/zookeeper/bin/zkServer.sh start"
done
for j in ${journalnode_hosts[@]}
do
echo "--------------$j----------------"
ssh $j "/ddhome/bin/hadoop/bin/hdfs --daemon start journalnode"
done
./cluster.sh jps
hadoop namenode -format
hdfs zkfc -formatZK
hdfs --daemon start namenode
./cluster.sh jps
sleep 10
ssh ddb /ddhome/bin/hadoop/bin/hdfs namenode -bootstrapStandby
#ssh ddb /ddhome/bin/hadoop/bin/hdfs --daemon start namenode
start-all.sh
hdfs dfs -mkdir -p  /tmp/{input,outpt}
hdfs dfs -put /ddhome/src/hadoop-3.2.1-src/README.txt  /tmp/input
hdfs dfs -rmr -r /tmp/output/wtest
echo "===============================测试M=========================================="
#hadoop jar $bin_dir/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar wordcount /tmp/input/* /tmp/output/wtest
#stop-all.sh
#scp -r $local_dir/hadoop/  ddb:$local_dir
#./cluster.sh jps
#/ddhome/bin/spark/sbin/stop-all.sh
./cluster.sh jps

