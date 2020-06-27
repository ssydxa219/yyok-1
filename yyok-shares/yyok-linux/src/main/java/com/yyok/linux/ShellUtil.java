package com.yyok.linux;

import com.jcraft.jsch.*;
import expect4j.Expect4j;
import expect4j.matches.EofMatch;
import expect4j.matches.Match;
import expect4j.matches.RegExpMatch;
import expect4j.matches.TimeoutMatch;
import org.apache.commons.lang3.StringUtils;
import org.apache.oro.text.regex.MalformedPatternException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

public class ShellUtil extends Shell {

    //private static Logger log = LoggerFactory.getLogger(ShellUtil.class);

    private static final int DEFAULT_TIME_OUT = 1000;
    private static final int CONNECT_TIME_OUT = 3000;
    private static final int COMMAND_EXECUTION_SUCCESS_OPCODE = -2;

    public static final String BACKSLASH_R = "\r";
    public static final String BACKSLASH_N = "\n";
    public static final String COLON_CHAR = ":";
    public static String ENTER_CHARACTER = BACKSLASH_R;

    private Session session;
    private ChannelShell channel;
    private Expect4j expect = null;
    private JSch jsch;
    private StringBuffer buffer;

    // Threaded session variables
    private boolean closed = false;

    // 正则匹配，用于处理服务器返回的结果
    public static String[] linuxPromptRegEx = new String[]{"~]$", "~]#", "~#", "#", ":~#", "/$", ">"};

    public static String[] errorMsg = new String[]{"could not acquire the config lock "};

    ShellUtil(){}

    /**
     * 利用JSch包实现远程主机SHELL命令执行, 链接远程主机
     *
     * @param ip         主机IP
     * @param user       主机登陆用户名
     * @param psw        主机登陆密码
     * @param port       主机ssh2登陆端口，如果取默认值，传-1
     * @param privateKey 密钥文件路径
     * @param passphrase 密钥的密码
     */
    ShellUtil(String ip, String user, String psw, int port, String privateKey, String passphrase) {
        buffer = new StringBuffer();
        connect(ip, user, psw, port, privateKey, passphrase);
    }

    /**
     * 利用JSch包实现远程主机SHELL命令执行, 链接远程主机 获得Expect4j对象，该对用可以往SSH发送命令请求
     *
     * @param ip         主机IP
     * @param user       主机登陆用户名
     * @param psw        主机登陆密码
     * @param port       主机ssh2登陆端口，如果取默认值，传-1
     * @param privateKey 密钥文件路径
     * @param passphrase 密钥的密码
     */
    void connect(String ip, String user, String psw, int port, String privateKey, String passphrase) {
        //log.info("---------- connect ssh ----------");
        try {
            //  log.debug(String.format("Start logging to %s@%s:%s", user, ip, port));
            jsch = new JSch();
            addIdentity(privateKey, passphrase);
            ;
            session(ip, user, psw, port);
            expect();
            // log.debug(String.format("Logging to %s@%s:%s successfully!", user, ip, port));
        } catch (Exception ex) {
            expect = null;
            //log.error("Connect to " + ip + ":" + port + "failed,please check your username and password!");
        }
    }

    /**
     * 执行配置命令
     *
     * @param commands 要执行的命令，为字符数组
     * @return 执行是否成功
     */
    boolean executeCommands(String... commands) {
        // 如果expect返回为0，说明登入没有成功
        if (expect == null) {
            return false;
        }

        /*if (log.isDebugEnabled()) {
            log.debug("----------Running commands are listed as follows:----------");
            log.debug(Arrays.toString(commands));
            log.debug("----------End----------");
        }*/

        try {
            List<Match> lstPattern = lstPattern();
            boolean isSuccess = true;
            for (String strCmd : commands) {
                isSuccess = executeCommand(lstPattern, strCmd);
            }
            // 防止最后一个命令执行不了
            isSuccess = !checkResult(expect.expect(lstPattern));

            // 找不到错误信息标示成功
            String response = buffer.toString().toLowerCase();
            for (String msg : errorMsg) {
                if (response.indexOf(msg) > -1) {
                    return false;
                }
            }

            return isSuccess;
        } catch (Exception ex) {
            //log.error(ex.getLocalizedMessage(), ex);
            return false;
        }
    }

