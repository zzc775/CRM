package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkDao {
    int deleteByTId(String id);

    int getCountByTId(String id);

    List<TranRemark> getListByTId(String tranId);

    int add(TranRemark tRemark);

    String getRemarkContent(String id);

    int update(TranRemark tRemark);

    int deleteById(String id);
}