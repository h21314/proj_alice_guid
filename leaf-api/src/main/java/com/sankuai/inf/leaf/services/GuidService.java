package com.sankuai.inf.leaf.services;


import org.springframework.validation.annotation.Validated;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * 全局id服务
 * @author zhangmc
 * @create 2020-06-30 17:45
 */
@Validated
public interface GuidService {

    /**
     * 获取数据库分段式id
     * @param key
     * @return
     */
    Long getSegmentId(@NotBlank(message = "key不能为空") String key);

    /**
     * 批量获取数据库分段式id
     * @param key
     * @param batchCount
     * @return
     */
    List<Long> getSegmentId(@NotBlank(message = "key不能为空") String key,
                            @NotNull(message = "批次数量不能为空") Integer batchCount);

    /**
     * 获取雪花id
     * @return
     */
    Long getSnowflakeId();

    /**
     * 批量获取雪花id
     * @param batchCount
     * @return
     */
    List<Long> getSnowflakeId(@NotNull(message = "批次数量不能为空") Integer batchCount);

}
