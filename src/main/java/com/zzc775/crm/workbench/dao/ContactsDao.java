package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    Contacts getByMPhone(String mphone);

    int add(Contacts contacts);

    List<Contacts> getList();

    Contacts getById(String id);

    int update(Contacts contacts);

    int deleteByIds(String[] ids);

    Contacts getById1(String id);

    List<Contacts> getListByName(String name);
}