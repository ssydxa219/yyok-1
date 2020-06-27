#!/bin/bash
#shell install Mysql7
#[! cat /etc/profile | grep 'export PATH=$PATH:/ddhome/bin/mysql/bin' ]
bin_dir=/ddhome/bin/
local_dir=/ddhome/local/mysql/
var_dir=/ddhome/var/mysql/
cd /ddhome/bin
#tar gz
rm -rf /ddhome/bin/mysql/ /ddhome/local/mysql /ddhome/var/mysql

tar -zxvf mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz
mv mysql-5.7.22-linux-glibc2.12-x86_64 mysql
groupadd mysql
useradd -r -g mysql mysql
cd /ddhome/bin/mysql/
chgrp -R mysql .
chown -R mysql .
chmod -R 755 /ddhome/
mkdir  -p /ddhome/local/mysql/data /ddhome/var/mysql /ddhome/bin/mysql/tmp
touch /ddhome/var/mysql/mariadb.log
chmod -R 755 /ddhome/bin/mysql/
chmod -R 755 /ddhome/local/mysql
chmod -R 755 /ddhome/var/mysql
chown -R mysql:mysql /ddhome/bin/mysql/
chown -R mysql:mysql /ddhome/local/mysql/data
chown -R mysql:mysql /ddhome/var/mysql
chown -R mysql:mysql /ddhome/local/mysql/data
#cp support-files/my-default.cnf /etc/my.cnf
echo "[client]" > /etc/my.cnf
echo "#########################################################################" >> /etc/my.cnf
echo "#                                                                       #" >> /etc/my.cnf
echo "#                         MySQL客户端配置                               #" >> /etc/my.cnf
echo "#                                                                       #" >> /etc/my.cnf
echo "#########################################################################" >> /etc/my.cnf
echo "port = 3306" >> /etc/my.cnf
echo "# MySQL客户端默认端口号" >> /etc/my.cnf

echo "socket = /data/mysql/my3306/mysql.sock" >> /etc/my.cnf
echo "# 用于本地连接的Unix套接字文件存放路径" >> /etc/my.cnf

echo "default-character-set = utf8mb4" >> /etc/my.cnf
echo "# MySQL客户端默认字符集" >> /etc/my.cnf

echo "[mysql]" >> /etc/my.cnf
echo "#########################################################################" >> /etc/my.cnf
echo "#                                                                       #" >> /etc/my.cnf
echo "#                         MySQL命令行配置                               #" >> /etc/my.cnf
echo "#                                                                       #" >> /etc/my.cnf
echo "#########################################################################" >> /etc/my.cnf
echo "auto-rehash" >> /etc/my.cnf
echo "# 开启tab补齐功能" >> /etc/my.cnf

echo "socket = /ddhome/bin/mysql/tmp/mysql.sock" >> /etc/my.cnf
echo "# 用于本地连接的Unix套接字文件存放路径" >> /etc/my.cnf

echo "default-character-set = utf8mb4" >> /etc/my.cnf
echo "# MySQL客户端默认字符集" >> /etc/my.cnf

echo "max_allowed_packet = 256M" >> /etc/my.cnf
echo "# 指定在网络传输中一次消息传输量的最大值。系统默认值 为1MB，最大值是1GB，必须设置1024的倍数。" >> /etc/my.cnf

echo "[mysqld]" >> /etc/my.cnf
echo "#########################################################################" >> /etc/my.cnf
echo "#                                                                       #" >> /etc/my.cnf
echo "#                         MySQL服务端配置                               #" >> /etc/my.cnf
echo "#                                                                       #" >> /etc/my.cnf
echo "#########################################################################" >> /etc/my.cnf

echo "########################################" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "#               General                #" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "########################################" >> /etc/my.cnf
echo "port = 3306" >> /etc/my.cnf
echo "# MySQL服务端默认监听的TCP/IP端口" >> /etc/my.cnf

echo "socket = /ddhome/bin/mysql/tmp/mysql.sock" >> /etc/my.cnf
echo "# 用于本地连接的Unix套接字文件存放路径" >> /etc/my.cnf

echo "pid_file = /ddhome/bin/mysql/tmp/mysql.pid" >> /etc/my.cnf
echo "# 进程ID文件存放路径" >> /etc/my.cnf

echo "basedir = /ddhome/bin/mysql" >> /etc/my.cnf
echo "# MySQL软件安装路径" >> /etc/my.cnf

