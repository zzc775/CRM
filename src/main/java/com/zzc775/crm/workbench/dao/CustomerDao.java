package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    int add(Customer customer);

    Customer getByName(String name);

    String getIdByName(String name);

    List<Customer> getList1();

    List<String> getNameByName(String name);
}