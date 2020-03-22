package com.yyok.jobs;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.Date;

@SuppressWarnings("serial")
@AllArgsConstructor
@NoArgsConstructor
@Data
@Accessors(chain=true)
public class PostInfo implements Serializable {

    private String pid;//岗位编号
    private String jobName;//岗位名称
    private String salary;//岗位薪资
    private String postAddres;//地点
    private String workingExp;//年限
    private String eduLevel;//学历
    private String emplType;//性质
    private String peopleNum;//招聘人数
    private String welfare;//职位福利
    private String positionInfo;//岗位信息
    private String cid;//发布所属公司
    private String positionURL;//招聘地址
    private Date updateDate;//岗位更新时间
    private Date createDate;//岗位创建时间
    private Date endDate;//招聘结束时间
    private String introduce;//公司简介

}