package com.zzc775.crm.workbench.service;

import com.zzc775.crm.settings.domain.User;
import com.zzc775.crm.workbench.domain.Activity;
import com.zzc775.crm.workbench.domain.Clue;
import com.zzc775.crm.workbench.domain.ClueRemark;
import com.zzc775.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    List<Clue> getList();

    boolean add(Clue clue);

    Clue getById(String id);

    List<Activity> getRelation(String id);

    boolean deleteRelation(String id);

    List<Activity> getActivityList(Map<String,String> map);

    boolean addRelation(Map<String, Object> map);

    boolean convert(String clueId, String createBy, Tran tran);

    List<ClueRemark> getRemarkList(String id);

    boolean saveRemark(ClueRemark clueRemark);

    boolean deleteRemark(String id);

    Map<String,Object> getRemarkContent(String id);

    boolean updateRemark(ClueRemark clueRemark);

    boolean delete(String[] ids);

    Clue getRawById(String id);

    boolean update(Clue clue);
}
