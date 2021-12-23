package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.Tran;

import java.util.List;

public interface TranDao {
    int add(Tran tran);

    List<Tran> getListByCId(String contactsId);

    int deleteById(String id);

    List<Tran> getList();

    Tran getById(String id);
}