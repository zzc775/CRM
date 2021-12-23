package com.zzc775.crm.workbench.service.Impl;

import com.zzc775.crm.settings.domain.User;
import com.zzc775.crm.utils.DateTimeUtil;
import com.zzc775.crm.utils.SqlSessionUtil;
import com.zzc775.crm.utils.UUIDUtil;
import com.zzc775.crm.workbench.dao.*;
import com.zzc775.crm.workbench.domain.*;
import com.zzc775.crm.workbench.service.ClueService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName ClueServiceImpl
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/16 9:58
 * @Version 1.0
 **/
public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    private ClueActivityRelationDao crd = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
    private ContactsActivityRelationDao card = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
    @Override
    public List<Clue> getList() {
        return clueDao.getAll();
    }

    @Override
    public boolean add(Clue clue) {
        return clueDao.add(clue) == 1;
    }

    @Override
    public Clue getById(String id) {
        return clueDao.getById(id);
    }

    @Override
    public List<Activity> getRelation(String id) {
        return crd.getById(id);
    }

    @Override
    public boolean deleteRelation(String id) {
        return crd.delete(id) == 1;
    }

    @Override
    public List<Activity> getActivityList(Map<String,String> map) {
        return crd.getActivityListByName(map);
    }

    @Override
    public boolean addRelation(Map<String, Object> map) {
        String[] ids = (String[]) map.get("activityIds");
        String clueId = (String) map.get("clueId");
        List<ClueActivityRelation> clueActivityRelationList = new ArrayList<>();
        for (String id : ids) {
            clueActivityRelationList.add(new ClueActivityRelation(UUIDUtil.getUUID(),clueId,id));
        }
        return crd.add(clueActivityRelationList) == ids.length;
    }

    @Override
    public boolean convert(String clueId, String createBy, Tran tran) {
        boolean result = true;
        String time = DateTimeUtil.getSysTime();
        //线索转换
        //1.查询clue.
        Clue clue = clueDao.getRawById(clueId);
        //2.如果客户不存在就添加
        Customer customer = customerDao.getByName(clue.getCompany());
        if(customer == null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(clue.getOwner());
            customer.setName(clue.getCompany());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setCreateBy(createBy);
            customer.setCreateTime(time);
            customer.setEditBy(createBy);
            customer.setEditTime(time);
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            customer.setAddress(clue.getAddress());
            result = customerDao.add(customer) == 1;


        }

        //3.如果联系人不存在就添加
        Contacts contacts = contactsDao.getByMPhone(clue.getMphone());
        if (contacts == null){
            contacts = new Contacts();
            contacts.setId(UUIDUtil.getUUID());
            contacts.setOwner(clue.getOwner());
            contacts.setSource(clue.getSource());
            contacts.setCustomerId(customer.getId());
            contacts.setFullName(clue.getFullName());
            contacts.setAppellation(clue.getAppellation());
            contacts.setEmail(clue.getEmail());
            contacts.setMphone(clue.getMphone());
            contacts.setJob(clue.getJob());
            contacts.setCreateBy(createBy);
            contacts.setCreateTime(time);
            contacts.setEditBy(createBy);
            contacts.setEditTime(time);
            contacts.setDescription(clue.getDescription());
            contacts.setContactSummary(clue.getContactSummary());
            contacts.setNextContactTime(clue.getNextContactTime());
            contacts.setAddress(clue.getAddress());
            result = contactsDao.add(contacts) == 1;
        }

        //备注转换
        if (result){
            List<ClueRemark> clueRemarks = clueRemarkDao.getByAId(clueId);
            String customerId = customer.getId();
            String contactsId = contacts.getId();
            CustomerRemark customerRemark = new CustomerRemark();
            ContactsRemark contactsRemark = new ContactsRemark();
            clueRemarks.forEach((clueRemark)->{
                customerRemark.setId(UUIDUtil.getUUID());
                customerRemark.setCustomerId(customerId);
                customerRemark.setCreateBy(createBy);
                customerRemark.setCreateTime(time);
                customerRemark.setEditBy(createBy);
                customerRemark.setEditTime(time);
                customerRemark.setEditFlag("0");
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemarkDao.add(customerRemark);


                contactsRemark.setId(UUIDUtil.getUUID());
                contactsRemark.setContactsId(contactsId);
                contactsRemark.setCreateBy(createBy);
                contactsRemark.setCreateTime(time);
                contactsRemark.setEditBy(createBy);
                contactsRemark.setEditTime(time);
                contactsRemark.setEditFlag("0");
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemarkDao.add(contactsRemark);
            });

        }

        //市场活动关联关系转换
        List<ClueActivityRelation> crs = crd.getListByClueId(clueId);
        ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
        for (ClueActivityRelation cr : crs) {
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setContactsId(contacts.getId());
            contactsActivityRelation.setActivityId(cr.getActivityId());
            card.add(contactsActivityRelation);
        }

        if(result){
            clueRemarkDao.deleteByCId(clueId);
        }

        //创建交易
        if (tran != null) {
            tran.setId(UUIDUtil.getUUID());
            tran.setOwner(clue.getOwner());
            tran.setCustomerId(customer.getId());
            tran.setSource(clue.getSource());
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(createBy);
            tran.setCreateTime(time);
            tran.setEditBy(createBy);
            tran.setEditTime(time);
            tran.setDescription(clue.getDescription());
            tran.setContactSummary(clue.getContactSummary());
            tran.setNextContactTime(clue.getNextContactTime());
            result = tranDao.add(tran) == 1;

            //添加历史交易
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setStage(tran.getStage());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(time);
            tranHistory.setTranId(tran.getId());
            result = tranHistoryDao.add(tranHistory) == 1;

        }

        String[] ids = new String[1];
        ids[0] = clueId;
        delete(ids);

        return result;
    }

    @Override
    public List<ClueRemark> getRemarkList(String id) {
        return clueRemarkDao.getByAId(id);
    }

    @Override
    public boolean saveRemark(ClueRemark clueRemark) {
        return clueRemarkDao.save(clueRemark) == 1;
    }

    @Override
    public boolean deleteRemark(String id) {
        return clueRemarkDao.deleteById(id) == 1;
    }

    @Override
    public Map<String, Object> getRemarkContent(String id) {
        Map<String,Object> result = new HashMap<>();
        String content = clueRemarkDao.getContentById(id);
        result.put("success",false);
        if (content != null){
            result.put("success",true);
            result.put("content",content);
        }
        return result;
    }

    @Override
    public boolean updateRemark(ClueRemark clueRemark) {
        return clueRemarkDao.update(clueRemark);
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        //取得要删除的备注数量
        int remarkCount = clueRemarkDao.getCountByCIds(ids);

        //删除备注
        if (remarkCount != clueRemarkDao.deleteByCIds(ids)){
            flag = false;
        }

        //删除与市场活动的关联
        int relationCount = crd.getCountByCIds(ids);
        if(relationCount != crd.deleteByCIds(ids)){
            flag = false;
        }

        //删除线索
        if (ids.length != clueDao.delete(ids)){
            flag = false;
        }

        return flag;
    }

    @Override
    public Clue getRawById(String id) {
        return clueDao.getRawById(id);
    }

    @Override
    public boolean update(Clue clue) {
        return clueDao.update(clue) == 1;
    }
}
