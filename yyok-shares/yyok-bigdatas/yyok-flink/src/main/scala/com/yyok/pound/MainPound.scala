package com.yyok.pound

import org.apache.flink.api.scala.ExecutionEnvironment

object MainPound {

  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
    val text = env.readTextFile("C:\\Users\\MECHREVO\\Desktop\\地磅\\data.txt")
    text.print()
    text.setParallelism(1)
    env.execute("ReadDataSource")
  }
}
