package com.zzc775.crm.settings.service.Impl;

import com.zzc775.crm.settings.dao.UserDao;
import com.zzc775.crm.settings.domain.User;
import com.zzc775.crm.exception.LoginException;
import com.zzc775.crm.settings.service.UserService;
import com.zzc775.crm.utils.DateTimeUtil;
import com.zzc775.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName UserServiceImpl
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/3 9:04
 * @Version 1.0
 **/
public class UserServiceImpl implements UserService {
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        //从数据库验证账号密码是否正确
        Map<String,String> info = new HashMap<String, String>();
        info.put("loginAct",loginAct);
        info.put("loginPwd",loginPwd);
        User user = userDao.login(info);
        if (user == null){
            throw new LoginException("账号或密码错误");
        }

        //验证ip是否可访问
        String allowIps = user.getAllowIps();
        if (allowIps != null && !"".equals(allowIps.trim()) && !allowIps.contains(ip)){
            throw new LoginException("ip受制");
        }

        //验证账号是否被锁定
        String lockState = user.getLockState();
        if ("0".equals(lockState)){
            throw new LoginException("账号被锁定");
        }

        //验证账号是否过期
        String expireTime = user.getExpireTime();
        if (expireTime.compareTo(DateTimeUtil.getSysTime())<0) {
            throw new LoginException("账号已失效");
        }

        return user;
    }

    @Override
    public List<User> getUserList() {
        return userDao.getUserList();
    }
}
