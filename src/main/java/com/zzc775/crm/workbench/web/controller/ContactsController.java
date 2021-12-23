package com.zzc775.crm.workbench.web.controller;

import com.fasterxml.jackson.databind.ext.SqlBlobSerializer;
import com.zzc775.crm.settings.domain.User;
import com.zzc775.crm.settings.service.Impl.UserServiceImpl;
import com.zzc775.crm.settings.service.UserService;
import com.zzc775.crm.utils.DateTimeUtil;
import com.zzc775.crm.utils.PrintJson;
import com.zzc775.crm.utils.ServiceFactory;
import com.zzc775.crm.utils.UUIDUtil;
import com.zzc775.crm.workbench.domain.*;
import com.zzc775.crm.workbench.service.ClueService;
import com.zzc775.crm.workbench.service.ContactsService;
import com.zzc775.crm.workbench.service.CustomerService;
import com.zzc775.crm.workbench.service.Impl.*;
import com.zzc775.crm.workbench.service.TranService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName ClueController
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/16 10:14
 * @Version 1.0
 **/
public class ContactsController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = request.getServletPath();
        if ("/workbench/contacts/getList.do".equals(url)){
            getList(request,response);
        }else if ("/workbench/contacts/getUserList.do".equals(url)){
            getUserList(request,response);
        }else if ("/workbench/contacts/getCustomerList.do".equals(url)){
            getCustomerList(request,response);
        }else if ("/workbench/contacts/get.do".equals(url)){
            get(request,response);
        }else if ("/workbench/contacts/update.do".equals(url)){
            update(request,response);
        }else if ("/workbench/contacts/delete.do".equals(url)){
            delete(request,response);
        }else if ("/workbench/contacts/add.do".equals(url)){
            add(request,response);
        }else if ("/workbench/contacts/detail.do".equals(url)){
            detail(request,response);
        }else if ("/workbench/contacts/getRemarkList.do".equals(url)){
            getRemarkList(request,response);
        }else if ("/workbench/contacts/getTranList.do".equals(url)){
            getTranList(request,response);
        }else if ("/workbench/contacts/getRelationList.do".equals(url)){
            getRelationList(request,response);
        }else if ("/workbench/contacts/removeRelation.do".equals(url)){
            removeRelation(request,response);
        }else if ("/workbench/contacts/deleteTran.do".equals(url)){
            deleteTran(request,response);
        }else if ("/workbench/contacts/saveRemark.do".equals(url)){
            saveRemark(request,response);
        }else if ("/workbench/contacts/getRemarkContent.do".equals(url)){
            getRemarkContent(request,response);
        }else if ("/workbench/contacts/updateRemark.do".equals(url)){
            updateRemark(request,response);
        }else if ("/workbench/contacts/deleteRemark.do".equals(url)){
            deleteRemark(request,response);
        }else if ("/workbench/contacts/createRelation.do".equals(url)){
            createRelation(request,response);
        }else if ("/workbench/contacts/getActivityList.do".equals(url)){
            getActivityList(request,response);
        }
    }

    private void getActivityList(HttpServletRequest request, HttpServletResponse response) {
        String contactsId = request.getParameter("contactsId");
        String name = request.getParameter("name");
        Map<String,String> map = new HashMap<>();
        map.put("contactsId",contactsId);
        map.put("name",name);
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonObj(response,cs.getActivityList(map));
    }

    private void createRelation(HttpServletRequest request, HttpServletResponse response) {
        String contactsId = request.getParameter("contactsId");
        String[] activityIds = request.getParameterValues("activityId");
        Map<String,Object> map = new HashMap<>();
        map.put("contactsId",contactsId);
        map.put("activityIds",activityIds);
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonFlag(response,cs.createRelation(map));
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonFlag(response,cs.deleteRemark(id));
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        ContactsRemark cr = new ContactsRemark();
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setEditBy(editBy);
        cr.setEditTime(editTime);
        cr.setEditFlag("1");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonFlag(response,cs.updateRemark(cr));
    }

    private void getRemarkContent(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonObj(response,cs.getRemarkContent(id));
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String contactsId = request.getParameter("contactsId");
        String noteContent = request.getParameter("noteContent");
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        ContactsRemark cr = new ContactsRemark();
        cr.setId(UUIDUtil.getUUID());
        cr.setNoteContent(noteContent);
        cr.setCreateBy(createBy);
        cr.setCreateTime(createTime);
        cr.setContactsId(contactsId);
        cr.setEditBy(createBy);
        cr.setEditTime(createTime);
        cr.setEditFlag("0");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonFlag(response,cs.saveRemark(cr));
    }

    private void deleteTran(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        TranService ts = (TranService) ServiceFactory.get(new TranServiceImpl());
        PrintJson.printJsonFlag(response,ts.deleteTranById(id));
    }

    private void removeRelation(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonFlag(response,cs.removeRelation(id));
    }

    private void getRelationList(HttpServletRequest request, HttpServletResponse response) {
        String contactsId = request.getParameter("contactsId");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonObj(response,cs.getRelationList(contactsId));
    }

    private void getTranList(HttpServletRequest request, HttpServletResponse response) {
        String contactsId = request.getParameter("contactsId");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonObj(response,cs.getTranList(contactsId));
    }

    private void getRemarkList(HttpServletRequest request, HttpServletResponse response) {
        String contactsId = request.getParameter("contactsId");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonObj(response,cs.getRemarkList(contactsId));
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        request.setAttribute("contacts",cs.getById(id));
        request.getRequestDispatcher("detail.jsp").forward(request,response);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        String[] ids = request.getParameterValues("id");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        boolean flag = cs.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String source = request.getParameter("source");
        String fullName = request.getParameter("fullName");
        String appellation = request.getParameter("appellation");
        String job = request.getParameter("job");
        String mphone = request.getParameter("mphone");
        String email = request.getParameter("email");
        String birth = request.getParameter("birth");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactsTime = request.getParameter("nextContactsTime");
        String address = request.getParameter("address");
        String customerName = request.getParameter("customerName");
        String time = DateTimeUtil.getSysTime();
        String editBy = ((User) request.getSession().getAttribute("user")).getName();
        Contacts contacts = new Contacts();
        contacts.setId(id);
        contacts.setOwner(owner);
        contacts.setSource(source);
        contacts.setFullName(fullName);
        contacts.setAppellation(appellation);
        contacts.setJob(job);
        contacts.setMphone(mphone);
        contacts.setEmail(email);
        contacts.setBirth(birth);
        contacts.setDescription(description);
        contacts.setContactSummary(contactSummary);
        contacts.setNextContactTime(nextContactsTime);
        contacts.setAddress(address);
        contacts.setEditTime(time);
        contacts.setEditBy(editBy);
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        boolean flag = cs.update(contacts,customerName);
        PrintJson.printJsonFlag(response,flag);
    }

    private void get(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonObj(response,cs.getRawById(id));
    }

    private void add(HttpServletRequest request, HttpServletResponse response) {
        String owner = request.getParameter("owner");
        String source = request.getParameter("source");
        String fullName = request.getParameter("fullName");
        String appellation = request.getParameter("appellation");
        String job = request.getParameter("job");
        String mphone = request.getParameter("mphone");
        String email = request.getParameter("email");
        String birth = request.getParameter("birth");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactsTime = request.getParameter("nextContactsTime");
        String address = request.getParameter("address");
        String customerName = request.getParameter("customerName");
        String time = DateTimeUtil.getSysTime();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(owner);
        contacts.setSource(source);
        contacts.setFullName(fullName);
        contacts.setAppellation(appellation);
        contacts.setJob(job);
        contacts.setMphone(mphone);
        contacts.setEmail(email);
        contacts.setBirth(birth);
        contacts.setDescription(description);
        contacts.setContactSummary(contactSummary);
        contacts.setNextContactTime(nextContactsTime);
        contacts.setAddress(address);
        contacts.setCreateTime(time);
        contacts.setCreateBy(createBy);
        contacts.setEditTime(time);
        contacts.setEditBy(createBy);
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        boolean flag = cs.add(contacts,customerName);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getCustomerList(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("name");
        CustomerService cs = (CustomerService) ServiceFactory.get(new CustomerServiceImpl());
        PrintJson.printJsonObj(response,cs.getNameListByName(name));
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService us = (UserService) ServiceFactory.get(new UserServiceImpl());
        PrintJson.printJsonObj(response,us.getUserList());
    }

    private void getList(HttpServletRequest request, HttpServletResponse response) {
        ContactsService cs = (ContactsService) ServiceFactory.get(new ContactsServiceImpl());
        PrintJson.printJsonObj(response,cs.getList());

    }

}
