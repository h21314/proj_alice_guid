package com.tenvit.leaf.services;


import org.springframework.validation.annotation.Validated;

import javax.validation.constraints.NotBlank;

/**
 * 全局id服务
 * @author zhangmc
 * @create 2020-06-30 17:45
 */
@Validated
public interface GidService {

    /**
     * 获取数据库分段式id
     * @param key
     * @return
     */
    Long getSegmentId(@NotBlank(message = "key不能为空") String key);

    /**
     * 获取雪花id
     * @return
     */
    Long getSnowflakeId();

}
