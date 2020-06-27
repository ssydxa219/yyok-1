hosts=('dda' 'ddb' 'ddc')

for h in ${hosts[@]}
do
echo "--------------$h----------------"
ssh $h /ddhome/bin/zookeeper/bin/zkServer.sh $1
ssh $h /ddhome/bin/hadoop/sbin/hadoop-daemon.sh $1 journalnode
#ssh $h /ddhome/bin/hadoop/bin/hdfs --daemon start journalnode
done
