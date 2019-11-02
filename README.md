![alt text](http://yyok.png "yyok Logo")
大数据项目（yyok）
================

目录
-----------

项目源码: [git@10.10.1.127:hxdi/yyok.git](http://10.10.1.127:8084/hxdi/dbc.git)（yyok）
----------------
开发说明:
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
   
开发架构（yyok）:
----------------
   * yyok-bins－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－shell
   * yyok-docs－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－项目文档
   * yyok-etcs－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－项目配置
   * yyok-libs－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－项目业务模块
   * yyok-apis－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－项目对外服务
   * yyok-shares－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－项目底层依赖
   * yyok-clients－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－项目体验
   
开发工具:
----------------
   * JDK1.8 click the link ＆ down the [jdk-8u192-linux-x64.rpm](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) file and install（rpm -ivh jdk-8u192-linux-x64.rpm） default dir /usr/java/.
   * SCALA2.11.0 click the link ＆ down the [scala-2.11.8.tgz](https://downloads.lightbend.com/scala/2.11.0/scala-2.11.0.tgz) file and instalL default dir /ddhome/bin/scala.
   * IntelliJ IDEA IDEA 2019 tar down [IntelliJ IDEA IDEA 2019 for linux](https://www.jetbrains.com/idea/download/download-thanks.html?platform=linux).
   * IntelliJ IDEA IDEA 2019 exe down [IntelliJ IDEA IDEA 2019 for windows](https://www.jetbrains.com/idea/download/download-thanks.html?platform=windows).
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
 
   
开发环境:(centos  7 okay)
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

版本要求：
----------------
        <java.version>1.8</java.version>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <scala.version>2.11.8</scala.version>
        <spark.version>2.3.4</spark.version>
        <spark.scala.version>2.11</spark.scala.version>
        <flink.version>1.7</flink.version>
        <hadoop.version>2.9.2</hadoop.version>
        <hbase.version>2.1.1</hbase.version>
        <hive.version>2.3.4</hive.version>
        <kafka.version>2.1.0</kafka.version><!--kafka_2.11-2.1.0-->
        <spring-kafka.version>2.1.5.RELEASE</spring-kafka.version>
        <spring-data.version>2.1.3.RELEASE</spring-data.version>
        <log4j.version>1.2.12</log4j.version>
        <slf4j.version>1.7.25</slf4j.version>  
        <spring-cloud.version>Greenwich.SR3</spring-cloud.version>
        <spring-boot.version>2.1.9.RELEASE</spring-boot.version>
        <springfox-swagger.version>2.7.0</springfox-swagger.version>
        <swagger-annotations.version>1.5.13</swagger-annotations.version>
        <mysql.version>5.1.39</mysql.version>

Using dev evn
----------------
  * MYSQL ENV [mysql url](jdbc:mysql://10.10.3.188:3306/dbc): jdbc:mysql://10.10.3.188:3306/dbc

  * Deploy ENV [Deploy ip](10.10.3.189:80): 
   
  * SERVICE [SERVICE VIEW](http://10.10.3.189:80/dbc): http://10.10.3.189:80/dbc 
   
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
    
### 模块说明

|  服务     | 使用技术                 |   进度        |    备注   |
|----------|-------------------------|---------------|-----------|
|  注册中心 | dbc-center              |   ✅          |           |
|  配置中心 | dbc-config              |   ✅          |           |
|  消息总线 | SpringCloud Bus+Rabbitmq|   ✅          |           |
|  灰度分流 | OpenResty + lua         |   🏗          |           |
|  动态网关 | dbc-gate                |   ✅          |  多种维度的流量控制（服务、IP、用户等），后端可配置化🏗          |
|  授权认证 | dbc-auth                |   ✅          |  Jwt模式   |
|  服务容错 | SpringCloud Sentinel    |   ✅          |           |
|  服务调用 | dbc-OpenFeign           |   ✅          |           |
|  对象存储 | dbc-FastDFS/Minio       |   🏗          |           |
|  任务调度 | dbc-job                 |   🏗          |           |
|  分库分表 | dbc-orm                 |   🏗          |           |
|  数据权限 | dbc-admin               |   🏗         |  使用mybatis对原查询做增强，业务代码不用控制，即可实现。         |
|  服务治理 | dbc-rcba                |   🏗          |  使用mybatis对原查询做增强，业务代码不用控制，即可实现。         |
|  平台监控 | dbc-monitor             |   🏗         |  使用mybatis对原查询做增强，业务代码不用控制，即可实现。         |

### 平台功能

|  服务     | 使用技术     |   进度         |    备注   |
|----------|-------------|---------------|-----------|
|  用户管理 | 自开发       |   ✅          |  用户是系统操作者，该功能主要完成系统用户配置。          |
|  角色管理 | 自开发       |   ✅          |  角色菜单权限分配、设置角色按机构进行数据范围权限划分。   |
|  菜单管理 | 自开发       |   🏗          |  配置系统菜单，操作权限，按钮权限标识等。               |
|  机构管理 | 自开发       |   🏗          |  配置系统组织机构，树结构展现，可随意调整上下级。        |
|  网关动态路由 | 自开发    |   🏗          |  网关动态路由管理                                     |

### 开发运维

|  服务     | 使用技术                 |   进度         |    备注   |
|----------|-------------------------|---------------|-----------|
|  代码生成 |                         |   🏗          |  前后端代码的生成，支持Vue         |
|  测试管理 |                         |   🏗          |           |
|  文档管理 | Swagger2                |   ✅          |           |
|  服务监控 | Spring Boot Admin       |   ✅          |           |
|  链路追踪 | SkyWalking              |   ✅          |           |
|  操作审计 |                         |   🏗          |  系统关键操作日志记录和查询         |
|  日志管理 | ES + Kibana、Zipkin     |   ✅          |           |
|  监控告警 | Grafana                 |   ✅          |           |

    
Getting Started
---------------
开发流程：

****做模块开发时，先建readme.md文件写入你的业务逻辑、思路和步骤****

1. 在dbc-clients创建一个web项目jar模块（dbc-home）；
2. 在dbc-libs创建一个项目pom模块组目录结构

        dbc-homes
            dbc-home-server
            dbc-home-client
            dbc-home-util
3. 在dbc-docs创建一个项目文件夹（dbc-home）；
4. 了解dbc-shares里的公用模块，直接依赖
5. 如有api要dbc-apis里一个项目pom模块组目录结构

        dbc-home-apis
            dbc-home-server-auth-api
            dbc-home-client-auth-api
            dbc-home-util-auth-api
            
6. 在dbc-libs的子pom项目是业务模块，用来组装的。业务模块开发要求事务性
7. 
Add the development packages, build and get the development server running:
```
git clone https://github.com/cloudera/hue.git
cd hue
make apps
build/env/bin/hue runserver
```
Now Hue should be running on [http://localhost:8000](http://localhost:8000) ! The configuration in development mode is ``desktop/conf/pseudo-distributed.ini``.

Read more in the [installation documentation](http://cloudera.github.io/hue/latest/admin-manual/manual.html#installation).


Docker
------
Start Hue in a single click with the [Docker Guide](https://github.com/cloudera/hue/tree/master/tools/docker) or the
[video blog post](http://gethue.com/getting-started-with-hue-in-2-minutes-with-docker/).


Community
-----------
   * User group: http://groups.google.com/a/cloudera.org/group/hue-user
   * Jira: https://issues.cloudera.org/browse/HUE
   * Reviews: https://review.cloudera.org/dashboard/?view=to-group&group=hue (repo 'hue-rw')

版本管理
-----------

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
        1.         


V1.0.4：

    内容： 
        1. 
        

V1.0.5：

    内容： 
        1. 
 
 
变更## 更新日志
-----------
  * 2019-10 spring security登陆验证扩展 手机验证码，二维码扫码登陆、 引入i18n国际化、 集成git配置中心、admin监控、 链路追踪、Springcloud 升级为Edgware，Consul升级为最新1.2  
  * 2019-11 完成基础数据模块开发、 docker容器编排  
  * 2019-12 授权中心整和Jwt、 SpringSecurity，使用 OAuth2 授权  
  * 2020-1 init， 完成公共模块设计、 SpringBoot starter开发  
     
                              
License
-----------
Apache License, Version 2.0
http://www.apache.org/licenses/LICENSE-2.0

hxdi(开源项目）

《hxdi构建微服务架构》微服务化开发平台，
具有统一授权、认证后台管理系统，其中包含具备用户管理、资源权限管理、网关API管理等多个模块，
支持多业务系统并行开发。
核心技术采用Spring Boot2(2.1.9.RELEASE)以及Spring Cloud (Greenwich.SR3)相关核心组件，
前端采用vue-element-admin组件、bootstrap组件。

hxdi 学习教程

##《hxdi构建微服务架构》系列 - version:linqinghong
## hxdi微服务实战 : Eureka + Zuul + Feign/Ribbon + Hystrix Turbine + Spring Config + sleuth + zipkin

dbc【前后分离】

	项目中用到的技术栈：
	
	    应用架构技术：
	
            springcloud 快速启动
            
            eureka 服务注册（发现）中心
            
            springcloud config 配置中心，
            
            ribbon rest请求客户端负载平衡器，springboot自带
            
            feign rest请求声明性REST客户端，基于ribbon
            
            Hystrix 断路器
            
            turbine 聚合多个实例Hystrix指标流
            
            zuul 路由器和过滤器
            
            Sleuth 分布式跟踪
            
            Zipkin 结合Sleuth实现链路跟踪
            
            springcloud-admin monitor
            
            springcloud-admin-ui 前端
            
            项目启动顺序：
            
            dbc-centre -> dbc-config -> dbc-auth -> dbc-admin -> dbc-Zipkin -> 剩下其他的服务``
            
            
	    大数据技术栈架构：
             Hadoop
             Hbase
             Spark
             Kafka
             Flink
             Azkaban
             Superset
             kylin   
	能看到nginx欢迎界面说明,nginx安装成功。
	dbc-hxdi界面
	
	
