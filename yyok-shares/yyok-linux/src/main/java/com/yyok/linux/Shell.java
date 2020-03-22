package com.yyok.linux;

public abstract class Shell implements AutoCloseable {
    abstract boolean executeCommands(String... commands);

    abstract String getResponse();

    public abstract void close();
}