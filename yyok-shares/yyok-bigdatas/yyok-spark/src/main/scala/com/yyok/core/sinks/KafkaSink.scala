package com.yyok.core.sinks

import java.util.{Properties, UUID}

import org.apache.kafka.clients.producer.ProducerRecord
import org.apache.spark.SparkContext
import org.apache.spark.rdd.RDD
import org.apache.spark.streaming.Time
import org.fire.spark.streaming.core.plugins.kafka.writer.KafkaWriter._

import scala.collection.JavaConversions._
import scala.reflect.ClassTag

/**
  * Created by guoning on 16/8/2.
  *
  * 输出到kafka
  */
class KafkaSink[T: ClassTag](@transient override val sc : SparkContext,
                             initParams: Map[String,String] = Map.empty[String,String])
  extends Sink[T] {

  override val paramPrefix: String = "spark.sink.kafka."

  private lazy val prop = {
    val p = new Properties()
    p.putAll(param ++ initParams)
    p
  }

  private val outputTopic = prop.getProperty("topic")

  /**
    * 以字符串的形式输出到kafka
    *
    */
  override def output(rdd: RDD[T], time: Time = Time(System.currentTimeMillis())): Unit = {

    rdd.writeToKafka(prop, x => new ProducerRecord[String, String](outputTopic, UUID.randomUUID().toString, x.toString))
  }
}
