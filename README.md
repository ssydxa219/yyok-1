

----------------
开发规范说明:
----------------
   * [一、命名风格] 文件名须反映出其实现了什么类 – 包括大小写.(简洁)
   * [二、名称定义] 驼峰格式分割单词：类名（以及类别、协议名）应首字母大写;方法;变量名应该以小写字母开头;常量大写;包小写。
   * [三、代码格式] code style formatter.
   * [四、OOP规约] 当一个类有多个构造方法，或者多个同名方法，这些方法应该按顺序放置在一起;加强对静态类的管理
   * [五、集合处理].
   * [六、并发处理].       
   * [七、注释规约].
   * [八、模块规约]. 按demo格式
   * [九、README.md] 一定要写，先写业务逻辑，再开发.
   * [十、需求流程] 需求采集  
   * [十一、微服务开发规范] 所有上传的服务均需基于spring boot框架
   
# 项目目录
```````````
yyok
│─yyok-apis         apis模块组合区
│   ├─yyok-ewms-apis  应急物资对外api
│─yyok-clients      公共对外API
│─yyok-dists        web模块组合区
│   ├─yyok-ewms     应急物资web模块组合
├─yyok-docs         项目文档
│─yyok-libs         公共业务功能模块
│   ├─yyok-activity 应急物资流程模块
│   │    ├─yyok-activity-instruct    应急指令流程业务模块
│   │    ├─yyok-activity-storage    仓储流程业务模块
│   │    ├─yyok-activity-allocate   调拨流程业务模块
│   │    │  ├─yyok-activity-allocate   调拨流程业务模块
│   │    │  ├─yyok-activity-allocate   调拨流程业务模块
│   ├─yyok-emergencies 应急业务模块
│   │    ├─yyok-emergencie-info        应急信息
│   │    ├─yyok-emergencie-instruct    应急指令
│   ├─yyok-surveillancecamera     监控业务模块
│   │    ├─yyok-surveillancecamera-list  监控列表与物资信息相关联    
│   ├─yyok-wms   物资管理业务模块
│   │    ├─yyok-storage       仓储业务模块
│   │    │  ├─yyok-storage-infos 仓储信息模块
│   │    │  │   ├─yyok-storage-info-materials  物资信息管理
│   │    │  │   ├─yyok-storage-info-documents  物资单证管理
│   │    │  ├─yyok-storage-core 仓储核心模块
│   │    │  │   ├─yyok-storage-core-ins  入库
│   │    │  │   ├─yyok-storage-core-outs 出库
│   │    │  │   ├─yyok-storage-core-recieve  入出库信息接收
│   │    │  │   ├─yyok-storage-core-inventory  库存盘点
│   │    ├─yyok-allocate      调拨业务模块
│─yyok-services     应急物资服务模块
│   ├─yyok-ewms-services 应急物资服务模块（组合yyok-libs的子模块）
│─yyok-shares       公共功能模块
│   ├─yyok-admins      公共组件模块
│   │    ├─yyok-authority      统一授权服务服务
│   │    ├─yyok-authorization  统一认证服务服务
│   │    ├─yyok-authoritycli      统一授权服务客户端
│   │    ├─yyok-authorizationcli  统一认证服务客户端
│   │    ├─yyok-user  统一用户中心
│   ├─yyok-clouds 公共云服务中心
│   │    ├─yyok-nacos  服务注册中心、配置中心
│   │    ├─yyok-gateway 网关服务
│   │       ├─yyok-gateway-core 公共组件模块
│   │       ├─yyok-gateway-feign 公共Feign模块
│   │       ├─yyok-gateway-gateway 网关限流模块
│   │       ├─yyok-gateway-interceptor 公共拦截器模块
│   │       ├─yyok-gateway-mp 公共mybatis plus 的一些配置
│   │       ├─yyok-gateway-rabbitmq MQ生产者和一些配置
│   │       ├─yyok-gateway-resource 公共资源服务模块
│   ├─yyok-linux    linux
│   ├─yyok-persistent     持久化模块
│   │   ├─yyok-persistent-mysql 持久化模块-mysql
│   │   ├─yyok-persistent-redis 持久化模块-redis
│   │   ├─yyok-persistent-kafka 持久化模块-kafka
│   │   ├─yyok-persistent-zookeeper 持久化模块-zookeeper
│   │   ├─yyok-persistent-mybatisplus 公共mybatis plus 的一些配置
│   ├─yyok-providers 公共模块
│   ├─yyok-schedules  调度
│   ├─yyok-sessions   公共SESSION
│   ├─yyok-springx 公共调度模块

````````````````

开发工具说明:
----------------
   * JDK1.8 click the link ＆ down the [jdk-8u192-linux-x64.rpm](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) file and install（rpm -ivh jdk-8u192-linux-x64.rpm） default dir /usr/java/.
   * SCALA2.11.0 click the link ＆ down the [scala-2.11.12.tgz](https://downloads.lightbend.com/scala/2.11.0/scala-2.11.0.tgz) file and instalL default dir /ddhome/bin/scala.
   * IntelliJ IDEA IDEA 2019 tar linux down [IntelliJ IDEA IDEA 2019 for linux](https://www.jetbrains.com/idea/download/download-thanks.html?platform=linux).
   * IntelliJ IDEA IDEA 2019 exe windows down [IntelliJ IDEA IDEA 2019 for windows](https://www.jetbrains.com/idea/download/download-thanks.html?platform=windows).
   * IntelliJ IDEA [IntelliJ IDEA 2019 注册码](http://idea.lanyus.com/)
   * Download [Eclipse Technology](http://www.eclipse.org/downloads/)
   * Download [Apache Maven 3.6.0](http://mirrors.hust.edu.cn/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz) 
   * Open the zk [zookeeper](hxa,hxb,hxc).
   * Open the Haddop [WebHDFS]( nn:hxa,hxb;dn:hxe,hxf,hxg,hxh,hxi,hxj) .
   * Open the YARN [MapReduce](ra:hxc,hxd;rm:hxe,hxf,hxg,hxh,hxi,hxj)，plz copy (http://www.hxdi.com:8088) .
   * Open the Hbase [Hbase Master](http://www.hxdi.com:60010) & [Hbase RegionServer](http://www.hxdi.com:16030)，plz copy (http://www.hxdi.com:60010,16030) .
   * Open the Spark [Spark Wen-UI](http://www.hxdi:8080)，plz copy (um:superuser;pwd:mgNTS0EMshqhcQBa) .  
   * Open the Hive [webUi](http://www.hxdi:9903)，plz copy (http://www.hxdi:9903) .   
   * Open the Hue [Hue Wen-UI](http://www.hxdi:9901)，plz copy (um:superuser;pwd:mgNTS0EMshqhcQBa) .  
   * Open the Azkaban [webUi](http://10.10.3.189:18888)，plz copy (url:http://10.10.3.189:18888;un：hxdi  pwd:hxpti .   
   * Open the ketter [ketter.tar](http://www.hxdi:50070/dfshealth.html)，plz copy (http://www.hxdi:50070) . 
   * Open the Datax [Datax.tar](http://www.hxdi:50070/dfshealth.html)，plz copy (http://www.hxdi:50070)  
   * Open the Spark sql web [Datax.tar](http://www.hxdi:50070/dfshealth.html)，plz copy (http://www.hxdi:50070)   
   
   
开发环境说明:(centos  7.4+)
=====
OS优化
----------------
   * /etc/profile.
   * /etc/hosts.
   * /etc/selinux/config
   * /etc/resolv.conf.
   * yum -y install ntp
   * ntpdate cn.pool.ntp.org
   * echo "ulimit -SHn 102400" >> /etc/rc.local
   * /etc/security/limits.conf
   * systemctl disable firewalld.service 
   * systemctl stop firewalld.service
   * /etc/sysctl.conf
   * /sbin/sysctl -p
   * /root/.vimrc

环境配置
----------------
``````
   export JAVA_HOME=/usr/java/jdk1.8.0_221-amd64
   export CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
   export PATH=$PATH:${JAVA_HOME}/bin
   export SCALA_HOME=/ddhome/bin/scala
   export PATH=$PATH:${SCALA_HOME}/bin
   export MAVEN_HOME=/ddhome/bin/maven
   export PATH=$PATH:${MAVEN_HOME}/bin
   export PROTOC_HOME=/ddhome/bin/protobuf
   export PATH=$PATH:$PROTOC_HOME/bin
   export ZOOKEEPER_HOME=/ddhome/bin/zookeeper
   export PATH=$PATH:${ZOOKEEPER_HOME}/bin
   export HADOOP_HOME=/ddhome/bin/hadoop
   export HADOOP_PREFIX=$HADOOP_HOME
   export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
   export HADOOP_MAPRED_HOME=$HADOOP_HOME
   export HADOOP_COMMON_HOME=$HADOOP_HOME
   export HADOOP_HDFS_HOME=$HADOOP_HOME
   export YARN_HOME=$HADOOP_HOME
   export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
   export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
   export HADOOP_INSTALL=$HADOOP_HOME
   export HBASE_HOME=/ddhome/bin/hbase
   export PATH=$PATH:${HBASE_HOME}/bin
   export FINDBUGS_HOME=/ddhome/bin/findbugs
   export PATH=$PATH:$FINDBUGS_HOME/bin
   export SPARK_HOME=/ddhome/bin/spark
   export PATH=$PATH:{SPARK_HOME}/bin

使用依赖技术环境及版本
-------------------
<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
<project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
<maven.compiler.encoding>UTF-8</maven.compiler.encoding>
<maven.compiler.source>1.8</maven.compiler.source>
<maven.compiler.target>1.8</maven.compiler.target>
<maven.test.skip>true</maven.test.skip>
<spring.version>5.2.5.RELEASE</spring.version>
<spring-cloud.version>Greenwich.SR5</spring-cloud.version>
<spring-boot.version>2.2.4.RELEASE</spring-boot.version>
<spring-data.version>2.2.5.RELEASE</spring-data.version>
<spring-security.version>5.2.2.RELEASE</spring-security.version>
<spring-cloud-platform.version>2.2.1.RELEASE</spring-cloud-platform.version>
<spring-security-oauth2.version>2.3.5.RELEASE</spring-security-oauth2.version>
<spring-platform.version>Cairo-SR8</spring-platform.version>
<hutool.version>4.4.5</hutool.version>
<mybatis-plus.version>3.3.1</mybatis-plus.version>
<mybatis-boot.version>2.1.1</mybatis-boot.version>
<kaptcha.version>0.0.9</kaptcha.version>
<swagger.version>2.9.2</swagger.version>
<mysql.connector.version>5.1.39</mysql.connector.version>
<security.oauth.version>2.3.5.RELEASE</security.oauth.version>
<security.oauth.auto.version>2.1.2.RELEASE</security.oauth.auto.version>
<curator.version>2.10.0</curator.version>
<jackson.modules>2.10.2</jackson.modules>
<redis.version>3.1.0</redis.version>
<servlet.version>4.0.1</servlet.version>
```````
| NO. |  技术   |   版本   |
| ---- | ---- | ---- |
|  01 |   jdk   |   1.8   |
|  02 |   Spring-platform   |   5.2.4.RELEASE   |
|  03 |   Spring Boot   |   2.2.5.RELEASE   |
|  04 |   Spring Cloud 系列   |   Greenwich.SR5   |
|  05 |   nacos   |   2.1.1.RELEASE  |
|  06 |   spring-security-oauth2   |   2.3.5.RELEASE   |
|  07 |   mybatis-plus   |   3.1.0   |
|  08 |   mysql   |   5.7+ 、<8.0  |
|  09 |   bootstrap   |   3.7+     |
|  10 |   swagger   |   2.9.2     |

