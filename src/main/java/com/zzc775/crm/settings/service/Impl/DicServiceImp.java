package com.zzc775.crm.settings.service.Impl;

import com.zzc775.crm.settings.dao.DicTypeDao;
import com.zzc775.crm.settings.dao.DicValueDao;
import com.zzc775.crm.settings.domain.DicType;
import com.zzc775.crm.settings.domain.DicValue;
import com.zzc775.crm.settings.service.DicService;
import com.zzc775.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @Override
    public Map<String, List<DicValue>> getAll() {
        Map<String,List<DicValue>> dicList = new HashMap<>();
        List<DicType> dicTypes = dicTypeDao.getAll();
        dicTypes.forEach((dicType)->{
            List<DicValue> dicValues = dicValueDao.getByCode(dicType.getCode());
            dicList.put(dicType.getCode(),dicValues);
        });
        return dicList;
    }
}
