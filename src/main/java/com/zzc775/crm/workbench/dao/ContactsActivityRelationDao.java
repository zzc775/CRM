package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.Activity;
import com.zzc775.crm.workbench.domain.ContactsActivityRelation;
import com.zzc775.crm.workbench.domain.ContactsRemark;

import java.util.List;
import java.util.Map;

public interface ContactsActivityRelationDao {
    int add(ContactsActivityRelation contactsActivityRelation);

    int getCountByIds(String[] ids);

    int deleteByIds(String[] ids);

    List<Activity> getListByCId(String contactsId);

    int deleteById(String id);

    List<Activity> getActivityListByName(Map<String, String> map);

    int addRelation(ContactsActivityRelation car);
}