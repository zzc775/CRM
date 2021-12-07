package com.zzc775.crm.workbench.web.controller;

import com.zzc775.crm.settings.domain.User;
import com.zzc775.crm.settings.service.Impl.UserServiceImpl;
import com.zzc775.crm.settings.service.UserService;
import com.zzc775.crm.utils.DateTimeUtil;
import com.zzc775.crm.utils.PrintJson;
import com.zzc775.crm.utils.ServiceFactory;
import com.zzc775.crm.utils.UUIDUtil;
import com.zzc775.crm.vo.PaginationVO;
import com.zzc775.crm.workbench.domain.Activity;
import com.zzc775.crm.workbench.domain.ActivityRemark;
import com.zzc775.crm.workbench.service.ActivityService;
import com.zzc775.crm.workbench.service.Impl.ActivityServiceImpl;

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
        }else if ("/workbench/activity/getActivityList.do".equals(url)){
            getActivityList(request,response);
        }else if ("/workbench/activity/delete.do".equals(url)){
            delete(request,response);
        }else if ("/workbench/activity/get.do".equals(url)){
            get(request,response);
        }else if ("/workbench/activity/update.do".equals(url)){
            update(request,response);
        }else if ("/workbench/activity/detail.do".equals(url)){
            getDetail(request,response);
        }else if (("/workbench/activity/getRemarkList.do").equals(url)){
            getRemarkList(request,response);
        }else if (("/workbench/activity/remarkSave.do").equals(url)){
            remarkSave(request,response);
        }else if (("/workbench/activity/deleteRemark.do").equals(url)){
            deleteRemark(request,response);
        }else if (("/workbench/activity/getRemarkContent.do").equals(url)){
            getRemarkContent(request,response);
        }else if (("/workbench/activity/updateRemark.do").equals(url)){
            updateRemark(request,response);
        }
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        User user = (User) request.getSession().getAttribute("user");
        String editBy = user.getName();
        String editTime = DateTimeUtil.getSysTime();

        Map<String,String> map = new HashMap<>();
        map.put("id",id);
        map.put("noteContent",noteContent);
        map.put("editBy",editBy);
        map.put("editTime",editTime);
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        PrintJson.printJsonFlag(response,as.updateRemark(map));
    }

    private void getRemarkContent(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        PrintJson.printJsonObj(response,as.getRemarkContent(id));
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        PrintJson.printJsonFlag(response,as.deleteRemark(id));

    }

    private void remarkSave(HttpServletRequest request, HttpServletResponse response) {
        //拿参数
        String activityId = request.getParameter("activityId");
        String noteContent = request.getParameter("noteContent");
        User user = (User) request.getSession().getAttribute("user");
        //包装成activityRemark
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setNoteContent(noteContent);
        activityRemark.setCreateBy(user.getName());
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        activityRemark.setEditBy(user.getName());
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        activityRemark.setEditFlag("0");
        activityRemark.setActivityId(activityId);
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        PrintJson.printJsonFlag(response,as.remarkSave(activityRemark));

    }

    private void getRemarkList(HttpServletRequest request, HttpServletResponse response) {
        //拿id
        String id = request.getParameter("id");
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        PrintJson.printJsonObj(response,as.getRemarkList(id));
    }

    private void getDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //拿id
        String id = request.getParameter("id");

        //查数据
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        //1.查市场活动存入request
        request.setAttribute("activity", as.getDetail(id));
        //请求转发
        request.getRequestDispatcher("detail.jsp").forward(request,response);


    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        //拿参数
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        String editTime= DateTimeUtil.getSysTime();
        User user = (User) request.getSession().getAttribute("user");
        String editBy = user.getName();

        //参数构成activity对象
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);

        //调用service
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        PrintJson.printJsonFlag(response,as.update(activity));
    }

    private void get(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        PrintJson.printJsonObj(response,as.get(id));
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        //取参数
        String[] ids = request.getParameterValues("id");
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        PrintJson.printJsonFlag(response,as.delete(ids));
    }

    private void getActivityList(HttpServletRequest request, HttpServletResponse response) {
        //拿参数
        int pageNo = Integer.parseInt(request.getParameter("pageNo"));
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        //把所有参数放入map里
        Map<String,Object> map = new HashMap<>();
        map.put("offset",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);

        //调用service
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        PaginationVO<Activity> paginationVO = as.getActivityList(map);
        PrintJson.printJsonObj(response,paginationVO);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        //拿参数
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        User user = (User)request.getSession().getAttribute("user");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = user.getName();
        String editTime= DateTimeUtil.getSysTime();
        String editBy = user.getName();

        //参数构成activity对象
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);

        //调用service
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        PrintJson.printJsonFlag(response,as.save(activity));
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService us = (UserService) ServiceFactory.get(new UserServiceImpl());
        List<User> userList = us.getUserList();
        PrintJson.printJsonObj(response,userList);
    }
}
