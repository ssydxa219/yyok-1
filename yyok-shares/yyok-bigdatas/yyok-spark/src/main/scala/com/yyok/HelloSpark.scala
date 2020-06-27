package com.yyok

import org.apache.spark.storage.StorageLevel
import org.apache.spark.{SparkConf, SparkContext}

object HelloSpark {
  def main(args: Array[String]): Unit = {
    val sparkConf = new SparkConf().setMaster("local[*]").setAppName("Count")
    val sc = new SparkContext(sparkConf)
    val fd = sc.textFile("D:\\data\\hospital\\健康咨询.txt")
    val logRDD = fd.filter(_.contains("咨询")).map(_.split(" "))
    logRDD.persist(StorageLevel.DISK_ONLY)
    val ipTopRDD = logRDD.map(v => v(0)).countByValue().take(10)
    ipTopRDD.foreach(println)
  }
}