echo "datadir = /ddhome/local/mysql/mysql" >> /etc/my.cnf
echo "# MySQL数据文件存放路径" >> /etc/my.cnf

echo "tmpdir = /ddhome/tmp/mysql/" >> /etc/my.cnf
echo "# MySQL临时文件存放路径" >> /etc/my.cnf

echo "character_set_server = utf8mb4" >> /etc/my.cnf
echo "# MySQL服务端字符集" >> /etc/my.cnf

echo "collation_server = utf8mb4_general_ci" >> /etc/my.cnf
echo "# MySQL服务端校对规则" >> /etc/my.cnf

echo "default-storage-engine = InnoDB" >> /etc/my.cnf
echo "# 设置默认存储引擎为InnoDB" >> /etc/my.cnf

echo "autocommit = OFF" >> /etc/my.cnf
echo "# 默认为ON，设置为OFF，关闭事务自动提交" >> /etc/my.cnf

echo "transaction_isolation = READ-COMMITTED" >> /etc/my.cnf
echo "# MySQL支持4种事务隔离级别，他们分别是：" >> /etc/my.cnf
echo "# READ-UNCOMMITTED, READ-COMMITTED, REPEATABLE-READ, SERIALIZABLE." >> /etc/my.cnf
echo "# 如没有指定，MySQL默认采用的是REPEATABLE-READ，ORACLE默认的是READ-COMMITTED" >> /etc/my.cnf

echo "event_scheduler = ON" >> /etc/my.cnf
echo "# 开启事件调度器event_scheduler" >> /etc/my.cnf

echo "#explicit_defaults_for_timestamp = ON" >> /etc/my.cnf
echo "# 控制TIMESTAMP数据类型的特性，默认OFF，设置为ON，update 时timestamp列关闭自动更新。（将来会被废弃）" >> /etc/my.cnf

echo "lower_case_table_names = 1" >> /etc/my.cnf
echo "# 库名、表名是否区分大小写。默认为0，设置1，不区分大小写，创建的表、数据库都以小写形式存放磁盘。" >> /etc/my.cnf

echo "########################################" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "#       Network & Connection           #" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "########################################" >> /etc/my.cnf
echo "max_connections = 1000" >> /etc/my.cnf
echo "# MySQL允许的最大并发连接数，默认值151，如果经常出现Too Many Connections的错误提示，则需要增大此值。" >> /etc/my.cnf

echo "max_user_connections = 1000" >> /etc/my.cnf
echo "# 每个数据库用户的最大连接，（同一个账号能够同时连接到mysql服务的最大连接数），默认为0，表示不限制。" >> /etc/my.cnf

echo "back_log = 500" >> /etc/my.cnf
echo "# MySQL监听TCP端口时设置的积压请求栈大小，默认50+(max_connections/5)，最大不超过900" >> /etc/my.cnf

echo "max_connect_errors = 10000" >> /etc/my.cnf
echo "# 每个主机的连接请求异常中断的最大次数。对于同一主机，如果有超出该参数值个数的中断错误连接，则该主机将被禁止连接。如需对该主机进行解禁，执行：FLUSH HOST。" >> /etc/my.cnf

echo "interactive_timeout = 28800" >> /etc/my.cnf
echo "# 服务器关闭交互式连接前等待活动的秒数。交互式客户端定义为在mysql_real_connect()中使用CLIENT_INTERACTIVE选项的客户端。默认值：28800秒（8小时）" >> /etc/my.cnf

echo "wait_timeout = 28800" >> /etc/my.cnf
echo "# 服务器关闭非交互连接之前等待活动的秒数。默认值：28800秒（8小时）" >> /etc/my.cnf
echo "# 指定一个请求的最大连接时间，当MySQL连接闲置超过一定时间后将会被强行关闭。对于4GB左右内存的服务器来说，可以将其设置为5~10。" >> /etc/my.cnf
echo "# 如果经常出现Too Many Connections的错误提示，或者show processlist命令发现有大量sleep进程，则需要同时减小interactive_timeout和wait_timeout值。" >> /etc/my.cnf

echo "connect_timeout = 28800" >> /etc/my.cnf
echo "# 在获取连接时，等待握手的超时秒数，只在登录时生效。主要是为了防止网络不佳时应用重连导致连接数涨太快，一般默认即可。" >> /etc/my.cnf

