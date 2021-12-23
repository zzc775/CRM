package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityRemarkDao {
    int getCountByAIds(String[] ids);

    int deleteByAIds(String[] ids);

    List<ActivityRemark> getByAId(String id);

    int save(ActivityRemark activityRemark);

    int deleteById(String id);

    String getContentById(String id);

    int update(Map<String,String> map);
}
