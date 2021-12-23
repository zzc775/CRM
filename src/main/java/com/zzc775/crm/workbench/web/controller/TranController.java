package com.zzc775.crm.workbench.web.controller;

import com.sun.org.apache.xpath.internal.axes.PredicatedNodeTest;
import com.zzc775.crm.settings.domain.User;
import com.zzc775.crm.settings.service.Impl.UserServiceImpl;
import com.zzc775.crm.settings.service.UserService;
import com.zzc775.crm.utils.DateTimeUtil;
import com.zzc775.crm.utils.PrintJson;
import com.zzc775.crm.utils.ServiceFactory;
import com.zzc775.crm.utils.UUIDUtil;
import com.zzc775.crm.workbench.domain.Tran;
import com.zzc775.crm.workbench.domain.TranRemark;
import com.zzc775.crm.workbench.service.ActivityService;
import com.zzc775.crm.workbench.service.ContactsService;
import com.zzc775.crm.workbench.service.CustomerService;
import com.zzc775.crm.workbench.service.Impl.ActivityServiceImpl;
import com.zzc775.crm.workbench.service.Impl.ContactsServiceImpl;
import com.zzc775.crm.workbench.service.Impl.CustomerServiceImpl;
import com.zzc775.crm.workbench.service.Impl.TranServiceImpl;
import com.zzc775.crm.workbench.service.TranService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class TranController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = request.getServletPath();
        if ("/workbench/tran/getList.do".equals(url)){
            getList(request,response);
        }else if("/workbench/tran/getCustomerList.do".equals(url)){
            getCustomerList(request,response);
        }else if("/workbench/tran/getUserList.do".equals(url)){
            getUserList(request,response);
        }else if("/workbench/tran/getActivityList.do".equals(url)){
            getActivityList(request,response);
        }else if("/workbench/tran/getContactsList.do".equals(url)){
            getContactsList(request,response);
        }else if("/workbench/tran/save.do".equals(url)){
            save(request,response);
        }else if("/workbench/tran/detail.do".equals(url)){
            detail(request,response);
        }else if("/workbench/tran/getRemarkList.do".equals(url)){
            getRemarkList(request,response);
        }else if("/workbench/tran/getHistoryList.do".equals(url)){
            getHistoryList(request,response);
        }else if("/workbench/tran/saveRemark.do".equals(url)){
            saveRemark(request,response);
        }else if("/workbench/tran/getRemarkContent.do".equals(url)){
            getRemarkContent(request,response);
        }else if("/workbench/tran/updateRemark.do".equals(url)){
            updateRemark(request,response);
        }else if("/workbench/tran/deleteRemark.do".equals(url)){
            deleteRemark(request,response);
        }
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        TranService ts = (TranService) ServiceFactory.get(new TranServiceImpl());
        PrintJson.printJsonFlag(response,ts.deleteRemark(id));
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        String time = DateTimeUtil.getSysTime();
        TranRemark tRemark = new TranRemark();
        tRemark.setId(id);
        tRemark.setNoteContent( noteContent);
        tRemark.setEditBy(editBy);
        tRemark.setEditTime(time);
        tRemark.setEditFlag("1");
        TranService ts = (TranService) ServiceFactory.get(new TranServiceImpl());
        PrintJson.printJsonFlag(response,ts.updateRemark(tRemark));
    }

    private void getRemarkContent(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        TranService ts = (TranService) ServiceFactory.get(new TranServiceImpl());
        PrintJson.printJsonObj(response,ts.getRemarkContent(id));
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String tranId = request.getParameter("tranId");
        String noteContent = request.getParameter("noteContent");
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String time = DateTimeUtil.getSysTime();
        TranRemark tRemark = new TranRemark();
        tRemark.setId(UUIDUtil.getUUID());
        tRemark.setNoteContent( noteContent);
        tRemark.setCreateBy(createBy);
        tRemark.setCreateTime(time);
        tRemark.setEditBy(createBy);
        tRemark.setEditTime(time);
        tRemark.setEditFlag("0");
        tRemark.setTranId(tranId);
        TranService ts = (TranService) ServiceFactory.get(new TranServiceImpl());
        PrintJson.printJsonFlag(response,ts.saveRemark(tRemark));
    }

    private void getHistoryList(HttpServletRequest request, HttpServletResponse response) {
        String tranId = request.getParameter("tranId");
        TranService ts = (TranService) ServiceFactory.get(new TranServiceImpl());
        PrintJson.printJsonObj(response,ts.getHistoryList(tranId));
    }

    private void getRemarkList(HttpServletRequest request, HttpServletResponse response) {
        String tranId = request.getParameter("tranId");
        TranService ts = (TranService) ServiceFactory.get(new TranServiceImpl());
        PrintJson.printJsonObj(response,ts.getRemarkList(tranId));
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        TranService ts = (TranService) ServiceFactory.get(new TranServiceImpl());
        Tran tran = ts.getById(id);
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("detail.jsp").forward(request,response);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerName = request.getParameter("customerName");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

        Tran t = new Tran();
        t.setId(id);
        t.setOwner(owner);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setStage(stage);
        t.setSource(source);
        t.setType(type);
        t.setActivityId(activityId);
        t.setContactsId(contactsId);
        t.setCreateBy(createBy);
        t.setCreateTime(createTime);
        t.setEditBy(createBy);
        t.setEditTime(createTime);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setNextContactTime(nextContactTime);
        TranService ts = (TranService) ServiceFactory.get(new TranServiceImpl());
        System.out.println(t);
        if (ts.add(t,customerName)){
            request.getRequestDispatcher("index.jsp").forward(request,response);
        }
    }

    private void getContactsList(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("name");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonObj(response,cs.getListByName(name));

    }

    private void getActivityList(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("name");
        ActivityService as = (ActivityService) ServiceFactory.get(new ActivityServiceImpl());
        PrintJson.printJsonObj(response,as.getListByName(name));

    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService us = (UserService) ServiceFactory.get(new UserServiceImpl());
        PrintJson.printJsonObj(response,us.getUserList());
    }

    private void getCustomerList(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("name");
        CustomerService cs = (CustomerService) ServiceFactory.get(new CustomerServiceImpl());
        PrintJson.printJsonObj(response,cs.getNameListByName(name));
    }

    private void getList(HttpServletRequest request, HttpServletResponse response) {
        TranService ts = (TranService) ServiceFactory.get(new TranServiceImpl());
        PrintJson.printJsonObj(response,ts.getList());
    }
}