echo "open_files_limit = 5000" >> /etc/my.cnf
echo "# mysqld能打开文件的最大个数，默认最小1024，如果出现too mant open files之类的就需要增大该值。" >> /etc/my.cnf

echo "max_allowed_packet = 256M" >> /etc/my.cnf
echo "# 指定在网络传输中一次消息传输量的最大值。系统默认值 为1MB，最大值是1GB，必须设置1024的倍数。" >> /etc/my.cnf

echo "########################################" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "#          Thread & Buffer             #" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "########################################" >> /etc/my.cnf
echo "sort_buffer_size = 2M" >> /etc/my.cnf
echo "# 排序缓冲区大小，connection级参数，默认大小为2MB。如果想要增加ORDER BY的速度，首先看是否可以让MySQL使用索引，其次可以尝试增大该值。" >> /etc/my.cnf

echo "read_buffer_size = 160M" >> /etc/my.cnf
echo "# 顺序读缓冲区大小，connection级参数，该参数对应的分配内存是每连接独享。对表进行顺序扫描的请求将分配一个读入缓冲区。" >> /etc/my.cnf

echo "read_rnd_buffer_size = 160M" >> /etc/my.cnf
echo "# 随机读缓冲区大小，connection级参数，该参数对应的分配内存是每连接独享。默认值256KB，最大值4GB。当按任意顺序读取行时，将分配一个随机读缓存区。" >> /etc/my.cnf

echo "join_buffer_size = 320M" >> /etc/my.cnf
echo "# 联合查询缓冲区大小，connection级参数，该参数对应的分配内存是每连接独享。" >> /etc/my.cnf

echo "bulk_insert_buffer_size = 64M" >> /etc/my.cnf
echo "# 批量插入数据缓存大小，可以有效提高插入效率，默认为8M" >> /etc/my.cnf

echo "thread_cache_size = 8" >> /etc/my.cnf
echo "# 服务器线程缓冲池中存放的最大连接线程数。默认值是8，断开连接时如果缓存中还有空间，客户端的线程将被放到缓存中，当线程重新被请求，将先从缓存中读取。" >> /etc/my.cnf
echo "# 根据物理内存设置规则如下：1G  —> 8，2G  —> 16，3G  —> 32，大于3G  —> 64" >> /etc/my.cnf

echo "thread_stack = 256K" >> /etc/my.cnf
echo "# 每个连接被创建时,mysql分配给它的内存。默认192KB，已满足大部分场景，除非必要否则不要动它，可设置范围128KB~4GB。" >> /etc/my.cnf

echo "query_cache_type = 0" >> /etc/my.cnf
echo "# 关闭查询缓存" >> /etc/my.cnf

echo "query_cache_size = 0" >> /etc/my.cnf
echo "# 查询缓存大小，在高并发，写入量大的系统，建议把该功能禁掉。" >> /etc/my.cnf

echo "query_cache_limit = 4M" >> /etc/my.cnf
echo "# 指定单个查询能够使用的缓冲区大小，缺省为1M" >> /etc/my.cnf

echo "tmp_table_size = 1024M" >> /etc/my.cnf
echo "# MySQL的heap（堆积）表缓冲大小，也即内存临时表，默认大小是 32M。如果超过该值，则会将临时表写入磁盘。在频繁做很多高级 GROUP BY 查询的DW环境，增大该值。" >> /etc/my.cnf
echo "# 实际起限制作用的是tmp_table_size和max_heap_table_size的最小值。" >> /etc/my.cnf

echo "max_heap_table_size = 1024M" >> /etc/my.cnf
echo "# 用户可以创建的内存表(memory table)的大小，这个值用来计算内存表的最大行数值。" >> /etc/my.cnf

echo "table_definition_cache = 400" >> /etc/my.cnf
echo "# 表定义缓存区，缓存frm文件。表定义(global)是全局的，可以被所有连接有效的共享。" >> /etc/my.cnf

echo "table_open_cache = 1000" >> /etc/my.cnf
echo "# 所有SQL线程可以打开表缓存的数量，缓存ibd/MYI/MYD文件。 打开的表(session级别)是每个线程，每个表使用。" >> /etc/my.cnf
echo "table_open_cache_instances = 4" >> /etc/my.cnf
echo "# 对table cache 能拆成的分区数，用于减少锁竞争，最大值64." >> /etc/my.cnf

