package com.zzc775.crm.settings.service.Impl;

import com.zzc775.crm.settings.dao.DicTypeDao;
import com.zzc775.crm.settings.dao.DicValueDao;
import com.zzc775.crm.settings.service.DicService;
import com.zzc775.crm.utils.SqlSessionUtil;

/**
 * @ClassName DicServiceImp
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/16 10:29
 * @Version 1.0
 **/
public class DicServiceImp implements DicService {
    private DicTypeDao dicTypeDao = SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);
    private DicValueDao dicValueDao = SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);
}
