package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {
    int add(TranHistory tranHistory);

    int deleteByTId(String id);

    int getCountByTId(String id);

    List<TranHistory> getListByTId(String tranId);
}