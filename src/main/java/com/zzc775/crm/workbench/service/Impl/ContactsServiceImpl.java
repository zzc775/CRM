package com.zzc775.crm.workbench.service.Impl;

import com.zzc775.crm.utils.DateTimeUtil;
import com.zzc775.crm.utils.SqlSessionUtil;
import com.zzc775.crm.utils.UUIDUtil;
import com.zzc775.crm.workbench.dao.*;
import com.zzc775.crm.workbench.domain.*;
import com.zzc775.crm.workbench.service.ContactsService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName ContactsServiceImpl
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/12/13 14:40
 * @Version 1.0
 **/
public class ContactsServiceImpl implements ContactsService {
    ContactsDao cd = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    ContactsRemarkDao crd = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    ContactsActivityRelationDao card = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
    CustomerDao cud = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    @Override
    public List<Contacts> getList() {
        return cd.getList();
    }

    @Override
    public boolean add(Contacts contacts,String customerName) {
        boolean result = true;
        String customerId = cud.getIdByName(customerName);
        if(customerId==null){
            String time = DateTimeUtil.getSysTime();
            String createBy = contacts.getCreateBy();
            Customer customer = new Customer();
            customerId = UUIDUtil.getUUID();
            customer.setId(customerId);
            customer.setOwner(contacts.getOwner());
            customer.setName(customerName);
            customer.setPhone(contacts.getMphone());
            customer.setCreateBy(createBy);
            customer.setCreateTime(time);
            customer.setEditBy(createBy);
            customer.setEditTime(time);
            customer.setContactSummary(contacts.getContactSummary());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setDescription(contacts.getDescription());
            customer.setAddress(contacts.getAddress());
            result = cud.add(customer) == 1;
        }
        if (result){
            contacts.setCustomerId(customerId);
            result = cd.add(contacts) == 1;
        }
        return result;
    }

    @Override
    public Contacts getRawById(String id) {
        return cd.getById(id);
    }

    @Override
    public boolean update(Contacts contacts, String customerName) {
        boolean result = true;
        String customerId = cud.getIdByName(customerName);
        if(customerId==null){
            String time = DateTimeUtil.getSysTime();
            String createBy = contacts.getCreateBy();
            Customer customer = new Customer();
            customerId = UUIDUtil.getUUID();
            customer.setId(customerId);
            customer.setOwner(contacts.getOwner());
            customer.setName(customerName);
            customer.setPhone(contacts.getMphone());
            customer.setCreateBy(createBy);
            customer.setCreateTime(time);
            customer.setEditBy(createBy);
            customer.setEditTime(time);
            customer.setContactSummary(contacts.getContactSummary());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setDescription(contacts.getDescription());
            customer.setAddress(contacts.getAddress());
            result = cud.add(customer) == 1;
        }
        if (result){
            contacts.setCustomerId(customerId);
            result = cd.update(contacts) == 1;
        }
        return result;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean result = true;
        int contactsRemarkCount = crd.getCountByCIds(ids);
        if (contactsRemarkCount != crd.deleteByCIds(ids)){
            result = false;
        }
        int carCount = card.getCountByIds(ids);
        if (carCount != card.deleteByIds(ids)){
            result = false;
        }
        if (ids.length != cd.deleteByIds(ids)){
            result = false;
        }
        return result;
    }

    @Override
    public Contacts getById(String id) {
        return cd.getById1(id);
    }

    @Override
    public List<ContactsRemark> getRemarkList(String contactsId) {
        return crd.getList(contactsId);
    }

    @Override
    public List<Tran> getTranList(String contactsId) {
        return tranDao.getListByCId(contactsId);
    }

    @Override
    public List<Activity> getRelationList(String contactsId) {
        return card.getListByCId(contactsId);
    }

    @Override
    public boolean removeRelation(String id) {
        return card.deleteById(id) == 1;
    }

    @Override
    public List<Contacts> getListByName(String name) {
        return cd.getListByName(name);
    }

    @Override
    public boolean saveRemark(ContactsRemark cr) {
        return crd.add(cr) == 1;
    }

    @Override
    public Map<String, Object> getRemarkContent(String id) {
        Map<String, Object> result = new HashMap<>();
        result.put("success",false);
        String content = crd.getContentById(id);
        if (content != null){
            result.put("success",true);
            result.put("content",content);
        }
        return result;
    }

    @Override
    public boolean updateRemark(ContactsRemark cr) {
        return crd.update(cr) == 1;
    }

    @Override
    public boolean deleteRemark(String id) {
        return crd.deleteById(id);
    }

    @Override
    public List<Activity> getActivityList(Map<String, String> map) {
        return card.getActivityListByName(map);
    }

    @Override
    public boolean createRelation(Map<String, Object> map) {
        int result = 0;
        String[] activityIds = (String[]) map.get("activityIds");
        String contactsId = (String) map.get("contactsId");
        for (String activityId : activityIds) {
            ContactsActivityRelation car = new ContactsActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setContactsId(contactsId);
            car.setActivityId(activityId);
            result += card.addRelation(car);
        }
        return result == activityIds.length;
    }
}
