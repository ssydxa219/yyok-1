package com.yyok.common.service;

/**
 * @author efenderbosch
 */
public interface IRedisTokenStoreSerializationStrategy {

	<T> T deserialize(byte[] bytes, Class<T> clazz);

	String deserializeString(byte[] bytes);

	byte[] serialize(Object object);

	byte[] serialize(String data);

}
