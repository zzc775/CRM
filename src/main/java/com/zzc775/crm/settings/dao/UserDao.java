package com.zzc775.crm.settings.dao;

import com.zzc775.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    User login(Map<String,String> info);

    List<User> getUserList();
}