Using dev evn
----------------
  * MYSQL ENV [mysql url](jyyok:mysql://10.10.3.188:3306/yyok): jyyok:mysql://10.10.3.188:3306/yyok
  * Deploy ENV [Deploy ip](10.10.3.189:80): 
  * SERVICE [SERVICE VIEW](http://10.10.3.189:80/yyok): http://10.10.3.189:80/yyok 
  * ZK ENV [ZOOKEEPER](##): hxa,hxb,hxc
  * YARN ENV [YARN CLUSTER](http://10.10.3.182:8088): ra:hxc,hxd;rm:hxe,hxf,hxg,hxh,hxi,hxj 
  * WEBHDFS ENV [HDFS CLUSTER](http://10.10.3.180:50070): nn:hxa;dn:hxe,hxf,hxg,hxh,hxi,hxj
  * WEBHDFS ENV [WEBHDFS CLUSTER](http://10.10.3.181:50070): nn:hxb;dn:hxe,hxf,hxg,hxh,hxi,hxj
  * HBASE ENV [Backup Masters](http://10.10.3.180:60010): M:hxa;RS:hxe,hxf,hxg,hxh,hxi,hxj
  * HBASE ENV [RegionServer](http://10.10.3.181:60010): M:hxb;RS:hxe,hxf,hxg,hxh,hxi,hxj
  * SPARK ENV [SPARK-MASTER](http://10.10.3.180:8088): http://101.37.14.63:8088
  * SPARK ENV [SPARK-SHELL](http://10.10.3.180:8081): http://101.37.14.199:8081
  * Azkaban ENV  [webUi](http://10.10.3.189:18888)  um: hxdi  pwd:hxpti
  * SUPERSET ENV  [webUi](http://10.10.3.189:8088/superset/dashboard/1/)  用户名 huaxin  密码 hxpti
  * Azkaban ENV  [webUi](http://10.10.3.189:18888)
  * Azkaban ENV  [webUi](http://10.10.3.189:18888)  
   
   
#### 依赖环境

- Centos 7 
- lombok 插件

####  启动顺序

    启动前先确认 redis 和 rabbit mq 是否启动
    
    1、yyok-nacos    （注册&配置中心先启动）
    2、yyok-admin    （开发不启用此模块）
    3、yyok-gateway   （开发不启用此模块）
    4、yyok-Admin
    5、yyok-Sms
    
## 公共模块说明

|  NO. |  服务     | 模块名称               |  版本        |    备注   |
|------|----------|-----------------------|---------------|-----------|
|  ✅ |  注册中心 | yyok-shares              | 2.1.1.RELEASE |      必选      |
|  ✅ |  注册中心 | yyok-clouds              | 2.1.1.RELEASE |      必选      |
|  ✅ |  配置中心 | yyok-nacos              |   ✅          |      必选      |
|  🏗 |  消息总线 | yyok-gateway            |   🏗          |      可选     |
|  🏗 |  灰度分流 | OpenResty + lua         |   🏗          |   可选        |
|  ✅ |  动态网关 | yyok-gate                |   ✅          |  必选        |
|  ✅ |  授权认证 | yyok-auth                |   ✅          |  必选   Jwt模式   |
|  ✅ |  服务容错 | SpringCloud Sentinel    |   ✅          |    可选       |
|  ✅ |  服务调用 | yyok-OpenFeign           |   ✅          |    可选       |
   🏗 |  对象存储 | yyok-FastDFS/Minio       |   🏗          |    可选       |
|  🏗 |  任务调度 | yyok-job                 |   🏗          |   必选         |
|  ✅ |  分库分表 | yyok-orm                 |   ✅          |    必选       |
|  ✅ |  数据权限 | yyok-admin               |   ✅          |  必选  主要有aaa的整合|
|  ✅ |  服务治理 | yyok-robton              |   ✅          |  必选  服务监控，服务链路|
|  ✅ |  平台监控 | yyok-monitor             |   ✅           | 可选   平台监控，日志管理|
|  ✅ |  调度中心 | yyok-scheduler           |   ✅           |  必选  调度中心，邮件报警|
|  ✅ |  体验中心 | yyok-hxdi                |   ✅           |  可选 可视化界面|

### 权限功能说明

|  服务     | 使用技术     |   进度         |    备注   |
|----------|-------------|---------------|-----------|
|  用户管理 | 自开发       |   ✅          |  用户是系统操作者，该功能主要完成系统用户配置。          |
|  角色管理 | 自开发       |   ✅          |  角色菜单权限分配、设置角色按机构进行数据范围权限划分。   |
|  菜单管理 | 自开发       |   ✅           |  配置系统菜单，操作权限，按钮权限标识等。               |
|  机构管理 | 自开发       |   ✅           |  配置系统组织机构，树结构展现，可随意调整上下级。        |    

### 授权认证功能说明

|  服务     | 使用技术     |   进度         |    备注   |
|----------|-------------|---------------|-----------|
|  授权认证 | OAuth 2.0        |   ✅          |  [服务授权认证：yyok-share-auth](http://10.10.3.188:4761/auth/oauth/token发送请求获得access_token )   |
|  安全 | Security            |   ✅           |  spring Security               |  |
|  路由 | Gateway（zuul）      |   ✅           |  spring cloud Gateway。        |                                 |

### 开发运维

|  服务     | 使用技术                 |   进度         |    备注   |
|----------|-------------------------|---------------|-----------|
|  测试管理 |                         |   🏗          |           |
|  文档管理 | Swagger2                |   ✅          |           |
|  服务监控 | Spring Boot Admin       |   ✅          |           |
|  链路追踪 | sleuth                 |   ✅          |           |
|  操作审计 |  zipkin                       |   🏗          |  系统关键操作日志记录和查询         |
|  日志管理 | ES + Kibana、Zipkin     |   🏗          |           |
|  监控告警 | Grafana                 |   🏗           |           |

### 所用技术栈
  |  名称     |       作用             |   兼容性         |    位置   |     备注   |
  |-------------------------|-------------------------|---------------|-----------|-----------|
  |  vue，bootstrap，jquery，D3，echarts |        可视化，展示，交互              |   ✅          |   前端        |
  |  spring workframe |        spring 核心              |   ✅          |   前端        |
  |  spring boot |        前端微服              |   ✅          |   前端微服       |
  |  spring cloud|        后端微服              |   ✅          |   后端微服       |
  |  mysql |        关系存储              |   ✅          |   前端数据        |
  |  hadoop |        HDFS(存储),YARN（计算容器）              |   ✅          |   无结构化数据        |
  |  hbase |        数据列式存储              |   ✅          |   前端数据        |
  |  spark |        离线核心计算              |   ✅          |   计算引擎        |
  |  flink |        在线，离线核心计算              |   ✅          |   计算引擎        |
  |  kafka |        消息互交              |   ✅          |   消息引擎       |
  |  Datax |        数据交换              |   ✅          |   数据采集引擎     |   |        消息互交              |   ✅          |   前端        |    
  |  ES |        数据检索引擎              |   🏗          |   前端        |  
  |  SuperSet |  大数据可视化引擎             |   ✅          |   前端        |  
  |  kylin |     大数据分析工具              |   ✅          |    数仓端         |  
  |  Rest ful |   应用数据互交协议              |   ✅          |   前端        |  
  |  AZkaban |   调度配置中心              |   ✅          |   前端        |  
  |  MPP |        数仓              |   ✅          |    数仓端      |  
  |  sf |        分析学习              |   ✅          |   数仓端        |  
  |  DL |        深度学习              |   ✅          |    数仓端        |  
  |  SPARK MLlib |        机器学习              |   ✅          |    数仓端         |   


应用版本控制
======

V1.0.0：

    内容： 
        1. 大数据运维（数据采集，一键扩容,及页面展示 ）
        2. 应用架构开发
        3. 大数据平台的架构开发
        4. 数据采集开发
        5. 应用监控需求整理      
        
V1.0.1：

    内容： 
        1. 大数据运维（aaa，服务治理,应用业务调度，监控开发 ）
        2. 大数据JOB调度
        3. 大数据数仓开发
        4. 分层治理数仓【ods-dwo-dwc-dim-dm】
        5. 数据采集数据导入
        
V1.0.2：

    内容： 
        1. 大数据分析工具开发
        2. 大数据应用分析【属性-业务口径-统计口径-统计建模-】
           
        
V1.0.3：

    内容： 
        1. 权限管理
        2. 网格治理 
        3. 集群运维   


V1.0.4：

    内容： 
        1. 大数据调度中心
        2. 应用调度中心
        
V1.0.5：

    内容： 
        1. 自定义报表
        2. 大数据可视化
 
 
变更
=====

## 更新日志
-----------
  * 2019-10 spring security登陆验证扩展 手机验证码，二维码扫码登陆、 引入i18n国际化、 集成git配置中心、admin监控、 链路追踪、Springcloud 升级为Edgware，Consul升级为最新1.2  
  * 2019-10 数据模块开发、 docker容器编排安安排  
  * 2019-10 授权中心整和Jwt、 SpringSecurity，使用 OAuth2 授权  
  * 2019-11 init， 完成公共模块设计、 调度模块开发  