echo "########################################" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "#               Safety                 #" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "########################################" >> /etc/my.cnf
echo "#sql_mode = NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_AUTO_VALUE_ON_ZERO,ONLY_FULL_GROUP_BY" >> /etc/my.cnf
echo "sql_mode = NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER" >> /etc/my.cnf
echo "# MySQL支持的SQL语法模式，与其他异构数据库之间进行数据迁移时，SQL Mode组合模式会有帮助。" >> /etc/my.cnf

echo "local_infile = OFF" >> /etc/my.cnf
echo "# 禁用LOAD DATA LOCAL命令" >> /etc/my.cnf

echo "plugin-load = validate_password.so" >> /etc/my.cnf
echo "# 加密认证插件，强制mysql设置复杂密码" >> /etc/my.cnf

echo "skip-external-locking" >> /etc/my.cnf
echo "#skip-locking" >> /etc/my.cnf
echo "# 避免MySQL的外部锁定，减少出错几率，增强稳定性。" >> /etc/my.cnf

echo "skip-name-resolve" >> /etc/my.cnf
echo "# 禁止MySQL对外部连接进行DNS解析，消除MySQL进行DNS解析。如果开启该选项，所有远程主机连接授权都要使用IP地址方式，否则MySQL将无法正常处理连接请求！" >> /etc/my.cnf

echo "#skip-networking" >> /etc/my.cnf
echo "# 不允许CP/IP连接，只能通过命名管道（Named Pipes）、共享内存（Shared Memory）或Unix套接字（Socket）文件连接。" >> /etc/my.cnf
echo "# 如果Web服务器以远程连接方式访问MySQL数据库服务器，则不要开启该选项，否则无法正常连接！" >> /etc/my.cnf
echo "# 适合应用和数据库共用一台服务器的情况，其他客户端无法通过网络远程访问数据库" >> /etc/my.cnf

echo "########################################" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "#                 Logs                 #" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "########################################" >> /etc/my.cnf
echo "###################   General Log  ######################" >> /etc/my.cnf
echo "general_log = OFF" >> /etc/my.cnf
echo "# 关闭通用查询日志" >> /etc/my.cnf

echo "general_log_file = /ddhome/var/mysql/mysql/general.log" >> /etc/my.cnf
echo "# 通用查询日志存放路径" >> /etc/my.cnf

echo "###################     Slow Log   ######################" >> /etc/my.cnf
echo "slow_query_log = ON" >> /etc/my.cnf
echo "# 开启慢查询日志" >> /etc/my.cnf

echo "slow_query_log_file = /ddhome/var/mysql/mysql/slow.log" >> /etc/my.cnf
echo "# 慢查询日志存放路径" >> /etc/my.cnf

echo "long_query_time = 10" >> /etc/my.cnf
echo "# 超过10秒的查询，记录到慢查询日志，默认值10" >> /etc/my.cnf

echo "log_queries_not_using_indexes = ON" >> /etc/my.cnf
echo "# 没有使用索引的查询，记录到慢查询日志，可能引起慢查询日志快速增长" >> /etc/my.cnf

echo "log_slow_admin_statements = ON" >> /etc/my.cnf
echo "# 执行缓慢的管理语句，记录到慢查询日志" >> /etc/my.cnf
echo "# 例如 ALTER TABLE, ANALYZE TABLE, CHECK TABLE, CREATE INDEX, DROP INDEX, OPTIMIZE TABLE, and REPAIR TABLE." >> /etc/my.cnf

echo "###################     Error Log   ####################" >> /etc/my.cnf
echo "log_error =/ddhome/var/mysql/mysql/error.log" >> /etc/my.cnf
echo "# 错误日志存放路径" >> /etc/my.cnf

echo "log_error_verbosity = 2" >> /etc/my.cnf
echo "# 全局动态变量，默认3，范围：1～3" >> /etc/my.cnf
echo "# 表示错误日志记录的信息，1：只记录error信息；2：记录error和warnings信息；3：记录error、warnings和普通的notes信息" >> /etc/my.cnf

echo "########################################" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "#           Replication                #" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "########################################" >> /etc/my.cnf

echo "###################     Bin Log    ######################" >> /etc/my.cnf
echo "server_id = 1" >> /etc/my.cnf
echo "# 数据库服务器ID" >> /etc/my.cnf

