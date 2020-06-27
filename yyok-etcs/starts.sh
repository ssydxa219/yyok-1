zk_hosts=('dda' 'ddb' 'ddc')

for h in ${zk_hosts[@]}
do
echo "--------------$h----------------"
ssh $h /ddhome/bin/zookeeper/bin/zkServer.sh start
done

journalnode_hosts=('dde' 'ddf' 'ddg')
for j in ${journalnode_hosts[@]}
do
echo "--------------$j----------------"
#ssh $j /ddhome/bin/hadoop/sbin/hadoop-daemon.sh start journalnode
#/ddhome/local/hadoop/journal/yyok
ssh $j "rm -rf /ddhome/local/hadoop/journal/yyok && /ddhome/bin/hadoop/bin/hdfs --daemon start journalnode"
done

hadoop namenode -format
hdfs zkfc -formatZK
hadoop-daemon.sh start namenode
ssh ddb /ddhome/bin/hadoop/bin/hdfs namenode -bootstrapStandby
#ssh ddb /ddhome/bin/hadoop/sbin/hadoop-daemon.sh start namenode
#ssh dda /ddhome/bin/hadoop/sbin/stop-all.sh
#ssh dda /ddhome/bin/hadoop/bin/hdfs haadmin -transitionToActive --forcemanual nna

#ssh dda /ddhome/bin/flink/bin/start-cluster.sh
#ssh dda /ddhome/bin/hbase/bin/start-hbase.sh
#ssh ddb /ddhome/bin/hbase/bin/hbase-daemon.sh start master --backup-masters
#ssh dda /ddhome/bin/cluster.sh jps
#ssh dde /ddhome/bin/hbase/bin/hbase-daemon.sh start regionserver
#ssh ddf /ddhome/bin/hbase/bin/hbase-daemon.sh start regionserver
#ssh ddg /ddhome/bin/hbase/bin/hbase-daemon.sh start regionserver
#ssh ddh /ddhome/bin/hbase/bin/hbase-daemon.sh start regionserver
#ssh dda /ddhome/bin/spark/sbin/start-all.sh
#ssh ddf <<EOF
#	ps -ef | grep metastore | grep -v grep | awk '{print $2}' | xargs kill -9
#	ps -ef | grep hiveserver2 | grep -v grep | awk '{print $2}' | xargs kill -9
#	nohup /ddhome/bin/hive/bin/hive --service metastore  >/ddhome/var/hive/metastore.log 2>&1 &
#	nohup /ddhome/bin/hive/bin/hive --service hiveserver2  >/ddhome/var/hive/hiveserver2.log 2>&1 &
#	mkdir -p /ddhome/var/hue/
#	nohup /ddhome/bin/hue/build/env/bin/supervisor >/ddhome/var/hue/supervisor.log 2>&1 &
#    	exit
#EOF
#ssh dda /ddhome/bin/cluster.sh jps
