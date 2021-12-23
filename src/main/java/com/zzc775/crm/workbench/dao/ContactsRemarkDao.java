package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.ClueRemark;
import com.zzc775.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkDao {
    int add(ContactsRemark contactsRemark);

    int getCountByCIds(String[] ids);

    int deleteByCIds(String[] ids);

    List<ContactsRemark> getList(String contactsId);

    String getContentById(String id);

    int update(ContactsRemark cr);

    boolean deleteById(String id);
}