echo "log_bin = /ddhome/local/mysql/mysql/binlog" >> /etc/my.cnf
echo "# 二进制日志存放路径" >> /etc/my.cnf

echo "log_bin_index = /ddhome/local/mysql/mysql/binog/binlog.index" >> /etc/my.cnf
echo "# 同binlog，定义binlog的位置和名称" >> /etc/my.cnf

echo "binlog_format = row" >> /etc/my.cnf
echo "# binlog格式，复制有3种模式STATEMENT，ROW，MIXED" >> /etc/my.cnf

echo "expire_logs_days = 10" >> /etc/my.cnf
echo "# 只保留最近10天的binlog日志" >> /etc/my.cnf

echo "max_binlog_size = 50M" >> /etc/my.cnf
echo "# 每个binlog日志文件的最大容量" >> /etc/my.cnf

echo "binlog_cache_size = 2M" >> /etc/my.cnf
echo "# 每个session分配的binlog缓存大小" >> /etc/my.cnf
echo "# 事务提交前产生的日志，记录到Cache中；事务提交后，则把日志持久化到磁盘" >> /etc/my.cnf

echo "log_slave_updates = ON" >> /etc/my.cnf
echo "# 开启log_slave_updates，从库的更新操作记录进binlog日志" >> /etc/my.cnf

echo "sync_binlog = 1" >> /etc/my.cnf
echo "# sync_binlog=0（默认），事务提交后MySQL不刷新binlog_cache到磁盘，而让Filesystem自行决定，或者cache满了才同步。" >> /etc/my.cnf
echo "# sync_binlog=n，每进行n次事务提交之后，MySQL将binlog_cache中的数据强制写入磁盘。" >> /etc/my.cnf

echo "binlog_rows_query_log_events = ON" >> /etc/my.cnf
echo "# 将row模式下的sql语句，记录到binlog日志，默认是0(off)" >> /etc/my.cnf

echo "###################     Relay Log  ######################" >> /etc/my.cnf
echo "relay_log = /ddhome/var/mysql/mysql/relaylog" >> /etc/my.cnf
echo "# 中继日志存放路径" >> /etc/my.cnf

echo "relay_log_index = /ddhome/var/mysql/mysql/relaylog.index" >> /etc/my.cnf
echo "# 同relay_log，定义relay_log的位置和名称" >> /etc/my.cnf

echo "#binlog_checksum = CRC32" >> /etc/my.cnf
echo "# Session-Thread把Event写到Binlog时，生成checksum。默认为（NONE），兼容旧版本mysql。" >> /etc/my.cnf

echo "master_verify_checksum = ON" >> /etc/my.cnf
echo "# Dump-Thread读Binlog中的Event时，验证checksum" >> /etc/my.cnf

echo "slave_sql_verify_checksum = ON" >> /etc/my.cnf
echo "# 从库的I/O-Thread把Event写入Relaylog时，生成checksum；从库的SQL-Thread从Relaylog读Event时，验证checksum" >> /etc/my.cnf

echo "master_info_repository = TABLE" >> /etc/my.cnf
echo "relay_log_info_repository = TABLE" >> /etc/my.cnf
echo "# 将master.info和relay.info保存在表中，默认是Myisam引擎，官方建议改为Innodb引擎，防止表损坏后自行修复。" >> /etc/my.cnf

echo "relay_log_purge = ON" >> /etc/my.cnf
echo "relay_log_recovery = ON" >> /etc/my.cnf
echo "# 启用relaylog的自动修复功能，避免由于网络之类的外因造成日志损坏，主从停止。" >> /etc/my.cnf

echo "skip_slave_start = OFF" >> /etc/my.cnf
echo "# 重启数据库，复制进程默认不启动" >> /etc/my.cnf

echo "slave_net_timeout = 5" >> /etc/my.cnf
echo "# 当master和slave之间的网络中断，slave的I/O-Thread等待5秒，重连master" >> /etc/my.cnf

echo "sync_master_info = 10000" >> /etc/my.cnf
echo "# slave更新mysql.slave_master_info表的时间间隔" >> /etc/my.cnf

echo "sync_relay_log = 10000" >> /etc/my.cnf
echo "sync_relay_log_info = 10000" >> /etc/my.cnf
echo "# slave更新mysql.slave_relay_log_info表的时间间隔" >> /etc/my.cnf

