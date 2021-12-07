package com.zzc775.crm.workbench.service.Impl;

import com.zzc775.crm.utils.SqlSessionUtil;
import com.zzc775.crm.workbench.dao.ClueDao;
import com.zzc775.crm.workbench.service.ClueService;

/**
 * @ClassName ClueServiceImp
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/16 9:58
 * @Version 1.0
 **/
public class ClueServiceImp implements ClueService {
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
}
