package com.sankuai.inf.leaf.exception;

/**
 * leaf服务Rpc调用异常
 * @author zhangmc
 * @create 2020-06-30 19:05
 */
public class GuidServerException extends RuntimeException {

    public GuidServerException(String msg){
        super(msg);
    }

}