echo "gtid_mode = ON" >> /etc/my.cnf
echo "enforce_gtid_consistency = ON" >> /etc/my.cnf
echo "# GTID即全局事务ID（global transaction identifier），GTID由UUID+TID组成的。" >> /etc/my.cnf
echo "# UUID是一个MySQL实例的唯一标识，TID代表了该实例上已经提交的事务数量，并且随着事务提交单调递增。" >> /etc/my.cnf
echo "# GTID能够保证每个MySQL实例事务的执行（不会重复执行同一个事务，并且会补全没有执行的事务）。下面是一个GTID的具体形式：" >> /etc/my.cnf
echo "# 4e659069-3cd8-11e5-9a49-001c4270714e:1-77" >> /etc/my.cnf

echo "auto_increment_offset  = 1" >> /etc/my.cnf
echo "# 双主复制中，2台服务器的自增长字段初值分别配置为1和2，取值范围是1 .. 65535" >> /etc/my.cnf

echo "auto_increment_increment = 2" >> /etc/my.cnf
echo "# 双主复制中，2台服务器的自增长字段的每次递增值都配置为2，其默认值是1，取值范围是1 .. 65535" >> /etc/my.cnf

echo "########################################" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "#                InnoDB                #" >> /etc/my.cnf
echo "#                                      #" >> /etc/my.cnf
echo "########################################" >> /etc/my.cnf

echo "innodb_data_home_dir = /ddhome/bin/mysql" >> /etc/my.cnf
echo "# innodb表的数据文件目录" >> /etc/my.cnf

echo "innodb_file_per_table = ON" >> /etc/my.cnf
echo "# 使用独立表空间管理" >> /etc/my.cnf

echo "innodb_data_file_path = ibdata1:1G:autoextend" >> /etc/my.cnf
echo "# InnoDB共享表空间磁盘文件，存放数据字典、和在线重做日志" >> /etc/my.cnf

echo "innodb_log_group_home_dir = /ddhome/bin/mysql" >> /etc/my.cnf
echo "# 在事务被提交并写入到表空间磁盘文件上之前，事务数据存储在InnoDB的redo日志文件里。这些日志位于innodb_log_group_home_dir变量定义的目录中" >> /etc/my.cnf

echo "innodb_buffer_pool_size = 2G" >> /etc/my.cnf
echo "# InnoDB用于缓存数据、索引、锁、插入缓冲、数据字典的缓冲池。该值越大，缓存命中率越高，但是过大会导致页交换。" >> /etc/my.cnf

echo "innodb_buffer_pool_instances = 8" >> /etc/my.cnf
echo "# 开启8个内存缓冲池，把需要缓冲的数据hash到不同的缓冲池中，这样可以并行的内存读写，降低并发导致的内部缓存访问冲突。" >> /etc/my.cnf
echo "# InnoDB缓存系统会把参数innodb_buffer_pool_size指定大小的缓存，平分为innodb_buffer_pool_instances个buffer_pool" >> /etc/my.cnf

echo "#innodb_additional_mem_pool_size = 16M" >> /etc/my.cnf
echo "# InnoDB存储数据字典、内部数据结构的缓冲池大小，类似于Oracle的library cache" >> /etc/my.cnf

echo "innodb_log_file_size = 256M" >> /etc/my.cnf
echo "# InnoDB redo log大小，对应于ib_logfile0文件。" >> /etc/my.cnf
echo "# ib_logfile* 是Innodb多版本缓冲的一个保证，该日志记录redo、undo信息，即commit之前的数据，用于rollback操作" >> /etc/my.cnf
echo "# 官方文档的建议设置是innodb_log_file_size = innodb_buffer_pool_size/innodb_log_files_in_group" >> /etc/my.cnf

echo "innodb_log_buffer_size = 64M" >> /etc/my.cnf
echo "# redo日志所用的内存缓冲区大小" >> /etc/my.cnf

echo "innodb_log_files_in_group = 4" >> /etc/my.cnf
echo "# redo日志文件数，默认值为2，日志是以顺序的方式写入。" >> /etc/my.cnf

