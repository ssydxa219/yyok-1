package com.yyok.core

import com.yyok.core.kit.Utils

import scala.collection.Map
import scala.util.Try


/**
  * 默认配置
  */
trait FireConfig {
  val config: Map[String, String] = Try {
    Utils.getPropertiesFromFile("application.properties")
  } getOrElse Map.empty[String, String]
}
