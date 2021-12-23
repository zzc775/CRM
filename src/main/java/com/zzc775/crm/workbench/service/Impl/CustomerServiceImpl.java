package com.zzc775.crm.workbench.service.Impl;

import com.zzc775.crm.utils.SqlSessionUtil;
import com.zzc775.crm.workbench.dao.CustomerDao;
import com.zzc775.crm.workbench.domain.Customer;
import com.zzc775.crm.workbench.service.CustomerService;

import java.util.List;

/**
 * @ClassName CustomerServiceImpl
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/12/13 16:02
 * @Version 1.0
 **/
public class CustomerServiceImpl implements CustomerService {
    CustomerDao cd = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

    @Override
    public List<Customer> getList1() {
        return cd.getList1();
    }

    @Override
    public List<String> getNameListByName(String name) {
        return cd.getNameByName(name);
    }
}
