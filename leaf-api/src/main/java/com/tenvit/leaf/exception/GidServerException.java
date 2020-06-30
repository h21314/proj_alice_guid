package com.tenvit.leaf.exception;

/**
 * leaf服务Rpc调用异常
 * @author zhangmc
 * @create 2020-06-30 19:05
 */
public class GidServerException extends RuntimeException {

    public GidServerException(String msg){
        super(msg);
    }

}
