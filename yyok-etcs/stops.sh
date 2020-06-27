hosts=('dda' 'ddb' 'ddc')

ssh dda /ddhome/bin/flink/bin/stop-cluster.sh
ssh dda /ddhome/bin/spark/sbin/stop-all.sh
ssh dda /ddhome/bin/hbase/bin/hbase-daemon.sh stop hmaster
ssh ddb /ddhome/bin/hbase/bin/hbase-daemon.sh stop hmaster
ssh dde /ddhome/bin/hbase/bin/hbase-daemon.sh stop regionserver
ssh ddf /ddhome/bin/hbase/bin/hbase-daemon.sh stop regionserver
ssh ddg /ddhome/bin/hbase/bin/hbase-daemon.sh stop regionserver
ssh ddh /ddhome/bin/hbase/bin/hbase-daemon.sh stop regionserver
ssh ddh ps -ef | grep metastore | grep -v grep | awk '{print $2}' | xargs kill -9
ssh ddh ps -ef | grep hiveserver2 | grep -v grep | awk '{print $2}' | xargs kill -9
ssh ddh ps -ef | grep supervisor | grep -v grep | awk '{print $2}' | xargs kill -9
ssh dde ps -ef | grep journalnode | grep -v grep | awk '{print $2}' | xargs kill -9
ssh ddf ps -ef | grep journalnode | grep -v grep | awk '{print $2}' | xargs kill -9
ssh ddg ps -ef | grep journalnode | grep -v grep | awk '{print $2}' | xargs kill -9
ssh dda /ddhome/bin/hadoop/sbin/stop-all.sh
for h in ${hosts[@]}
do
echo "--------------$h----------------"
ssh $h /ddhome/bin/zookeeper/bin/zkServer.sh stop
done
ssh dda /ddhome/bin/cluster.sh jps
