package com.zzc775.crm.workbench.web.controller;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @ClassName ClueController
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/16 10:14
 * @Version 1.0
 **/
public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = request.getServletPath();
        System.out.println("进入ClueController");
        //if ("/workbench/activity/xx.do".equals(url)){
            //xx(request,response);
        //}else if("/workbench/activity/xx.do".equals(url)){
            //xx(request,response);
    }
}
