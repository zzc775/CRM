package com.zzc775.crm.workbench.service;

import com.zzc775.crm.workbench.domain.Activity;
import com.zzc775.crm.workbench.domain.Contacts;
import com.zzc775.crm.workbench.domain.ContactsRemark;
import com.zzc775.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ContactsService {
    List<Contacts> getList();

    boolean add(Contacts contacts,String customerName);

    Contacts getRawById(String id);

    boolean update(Contacts contacts, String customerName);

    boolean delete(String[] ids);

    Contacts getById(String id);

    List<ContactsRemark> getRemarkList(String conatctsId);

    List<Tran> getTranList(String contactsId);

    List<Activity> getRelationList(String contactsId);

    boolean removeRelation(String id);

    List<Contacts> getListByName(String name);

    boolean saveRemark(ContactsRemark cr);

    Map<String,Object> getRemarkContent(String id);

    boolean updateRemark(ContactsRemark cr);

    boolean deleteRemark(String id);

    List<Activity> getActivityList(Map<String, String> map);

    boolean createRelation(Map<String, Object> map);
}