echo "innodb_max_dirty_pages_pct = 90" >> /etc/my.cnf
echo "# 缓存池中脏页的最大比例，默认值是75%，如果脏页的数量达到或超过该值，InnoDB的后台线程将开始缓存刷新。" >> /etc/my.cnf
echo "# “缓存刷新”是指InnoDB在找不到干净的可用缓存页或检查点被触发等情况下，InnoDB的后台线程就开始把“脏的缓存页”回写到磁盘文件中。" >> /etc/my.cnf

echo "innodb_flush_log_at_trx_commit = 1" >> /etc/my.cnf
echo "#设置为0 ，每秒 write cache & flush disk" >> /etc/my.cnf
echo "#设置为1 ，每次commit都 write cache & flush disk" >> /etc/my.cnf
echo "#设置为2 ，每次commit都 write cache，然后根据innodb_flush_log_at_timeout（默认为1s）时间 flush disk" >> /etc/my.cnf

echo "innodb_lock_wait_timeout = 10" >> /etc/my.cnf
echo "# InnoDB 有其内置的死锁检测机制，能导致未完成的事务回滚。但是，如果结合InnoDB使用MyISAM的lock tables语句或第三方事务引擎,则InnoDB无法识别死锁" >> /etc/my.cnf
echo "# 为消除这种可能性，可以将innodb_lock_wait_timeout设置为一个整数值，指示MySQL在允许其他事务修改那些最终受事务回滚的数据之前要等待多长时间(秒数)" >> /etc/my.cnf

echo "innodb_sync_spin_loops = 40" >> /etc/my.cnf
echo "# 自旋锁的轮转数，可以通过show engine innodb status来查看。" >> /etc/my.cnf
echo "# 如果看到大量的自旋等待和自旋轮转，则它浪费了很多cpu资源。浪费cpu时间和无谓的上下文切换之间可以通过该值来平衡" >> /etc/my.cnf

echo "innodb_support_xa = ON" >> /etc/my.cnf
echo "# 第一，支持多实例分布式事务（外部xa事务），这个一般在分布式数据库环境中用得较多" >> /etc/my.cnf
echo "# 第二，支持内部xa事务，即支持binlog与innodb redo log之间数据一致性" >> /etc/my.cnf

echo "#innodb_file_format = barracuda" >> /etc/my.cnf
echo "# InnoDB文件格式，Antelope是innodb-base的文件格式，Barracude是innodb-plugin后引入的文件格式，同时Barracude也支持Antelope文件格式" >> /etc/my.cnf

echo "innodb_flush_method = O_DIRECT" >> /etc/my.cnf
echo "# 设置innodb数据文件及redo log的打开、刷写模式，fdatasync(默认)，O_DSYNC，O_DIRECT" >> /etc/my.cnf
echo "# 默认是fdatasync，调用fsync()去刷数据文件与redo log的buffer" >> /etc/my.cnf
echo "# 设置为为O_DSYNC时，innodb会使用O_SYNC方式打开和刷写redo log,使用fsync()刷写数据文件" >> /etc/my.cnf
echo "# 设置为O_DIRECT时，innodb使用O_DIRECT打开数据文件，使用fsync()刷写数据文件跟redo log" >> /etc/my.cnf

echo "innodb_strict_mode = ON" >> /etc/my.cnf
echo "# 开启InnoDB严格检查模式，在某些情况下返回errors而不是warnings，默认值是OFF" >> /etc/my.cnf

echo "innodb_checksum_algorithm = strict_crc32" >> /etc/my.cnf
echo "# checksum函数的算法，默认为crc32。可以设置的值有:innodb、crc32、none、strict_innodb、strict_crc32、strict_none" >> /etc/my.cnf

echo "innodb_status_file = 1" >> /etc/my.cnf
echo "# 启用InnoDB的status file，便于管理员查看以及监控" >> /etc/my.cnf

echo "innodb_open_files = 3000" >> /etc/my.cnf
echo "# 限制Innodb能打开的表的数据，默认为300，数据库里的表特别多的情况，可以适当增大为1000" >> /etc/my.cnf

echo "innodb_thread_concurrency = 8" >> /etc/my.cnf
echo "# 同时在Innodb内核中处理的线程数量。服务器有几个CPU就设置为几，建议默认值。" >> /etc/my.cnf

echo "innodb_thread_sleep_delay = 500" >> /etc/my.cnf

echo "#innodb_file_io_threads = 16" >> /etc/my.cnf
echo "# 文件读写I/O数，这个参数只在Windows上起作用。在LINUX上只会等于４，默认即可。" >> /etc/my.cnf

