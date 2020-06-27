zk_hosts=('dda' 'ddb' 'ddc')
journalnode_hosts=('dde' 'ddf' 'ddg')
    basic_dir="/ddhome"
    module_dir="local var tmp"
    src_dir="$basic_dir/src"
    bin_dir="$basic_dir/bin"
    var_dir="$basic_dir/var"
    local_dir="$basic_dir/local"
all_hosts="dda ddb ddc ddd dde ddf ddg ddh"
for h in ${zk_hosts[@]}
do
echo "--------------$h----------------"
ssh $h "/ddhome/bin/zookeeper/bin/zkServer.sh start"
done
./cluster.sh jps
start-all.sh
/ddhome/bin/spark/sbin/stop-all.sh
start-hbase.sh
./cluster.sh jps

