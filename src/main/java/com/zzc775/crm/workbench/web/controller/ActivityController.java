package com.zzc775.crm.workbench.web.controller;

import com.zzc775.crm.settings.domain.User;
import com.zzc775.crm.settings.service.Impl.UserServiceImpl;
import com.zzc775.crm.settings.service.UserService;
import com.zzc775.crm.utils.DateTimeUtil;
import com.zzc775.crm.utils.PrintJson;
import com.zzc775.crm.utils.ServiceFactory;
import com.zzc775.crm.utils.UUIDUtil;
import com.zzc775.crm.workbench.domain.Activity;
import com.zzc775.crm.workbench.service.ActivityService;
import com.zzc775.crm.workbench.service.Impl.ActivityServiceImpl;
import sun.awt.windows.WPrinterJob;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName ActivityController
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/4 14:57
 * @Version 1.0
 **/
public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = request.getServletPath();
        System.out.println("进入ActivityController");
        if ("/workbench/activity/getUserList.do".equals(url)){
            getUserList(request,response);
        }else if("/workbench/activity/save.do".equals(url)){
            save(request,response);
        }
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        ActivityService activityService = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        //拿参数
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String describe = request.getParameter("describe");
        User user = (User)request.getSession().getAttribute("user");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = user.getName();
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(describe);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);
        boolean result = activityService.save(activity);
        PrintJson.printJsonObj(response,result);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService userService = (UserService) ServiceFactory.get(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        PrintJson.printJsonObj(response,userList);
    }
}
