package com.yyok.core.format

import org.apache.hadoop.io.{NullWritable, Text}
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat

class MultipleTextOutputsFormat extends MultipleOutputsFormat(new TextOutputFormat[NullWritable, Text]) {}