    /**
     * 关闭SSH远程连接
     */
    protected void disconnect() {

        if (expect != null) {
            expect.close();
        }
        if (channel != null) {
            channel.disconnect();
        }
        if (session != null) {
            session.disconnect();
        }
        //log.info("---------- disconnect ssh ----------");
    }

    @Override
    public void close() {
        if (!this.closed) {
            disconnect();
            this.closed = true;
        }
    }

    /**
     * 获取服务器返回的信息
     *
     * @return 服务端的执行结果
     */
    public String getResponse() {
        return buffer.toString();
    }

    private void expect() throws JSchException, IOException {
        channel = (ChannelShell) session.openChannel("shell");
        expect = new Expect4j(channel.getInputStream(), channel.getOutputStream());
        channel.connect(CONNECT_TIME_OUT);
    }

    private void session(String ip, String user, String psw, int port) throws JSchException {
        if (port <= 0) {
            session = jsch.getSession(user, ip);
        } else {
            session = jsch.getSession(user, ip, port);
        }

        if (session == null) {
            throw new JSchException("Jsch session is null");
        }
        session.setPassword(psw);
        Hashtable<String, String> config = new Hashtable<String, String>();
        config.put("StrictHostKeyChecking", "no");
        session.setConfig(config);
        localUserInfo ui = new localUserInfo();
        session.setUserInfo(ui);
        session.connect();
    }

    /**
     * 设置ssh 免密登陆
     * <p>
     * //* @param jsch
     *
     * @param privateKey
     * @param passphrase //* @throws JSchException
     */
    private void addIdentity(String privateKey, String passphrase) throws JSchException {
        if (StringUtils.isBlank(privateKey)) {
            return;
        }

        if (passphrase != null && "".equals(passphrase)) {
            //设置带口令的密钥
            jsch.addIdentity(privateKey, passphrase);
        } else {
            //设置不带口令的密钥
            jsch.addIdentity(privateKey);
        }
    }

    /**
     * @return
     * @throws MalformedPatternException
     */
    private List<Match> lstPattern() throws MalformedPatternException {
        List<Match> lstPattern = new ArrayList<Match>();
        String[] regEx = linuxPromptRegEx;
        if (regEx != null && regEx.length > 0) {
            synchronized (regEx) {
                // list of regx like, :>, />
                // etc. it is possible
                // command prompts of your
                // remote machine
                for (String regexElement : regEx) {
                    RegExpMatch mat = new RegExpMatch(regexElement, x -> {
                        buffer.append(x.getBuffer());
                        x.exp_continue();
                    });
                    lstPattern.add(mat);
                }
                lstPattern.add(new EofMatch(x -> {
                }));
                lstPattern.add(new TimeoutMatch(DEFAULT_TIME_OUT, x -> {
                }));
            }
        }
        return lstPattern;
    }

    // 检查执行是否成功
    private boolean executeCommand(List<Match> objPattern, String strCommandPattern) {
        try {
            boolean isFailed = checkResult(expect.expect(objPattern));
            if (!isFailed) {
                expect.send(strCommandPattern);
                expect.send("\r");
                return true;
            }
            return false;
        } catch (MalformedPatternException ex) {
            return false;
        } catch (Exception ex) {
            return false;
        }
    }

    // 检查执行返回的状态
    private boolean checkResult(int intRetVal) {
        if (intRetVal == COMMAND_EXECUTION_SUCCESS_OPCODE) {
            return true;
        }
        return false;
    }

    // 登入SSH时的控制信息
    // 设置不提示输入密码、不显示登入信息等
    private static class localUserInfo implements UserInfo {
        String passwd;

