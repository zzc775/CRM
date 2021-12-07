package com.zzc775.crm.settings.web.controller;

import com.zzc775.crm.settings.domain.User;
import com.zzc775.crm.settings.service.Impl.UserServiceImpl;
import com.zzc775.crm.settings.service.UserService;
import com.zzc775.crm.utils.MD5Util;
import com.zzc775.crm.utils.PrintJson;
import com.zzc775.crm.utils.ServiceFactory;
import sun.awt.windows.WPrinterJob;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) {
        String url = request.getServletPath();
        System.out.println("进入UserController");
        if ("/settings/user/login.do".equals(url)){
            login(request, response);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        //从请求中获取参数
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //把loginPwd使用MD5加密
        loginPwd = MD5Util.getMD5(loginPwd);
        //获取请求端的IP地址
        String ip = request.getRemoteAddr();

        //获取UserService的代理类
        UserService us = (UserService) ServiceFactory.get(new UserServiceImpl());

        try{
            User user = us.login(loginAct,loginPwd,ip);
            request.getSession().setAttribute("user",user);
            PrintJson.printJsonFlag(response,true);
        }catch (Exception e){
            String msg = e.getMessage();
            Map<String,Object> map = new HashMap<String, Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }
    }
}
