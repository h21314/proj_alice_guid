package com.sankuai.inf.leaf.server.remote.provider;

import com.sankuai.inf.leaf.common.Result;
import com.sankuai.inf.leaf.common.Status;
import com.sankuai.inf.leaf.server.service.SegmentService;
import com.sankuai.inf.leaf.server.service.SnowflakeService;
import com.sankuai.inf.leaf.exception.GuidServerException;
import com.sankuai.inf.leaf.services.GuidService;
import org.apache.dubbo.config.annotation.Service;
import org.springframework.beans.factory.annotation.Autowired;

import javax.validation.constraints.NotBlank;

/**
 * @author zhangmc
 * @create 2020-06-30 19:12
 */
@Service
public class GuidServiceImpl implements GuidService {

    @Autowired
    private SegmentService segmentService;
    @Autowired
    private SnowflakeService snowflakeService;

    @Override
    public Long getSegmentId(@NotBlank(message = "key不能为空") String key) {
        return get(segmentService.getId(key));
    }

    @Override
    public Long getSnowflakeId() {
        return get(snowflakeService.getId(null));
    }

    private Long get(Result result) {
        if (result.getStatus().equals(Status.EXCEPTION)) {
            throw new GuidServerException(result.toString());
        }
        return result.getId();
    }

}
