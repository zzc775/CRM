package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getByAId(String id);

    int save(ClueRemark clueRemark);

    int deleteById(String id);

    String getContentById(String id);

    boolean update(ClueRemark clueRemark);

    int deleteByCId(String clueId);

    int deleteByCIds(String[] ids);

    int getCountByCIds(String[] ids);
}