package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.Activity;
import com.zzc775.crm.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationDao {

    List<Activity> getById(String id);

    int delete(String id);

    int add(List<ClueActivityRelation> list);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int getCountByCIds(String[] ids);

    int deleteByCIds(String[] ids);

    List<Activity> getActivityListByName(Map<String, String> map);
}