        public String getPassword() {
            return passwd;
        }

        public boolean promptYesNo(String str) {
            return true;
        }

        public String getPassphrase() {
            return null;
        }

        public boolean promptPassphrase(String message) {
            return true;
        }

        public boolean promptPassword(String message) {
            return true;
        }

        public void showMessage(String message) {

        }
    }

    /**
     * 远程 执行命令并返回结果调用过程 是同步的（执行完才会返回）
     *
     * @param host    主机名
     * @param user    用户名
     * @param psw     密码
     * @param port    端口
     * @param command 命令
     * @return
     */
    public static String exec(String host, String user, String psw, int port, String command) {
        String result = "";
        Session session = null;
        ChannelExec openChannel = null;
        try {
            JSch jsch = new JSch();
            session = jsch.getSession(user, host, port);
            java.util.Properties config = new java.util.Properties();
            config.put("StrictHostKeyChecking", "no");
            session.setConfig(config);
            session.setPassword(psw);
            session.connect();
            openChannel = (ChannelExec) session.openChannel("exec");
            openChannel.setCommand(command);
            int exitStatus = openChannel.getExitStatus();
            //System.out.println(exitStatus);
            openChannel.connect();
            InputStream in = openChannel.getInputStream();
            BufferedReader reader = new BufferedReader(new InputStreamReader(in));
            String buf = null;
            while ((buf = reader.readLine()) != null) {
                result += new String(buf.getBytes("gbk"), "UTF-8") + "\r";
            }
        } catch (JSchException | IOException e) {
            result += e.getMessage();
        } finally {
            if (openChannel != null && !openChannel.isClosed()) {
                openChannel.disconnect();
            }
            if (session != null && session.isConnected()) {
                session.disconnect();
            }
        }
        return result;
    }


    public static void exechostressh(String hosts[]) {
        String commonrsa = "[ ! -f /root/.ssh/id_rsa.pub ] && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa";
        for (String host : hosts) {
            String infos[] = host.split(" ");
            String ip = infos[0];
            String mn = infos[1];
            String un = infos[2];
            String pwd = infos[3];
            exec(ip, un, pwd, 22, "rm -rf /root/.ssh/* ");
            exec(ip, un, pwd, 22, commonrsa);

        }
    }

    public static void exechostssh(String hosts[]) {
        String commonrsapub = "cat /root/.ssh/id_rsa.pub";

        for (String host : hosts) {
            String infos[] = host.split(" ");
            String ip = infos[0];
            String mn = infos[1];
            String un = infos[2];
            String pwd = infos[3];
            //exec(ip, un, pwd, 22, "echo \"127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4\" >/etc/hosts");
            //exec(ip, un, pwd, 22, "echo \"::1   authorized_keys      localhost localhost.localdomain localhost6 localhost6.localdomain6\" >>/etc/hosts");
            for (String hosta : hosts) {
                String infoa[] = hosta.split(" ");
                String ipa = infoa[0];
                String mna = infoa[1];
                String una = infoa[2];
                String pwda = infoa[3];
                String execrsapub = exec(ipa, una, pwda, 22, commonrsapub);
                exec(ip, un, pwd, 22, "echo '" + execrsapub + "'>> /root/.ssh/authorized_keys && ! cat /etc/hosts | grep '"+ ipa + " " + mna + " && echo '" + ipa + " " + mna + "'>> /etc/hosts && ! cat /etc/ssh/ssh_config | grep \"StrictHostKeyChecking no\"  && echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config && exit 0;");
                //将其中的PermitRootLogin no修改为yes，
                // PubkeyAuthentication yes修改为no，
                // AuthorizedKeysFile .ssh/authorized_keys前面加上#屏蔽掉，
                // PasswordAuthentication no修改为yes就可以了。
                //StrictHostKeyChecking ask 改成 StrictHostKeyChecking no
                //exec(ip, un, pwd, 22, "! cat /etc/ssh/ssh_config | grep \"StrictHostKeyChecking no\"  && echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config");
            }

            System.out.println("--------------exechostssh--" + host + "--------------");
        }
    }

