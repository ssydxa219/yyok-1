zk_hosts=('dda' 'ddb' 'ddc')
    basic_dir="/ddhome"
    module_dir="local var tmp"
    src_dir="$basic_dir/src"
    bin_dir="$basic_dir/bin"
    var_dir="$basic_dir/var"
    local_dir="$basic_dir/local"
all_hosts="dda ddb ddc ddd dde ddf ddg ddh"
function mkdir_dirs(){
  for hs in $all_hosts;do
    for ms in $module_dir;do
     for cs in $component_dir;do
        dirc=$basic_dir/$ms/$cs
###############rm
        ssh $hs "source /etc/profile && rm -rf $dirc && mkdir -p $dirc && chmod -R 755 $dirc"
     done
   done
 done
}
#mkdir_dirs

journalnode_hosts=('dde' 'ddf' 'ddg')
for j in ${journalnode_hosts[@]}
do
echo "--------------$j----------------"
#ssh $j /ddhome/bin/hadoop/sbin/hadoop-daemon.sh start journalnode
#/ddhome/local/hadoop/journal/yyok
ssh $j "/ddhome/bin/hadoop/bin/hdfs --daemon $1 journalnode && jps"
done
