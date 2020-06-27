# YYOK Cloud OAuth2 实现用户认证及单点登录

###YYOK Cloud OAuth 2 有四种授权模式，
####分别是授权码模式（authorization code）、
####简化模式（implicit）、
####密码模式（resource owner password credentials）、
####客户端模式（client credentials）

#### 项目特点

- 深度定制 spring security oauth2 除了原有4种模式，还扩展支持 手机号、QQ、微信等等第三方获取token
- 深度定制资源服务只需要一个注解即可被 oauth2 管理
- 基于用户的网关限流维度，可控制到每个用户
- 多个服务之间调用自动维护token无感传递
- 服务安全访问限制，只能从网关访问，不能直接访问服务 
- 对于不需要鉴权的接口，只需要加上一个注解就可以访问了
- RBAC 权限控制到URL级，系统启动自动同步数据库
- 新增oauth2认证日志
- 持续更新中...

#### 使用技术

|  技术   |   版本   |
| ---- | ---- |
|   spring-platform   |   5.2.4.RELEASE   |
|   spring-boot   |   2.2.5.RELEASE   |
|   spring-cloud   |   Greenwich.RELEASE   |
|   spring-security-oauth2   |   2.3.5.RELEASE   |
|   mybatis-plus   |   3.1.0   |


#### 依赖环境

- jdk1.8
- redis 3.2+
- lombok 插件
- mysql 5.7+
- rabbit mq

####  启动顺序

    启动前先确认 redis 和 rabbit mq 是否启动
    
    1、yyok-Center
    2、yyok-Config
    3、yyok-Auth
    4、yyok-Gateway
    5、yyok-Admin
    6、yyok-Sms

#### 项目目录
```
YYOK
├─doc  项目SQL语
│─yyok-dists       web模块
│─yyok-etcs       公共配置模块
│─yyok-libs       公共业务功能模块
│─yyok-shares     公共功能模块
│   ├─yyok-admin      公共组件模块
│   ├─yyok-bigdatas    公共Feign模块
│   ├─yyok-boot         网关限流模块
│   ├─yyok-cache 公共拦截器模块
│   ├─yyok-clouds 公共mybatis plus 的一些配
│   │    ├─yyok-config 配置中心
│   │    ├─yyok-eureka 服务注册中心
│   │    ├─yyok-gateway 网关服务
│   │    ├─yyok-services 微服务
│   │    │   ├─yyok-admin-service admin服务
│   ├─yyok-syyok-service 短信服务
│   │ 
│   ├─yyok-common     系统公共模块
│   │   ├─yyok-common-core 公共组件模块
│   │   ├─yyok-common-feign 公共Feign模块
│   │   ├─yyok-common-gateway 网关限流模块
│   │   ├─yyok-common-interceptor 公共拦截器模块
│   │   ├─yyok-common-mp 公共mybatis plus 的一些配置
│   │   ├─yyok-common-rabbitmq MQ生产者和一些配置
│   │   ├─yyok-common-resource 公共资源服务模块
│   │   ├─yyok-common-user 公共用户信息
│   ├─yyok-databases 网关限流模块
│   ├─yyok-linux 公共拦截器模块
│   ├─yyok-springs 公共mybatis plus 的一些配置
│─yyok-cache      公共缓存模块
│─yyok-cache      公共缓存模块
│─yyok-cache      公共缓存模块
├─yyok-auth       统一认证服务
├─yyok-common     系统公共模块
│   ├─yyok-common-core 公共组件模块
│   ├─yyok-common-feign 公共Feign模块
│   ├─yyok-common-gateway 网关限流模块
│   ├─yyok-common-interceptor 公共拦截器模块
│   ├─yyok-common-mp 公共mybatis plus 的一些配置
│   ├─yyok-common-rabbitmq MQ生产者和一些配置
│   ├─yyok-common-resource 公共资源服务模块
│   ├─yyok-common-user 公共用户信息