    public static void execyums(String hosts[]) {
        for (String host : hosts) {
            String infos[] = host.split(" ");
            String ip = infos[0];
            String mn = infos[1];
            String un = infos[2];
            String pwd = infos[3];
            //groupinstall "Development tools"
            exec(ip, un, pwd, 22, "yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel ntp ntpdate vim wget gcc gcc-c++ make cmake autoconf");// curl curl-devel bash-completion lsof iotop iostat unzip bzip2 bzip2-devel openssl-devel openssl-perl net-tools iotop iftop net-tools lrzsz libxml2-devel openssl-devel curl curl-devel unzip sudo ntp libaio-devel wget vim ncurses-devel autoconf automake zlib-devel  python-devel bash-completion lsof httpd-devel automake autoconf libtool ncurses-devel libxslt groff pcre-devel pkgconfig gcc gcc-c++ kernel-devel gcc-essential gcc-gfortran build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev libgnomeui-devel gtk2 gtk2-devel gtk2-devel-docs gnome-devel gnome-devel-docs libavcodec-dev libavformat-dev libswscale-dev epel-release ffmpeg ffmpeg-devel python-devel numpy libdc1394-devel libv4l-devel gstreamer-plugins-base-devel zlib* libffi-devel zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel krb5-devel cyrus-sasl-gssapi cyrus-sasl-deve libxml2-devel libxslt-devel");
            exec(ip, un, pwd, 22, "ntpdate 0.asia.pool.ntp.org && hwclock --systohc && hwclock -w");
            //exec(ip, un, pwd, 22, "yum -y update");
            System.out.println("-------------execyums--------" + mn);
        }
    }

    public static void execenv(String hosts[]) {
        for (String host : hosts) {
            String infos[] = host.split(" ");
            String ip = infos[0];
            String mn = infos[1];
            String un = infos[2];
            String pwd = infos[3];
            //exec(ip, un, pwd, 22,"alternatives --config java");
            exec(ip, un, pwd, 22,
                    /*"! cat /etc/profile | grep \"BASE_HOME=\" && echo 'BASE_HOME=/ddhome/bin' >>/etc/profile "+
                    "! cat /etc/profile | grep \"jdk1.8.0_221-amd64\" && echo 'export JAVA_HOME=/usr/java/jdk1.8.0_221-amd64/' >>/etc/profile "+
                    "! cat /etc/profile | grep \"CLASSPATH\" && echo 'export CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar' >>/etc/profile "+
                    "! cat /etc/profile | grep \"JAVA_HOME\" && echo 'export PATH=$PATH:${JAVA_HOME}/bin' >>/etc/profile "+
                    "! cat /etc/profile | grep \"SCALA_HOME=\" && echo 'export SCALA_HOME=${BASE_HOME}/scala' >>/etc/profile "+
                    "! cat /etc/profile | grep \"SCALA_HOME\" && echo 'export PATH=$PATH:${SCALA_HOME}/bin' >>/etc/profile "+
                    "! cat /etc/profile | grep \"ZOOKEEPER_HOME=\" && echo 'export ZOOKEEPER_HOME=${BASE_HOME}/zookeeper' >>/etc/profile "+
                    "! cat /etc/profile | grep \"ZOOKEEPER_HOME\" && echo 'export PATH=$PATH:${ZOOKEEPER_HOME}/bin' >>/etc/profile "+
                    "! cat /etc/profile | grep \"FLINK_HOME=\" && echo 'export FLINK_HOME=${BASE_HOME}/flink' >>/etc/profile "+
                    "! cat /etc/profile | grep \"FLINK_HOME\" && echo 'export PATH=$PATH:${FLINK_HOME}/bin' >>/etc/profile "
                    "&& echo 'export MAVEN_HOME=${BASE_HOME}/maven' >>/etc/profile "+
                    "&& echo 'export PATH=$PATH:${MAVEN_HOME}/bin' >>/etc/profile "+
                    "&& echo 'export ZOOKEEPER_HOME=${BASE_HOME}/zookeeper' >>/etc/profile "+
                    "&& echo 'export PATH=$PATH:${ZOOKEEPER_HOME}/bin' >>/etc/profile "+
                    "&& echo 'export HADOOP_HOME=${BASE_HOME}/hadoop' >>/etc/profile "+
                    "&& echo 'export HADOOP_PREFIX=$HADOOP_HOME' >>/etc/profile "+
                    "&& echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >>/etc/profile "+
                    "&& echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >>/etc/profile "+
                    "&& echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >>/etc/profile "+
                    "&& echo 'export YARN_HOME=$HADOOP_HOME' >>/etc/profile "+
                    "&& echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >>/etc/profile "+
                    "&& echo 'export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin' >>/etc/profile "+*/
                    "&& echo 'export HBASE_HOME=${BASE_HOME}/hbase' >>/etc/profile "+
                    "&& echo 'export PATH=$PATH:${HBASE_HOME}/bin' >>/etc/profile "

            );
            exec(ip, un, pwd, 22,"source /etc/profile");
        }
    }

