package com.zzc775.crm.workbench.service.Impl;

import com.zzc775.crm.utils.DateTimeUtil;
import com.zzc775.crm.utils.SqlSessionUtil;
import com.zzc775.crm.utils.UUIDUtil;
import com.zzc775.crm.workbench.dao.CustomerDao;
import com.zzc775.crm.workbench.dao.TranDao;
import com.zzc775.crm.workbench.dao.TranHistoryDao;
import com.zzc775.crm.workbench.dao.TranRemarkDao;
import com.zzc775.crm.workbench.domain.Customer;
import com.zzc775.crm.workbench.domain.Tran;
import com.zzc775.crm.workbench.domain.TranHistory;
import com.zzc775.crm.workbench.domain.TranRemark;
import com.zzc775.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName TranServiceImpl
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/12/15 21:04
 * @Version 1.0
 **/
public class TranServiceImpl implements TranService {
    TranDao td = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    TranRemarkDao trd = SqlSessionUtil.getSqlSession().getMapper(TranRemarkDao.class);
    TranHistoryDao thd = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    CustomerDao cud = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    @Override
    public boolean deleteTranById(String id) {
        boolean result = true;
        int tranRemarkCount = trd.getCountByTId(id);
        if(tranRemarkCount != trd.deleteByTId(id)){
            result = false;
        }
        int tranHCount = thd.getCountByTId(id);
        if(tranHCount != thd.deleteByTId(id)){
            result = false;
        }
        result = td.deleteById(id) == 1;
        return result;
    }

    @Override
    public List<Tran> getList() {
        return td.getList();
    }

    @Override
    public boolean add(Tran t, String customerName) {
        boolean result = true;
        String customerId = cud.getIdByName(customerName);
        if(customerId==null){
            String time = DateTimeUtil.getSysTime();
            String createBy = t.getCreateBy();
            Customer customer = new Customer();
            customerId = UUIDUtil.getUUID();
            customer.setId(customerId);
            customer.setOwner(t.getOwner());
            customer.setName(customerName);
            customer.setCreateBy(createBy);
            customer.setCreateTime(time);
            customer.setEditBy(createBy);
            customer.setEditTime(time);
            customer.setContactSummary(t.getContactSummary());
            customer.setNextContactTime(t.getNextContactTime());
            customer.setDescription(t.getDescription());
            result = cud.add(customer) == 1;
        }
        if (result){
            t.setCustomerId(customerId);
            result = td.add(t) == 1;
        }
        return result;
    }

    @Override
    public Tran getById(String id) {
        return td.getById(id);
    }

    @Override
    public List<TranRemark> getRemarkList(String tranId) {
        return trd.getListByTId(tranId);
    }

    @Override
    public List<TranHistory> getHistoryList(String tranId) {
        return thd.getListByTId(tranId);
    }

    @Override
    public boolean saveRemark(TranRemark tRemark) {
        return trd.add(tRemark) == 1;
    }

    @Override
    public Map<String, Object> getRemarkContent(String id) {
        Map<String,Object> result = new HashMap<>();
        result.put("success",false);
        String content = trd.getRemarkContent(id);
        if(content != null){
            result.put("success",true);
            result.put("content",content);
        }
        return result;
    }

    @Override
    public boolean updateRemark(TranRemark tRemark) {
        return trd.update(tRemark) == 1;
    }

    @Override
    public boolean deleteRemark(String id) {
        return trd.deleteById(id) == 1;
    }
}
