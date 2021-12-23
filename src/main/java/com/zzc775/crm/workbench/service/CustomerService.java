package com.zzc775.crm.workbench.service;

import com.zzc775.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerService {
    List<Customer> getList1();

    List<String> getNameListByName(String name);
}