    public static void execopt(String hosts[]) {
        for (String host : hosts) {
            String infos[] = host.split(" ");
            String ip = infos[0];
            String mn = infos[1];
            String un = infos[2];
            String pwd = infos[3];
            exec(ip, un, pwd, 22,
                    "sed -i 's/localhost.localdomain/" + mn + "/g' /etc/hostname " +
                    "&& sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config " +
                    "&& systemctl disable firewalld.service " +
                    "&& systemctl stop firewalld.service " +
                    "&& echo 'ulimit -SHn 102400' >> /etc/rc.local" +
                    "&& echo '*           soft   nofile       655350' >>/etc/security/limits.conf" +
                    "&& echo '*           hard   nofile       655350' >>/etc/security/limits.conf" +
                    "&& echo 'vm.overcommit_memory = 1'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.ip_local_port_range = 1024 65536'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.tcp_fin_timeout = 1'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.tcp_keepalive_time = 1200'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.tcp_mem = 94500000 915000000 927000000'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.tcp_tw_reuse = 1'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.tcp_tw_recycle = 1'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.tcp_timestamps = 0'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.tcp_synack_retries = 1'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.tcp_syn_retries = 1'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.tcp_abort_on_overflow = 0'>> /etc/sysctl.conf" +
                    "&& echo 'net.core.rmem_max = 16777216'>> /etc/sysctl.conf" +
                    "&& echo 'net.core.wmem_max = 16777216'>> /etc/sysctl.conf" +
                    "&& echo 'net.core.netdev_max_backlog = 262144'>> /etc/sysctl.conf" +
                    "&& echo 'net.core.somaxconn = 262144'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.tcp_max_orphans = 3276800'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.tcp_max_syn_backlog = 262144'>> /etc/sysctl.conf" +
                    "&& echo 'net.core.wmem_default = 8388608'>> /etc/sysctl.conf" +
                    "&& echo 'net.core.rmem_default = 8388608'>> /etc/sysctl.conf" +
                    "&& echo 'net.ipv4.netfilter.ip_conntrack_max = 2097152'>> /etc/sysctl.conf" +
                    "&& echo 'net.nf_conntrack_max = 655360'>> /etc/sysctl.conf" +
                    "&& echo 'net.netfilter.nf_conntrack_tcp_timeout_established = 1200'>> /etc/sysctl.conf"
            );

            System.out.println("-----------execopt----------" + mn);
        }
    }

