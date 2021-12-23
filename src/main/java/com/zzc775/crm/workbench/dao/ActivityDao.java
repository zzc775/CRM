package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int save(Activity activity);
    List<Activity> getList(Map<String, Object> map);

    int getTotal(Map<String,Object> map);

    int delete(String[] ids);

    Activity getById(String id);
    int update(Activity activity);

    Activity getDetail(String id);

    List<Activity> getListByName(String name);
}
