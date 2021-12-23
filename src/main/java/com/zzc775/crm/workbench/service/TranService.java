package com.zzc775.crm.workbench.service;

import com.zzc775.crm.workbench.domain.Tran;
import com.zzc775.crm.workbench.domain.TranHistory;
import com.zzc775.crm.workbench.domain.TranRemark;

import java.util.List;
import java.util.Map;

public interface TranService {
    boolean deleteTranById(String id);

    List<Tran> getList();

    boolean add(Tran t, String customerName);

    Tran getById(String id);

    List<TranRemark> getRemarkList(String tranId);

    List<TranHistory> getHistoryList(String tranId);

    boolean saveRemark(TranRemark tRemark);

    Map<String,Object> getRemarkContent(String id);

    boolean updateRemark(TranRemark tRemark);

    boolean deleteRemark(String id);
}