    public static void execreboot(String hosts[]) {
        for (String host : hosts) {
            String infos[] = host.split(" ");
            String ip = infos[0];
            String mn = infos[1];
            String un = infos[2];
            String pwd = infos[3];
            //groupinstall "Development tools"
            exec(ip, un, pwd, 22, "reboot");
            System.out.println("---------------------reboot--" + mn);
        }
    }

    public static void execmkdir(String hosts[],String dir) {

        for (String host : hosts) {
            String infos[] = host.split(" ");
            String ip = infos[0];
            String mn = infos[1];
            String un = infos[2];
            String pwd = infos[3];
            //groupinstall "Development tools"
            exec(ip, un, pwd, 22, "mkdir -p /"+dir+"/{bin,tmp,src,usr,var,local}");
            exec(ip, un, pwd, 22, "chmod -R 755 " +dir);
            System.out.println("---------------------execmkdir--" + mn);
        }
    }

    public static void execchmod(String hosts[],int auths , String dirs) {

        for (String host : hosts) {
            String infos[] = host.split(" ");
            String ip = infos[0];
            String mn = infos[1];
            String un = infos[2];
            String pwd = infos[3];
            //groupinstall "Development tools"
            exec(ip, un, pwd, 22, "chmod -R "+auths+" "+dirs);
            System.out.println("---------------------execchmod--" + mn);
        }
    }

    public static void execscps(String fromhosts,String tohosts[],String fromdir,String todirs) {

        for (String host : tohosts) {
            String infos[] = host.split(" ");
            String ip = infos[0];
            String mn = infos[1];
            String un = infos[2];
            String pwd = infos[3];
            String execscpstr="scp -r "+fromdir+" root@"+mn+":/"+todirs;
            //groupinstall "Development tools"
            exec(ip, un, pwd, 22, "echo "+ execscpstr +">> /ddhome/bin/scp");
            System.out.println("---------------------execscps--  scp -r "+fromdir+" root@"+mn+":/"+todirs);
        }

    }

    public static void execsdown(String ip,String un,String pwd) {
        exec(ip, un, pwd, 22,"wget https://apache.org/dist/zookeeper/stable/apache-zookeeper-3.5.6-bin.tar.gz /ddhome/src");
    }

    public static void execzkinstall(String zkhosts[],String dir) {
        String host= zkhosts[0];
        String info[] = host.split(" ");
        String ip = info[0];
        String mn = info[1];
        String un = info[2];
        String pwd = info[3];
        exec(ip, un, pwd, 22, "mv /root/apache-zookeeper-3.5.6-bin.tar.gz /ddhome/bin/ &&　tar -zxvf /ddhome/bin/apache-zookeeper-3.5.6-bin.tar.gz && mv /ddhome/bin/apache-zookeeper-3.5.6 /ddhome/bin/zookeeper");
        exec(ip, un, pwd, 22, "cp /ddhome/bin/zookeeper/conf/zoo_sample.cfg /ddhome/bin/zookeeper/conf/zoo.cfg");
        exec(ip, un, pwd, 22, "echo　\"server.\"++\"=\" >>/ddhome/bin/zookeeper/conf/zoo.cfg");
        exec(ip, un, pwd, 22, "echo　\" >>/ddhome/local/zookeeper/myid");
    }


    public static void exechadoopinstall(String hosts[],String dir) {
        String host= hosts[0];
        String info[] = host.split(" ");
        String ip = info[0];
        String mn = info[1];
        String un = info[2];
        String pwd = info[3];
        //exec(ip, un, pwd, 22,"wget http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-3.1.3/hadoop-3.1.3.tar.gz");
        //exec(ip, un, pwd, 22,"mv /root/hadoop-3.1.3.tar.gz /ddhome/bin/");
        //exec(ip, un, pwd, 22,"tar -zxvf /ddhome/bin/hadoop-3.1.3.tar.gz");
        //exec(ip, un, pwd, 22, "mv /ddhome/bin/hadoop-3.1.3 /ddhome/bin/hadoop");


    }
}