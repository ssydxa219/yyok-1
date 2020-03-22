package com.yyok.common.service.impl;

public class JdkSerializationStrategy extends StandardStringSerializationStrategy {

	private static final JdkSerializationRedisSerializer OBJECT_SERIALIZER = new JdkSerializationRedisSerializer();

	@Override
	@SuppressWarnings("unchecked")
	protected <T> T deserializeInternal(byte[] bytes, Class<T> clazz) {
		return (T) OBJECT_SERIALIZER.deserialize(bytes);
	}

	@Override
	protected byte[] serializeInternal(Object object) {
		return OBJECT_SERIALIZER.serialize(object);
	}

}
