zk_hosts=('dda' 'ddb' 'ddc')
journalnode_hosts=('dde' 'ddf' 'ddg')
    basic_dir="/ddhome"
    module_dir="local var tmp"
    src_dir="$basic_dir/src"
    bin_dir="$basic_dir/bin"
    var_dir="$basic_dir/var"
    local_dir="$basic_dir/local"
all_hosts="dda ddb ddc ddd dde ddf ddg ddh"
stop-hbase.sh
stop-all.sh
$bin_dir/spark/sbin/stop-all.sh
for h in ${zk_hosts[@]}
do
echo "--------------$h----------------"
ssh $h "/ddhome/bin/zookeeper/bin/zkServer.sh stop"
done
./cluster.sh jps

