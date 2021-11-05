package com.zzc775.crm.settings.service;

import com.zzc775.crm.settings.domain.User;
import com.zzc775.crm.exception.LoginException;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
