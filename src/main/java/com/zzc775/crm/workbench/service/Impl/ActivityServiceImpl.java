package com.zzc775.crm.workbench.service.Impl;

import com.zzc775.crm.utils.SqlSessionUtil;
import com.zzc775.crm.workbench.dao.ActivityDao;
import com.zzc775.crm.workbench.domain.Activity;
import com.zzc775.crm.workbench.service.ActivityService;

/**
 * @ClassName ActivityServiceImpl
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/3 20:06
 * @Version 1.0
 **/
public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);

    @Override
    public boolean save(Activity activity) {
        return activityDao.save(activity) == 1;
    }
}