echo "innodb_read_io_threads = 16" >> /etc/my.cnf
echo "# 设置read thread(读线程个数，默认是4个)" >> /etc/my.cnf

echo "innodb_write_io_threads = 16" >> /etc/my.cnf
echo "# 设置write thread(写线程个数，默认是4个)" >> /etc/my.cnf

echo "innodb_io_capacity = 2000" >> /etc/my.cnf
echo "# 磁盘io的吞吐量，默认值是200.对于刷新到磁盘页的数量，会按照inodb_io_capacity的百分比来进行控制。" >> /etc/my.cnf

echo "log_bin_trust_function_creators = 1" >> /etc/my.cnf
echo "# 开启log-bin后可以随意创建function，存在潜在的数据安全问题。" >> /etc/my.cnf

echo "innodb_purge_threads = 1" >> /etc/my.cnf
echo "# 使用独立线程进行purge操作。" >> /etc/my.cnf
echo "# 每次DML操作都会生成Undo页，系统需要定期对这些undo页进行清理，这称为purge操作。" >> /etc/my.cnf

echo "innodb_purge_batch_size = 32" >> /etc/my.cnf
echo "# 在进行full purge时，回收Undo页的个数，默认是20，可以适当加大。" >> /etc/my.cnf

echo "innodb_old_blocks_pct = 75" >> /etc/my.cnf
echo "# LRU算法，默认值是37，插入到LRU列表端的37%，差不多3/8的位置。" >> /etc/my.cnf
echo "# innodb把midpoint之后的列表称为old列表，之前的列表称为new列表，可以理解为new列表中的页都是最为活跃的热点数据。" >> /etc/my.cnf

echo "innodb_change_buffering = all" >> /etc/my.cnf
echo "# 用来开启各种Buffer的选项。该参数可选的值为：inserts、deletes、purges、changes、all、none" >> /etc/my.cnf
echo "# changes表示启用inserts和deletes，all表示启用所有，none表示都不启用。该参数默认值为all" >> /etc/my.cnf

echo "[mysqldump]" >> /etc/my.cnf
echo "max_allowed_packet = 256M" >> /etc/my.cnf

echo "quick" >> /etc/my.cnf
echo "# mysqldump导出大表时很有用，强制从服务器查询取得记录直接输出，而不是取得所有记录后将它们缓存到内存中。" >> /etc/my.cnf

echo "[mysqlhotcopy]" >> /etc/my.cnf
echo "interactive-timeout" >> /etc/my.cnf

echo "[mysqld_safe]" >> /etc/my.cnf
echo "#ledir = /ddhome/bin/mysql/bin" >> /etc/my.cnf
echo "# 包含mysqld程序的软件安装路径，用该选项来显式表示服务器位置。" >> /etc/my.cnf

echo "#" >> /etc/my.cnf
echo "# include all files from the config directory" >> /etc/my.cnf
echo "#" >> /etc/my.cnf
echo "!includedir /etc/my.cnf.d" >> /etc/my.cnf

cp support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
sed -i '45d' /etc/init.d/mysqld
sed -i '46d' /etc/init.d/mysqld
sed -i '47d' /etc/init.d/mysqld
sed -i  "45a basedir=/ddhome/bin/mysql" /etc/init.d/mysqld
sed -i  "46a datadir=/ddhome/local/mysql/mysql" /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig --list mysqld

cd /ddhome/bin/mysql
chgrp -R mysql .
chown -R mysql .

#sudo systemctl start mysqld
#yum install -y perl-Module-Install.noarch
#touch /ddhome/bin/mysql/mysql.pid

/ddhome/bin/mysql/bin/mysqld --defaults-file=/etc/my.cnf --initialize --user=mysql --basedir=/ddhome/bin/mysql --datadir=/ddhome/local/mysql/mysql/data
systemctl start mysqld
chown -R mysql:mysql /ddhome/local/mysql/mysql/data
chmod 755 /ddhome/local/mysql/mysql/data
systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl status mysqld.service
/ddhome/bin/mysql/bin/mysqld_safe --skip-grant-tables & <<EOF
mysql -uroot -p
use mysql;
alter user 'root'@'localhost' identified by 'root';
flush  privileges;
grant all privileges on *.* to 'root'@'%' identified by 'root' with grant option;
flush  privileges;
EOF
