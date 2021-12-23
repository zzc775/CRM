package com.zzc775.crm.workbench.web.controller;

import com.zzc775.crm.settings.domain.User;
import com.zzc775.crm.settings.service.Impl.UserServiceImpl;
import com.zzc775.crm.settings.service.UserService;
import com.zzc775.crm.utils.DateTimeUtil;
import com.zzc775.crm.utils.PrintJson;
import com.zzc775.crm.utils.ServiceFactory;
import com.zzc775.crm.utils.UUIDUtil;
import com.zzc775.crm.workbench.domain.Clue;
import com.zzc775.crm.workbench.domain.ClueRemark;
import com.zzc775.crm.workbench.domain.Tran;
import com.zzc775.crm.workbench.service.ActivityService;
import com.zzc775.crm.workbench.service.ClueService;
import com.zzc775.crm.workbench.service.Impl.ActivityServiceImpl;
import com.zzc775.crm.workbench.service.Impl.ClueServiceImpl;

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
public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = request.getServletPath();
        if ("/workbench/clue/getUserList.do".equals(url)){
            getUserList(request,response);
        }else if("/workbench/clue/getList.do".equals(url)){
            getClueList(request,response);
        }else if("/workbench/clue/save.do".equals(url)){
            save(request,response);
        }else if("/workbench/clue/detail.do".equals(url)){
            detail(request,response);
        }else if("/workbench/clue/getRelation.do".equals(url)){
            getRelation(request,response);
        }else if("/workbench/clue/removeRelation.do".equals(url)){
            removeRelation(request,response);
        }else if("/workbench/clue/getActivityList.do".equals(url)){
            getActivityList(request,response);
        }else if("/workbench/clue/addRelation.do".equals(url)){
            addRelation(request,response);
        }else if("/workbench/clue/convert.do".equals(url)){
            convert(request,response);
        }else if(("/workbench/clue/getRemarkList.do").equals(url)){
            getRemarkList(request,response);
        }else if (("/workbench/clue/saveRemark.do").equals(url)){
            saveRemark(request,response);
        }else if (("/workbench/clue/deleteRemark.do").equals(url)){
            deleteRemark(request,response);
        }else if (("/workbench/clue/getRemarkContent.do").equals(url)){
            getRemarkContent(request,response);
        }else if (("/workbench/clue/updateRemark.do").equals(url)){
            updateRemark(request,response);
        }else if (("/workbench/clue/delete.do").equals(url)){
            delete(request,response);
        }else if (("/workbench/clue/get.do").equals(url)){
            get(request,response);
        }else if (("/workbench/clue/update.do").equals(url)){
            update(request,response);
        }
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        String id = request.getParameter("id");
        String fullName = request.getParameter("fullName");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        User user = (User) request.getSession().getAttribute("user");
        String editBy = user.getName();
        String editTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullName(fullName);
        clue.setAddress(address);
        clue.setAppellation(appellation);
        clue.setCompany(company);
        clue.setContactSummary(contactSummary);
        clue.setDescription(description);
        clue.setEmail(email);
        clue.setJob(job);
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        clue.setMphone(mphone);
        clue.setPhone(phone);
        clue.setNextContactTime(nextContactTime);
        clue.setSource(source);
        clue.setState(state);
        clue.setWebsite(website);
        clue.setOwner(owner);
        PrintJson.printJsonFlag(response,cs.update(clue));
    }

    private void get(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonObj(response,cs.getRawById(id));
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        String[] ids = request.getParameterValues("id");
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonFlag(response,cs.delete(ids));
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        User user = (User) request.getSession().getAttribute("user");
        String editBy = user.getName();
        String editTime = DateTimeUtil.getSysTime();
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setId(id);
        clueRemark.setNoteContent(noteContent);
        clueRemark.setEditBy(editBy);
        clueRemark.setEditTime(editTime);
        clueRemark.setEditFlag("1");
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonFlag(response,cs.updateRemark(clueRemark));
    }

    private void getRemarkContent(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonObj(response,cs.getRemarkContent(id));
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonFlag(response,cs.deleteRemark(id));

    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        //拿参数
        String clueId = request.getParameter("clueId");
        String noteContent = request.getParameter("noteContent");
        User user = (User) request.getSession().getAttribute("user");
        //包装成activityRemark
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setNoteContent(noteContent);
        clueRemark.setCreateBy(user.getName());
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());
        clueRemark.setEditBy(user.getName());
        clueRemark.setEditTime(DateTimeUtil.getSysTime());
        clueRemark.setEditFlag("0");
        clueRemark.setClueId(clueId);
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonFlag(response,cs.saveRemark(clueRemark));

    }

    private void getRemarkList(HttpServletRequest request, HttpServletResponse response) {
        //拿id
        String id = request.getParameter("id");
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonObj(response,cs.getRemarkList(id));
    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String clueId = request.getParameter("clueId");
        String name = request.getParameter("name");
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        String createBy = ((User) request.getSession().getAttribute("user")).getCreateBy();
        Tran tran = null;
        if (name!=null){
            String money = request.getParameter("money");
            String activityId = request.getParameter("activityId");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            tran = new Tran();
            tran.setMoney(money);
            tran.setActivityId(activityId);
            tran.setExpectedDate(expectedDate);
            tran.setStage(stage);
            tran.setName(name);
        }
        if (cs.convert(clueId,createBy,tran)) {
            response.sendRedirect("index.jsp");
        }
    }

    private void addRelation(HttpServletRequest request, HttpServletResponse response) {
        String clueId = request.getParameter("clueId");
        String[] activityIds = request.getParameterValues("activityId");
        Map<String,Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("activityIds",activityIds);
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonFlag(response,cs.addRelation(map));

    }

    private void getActivityList(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("name");
        String clueId = request.getParameter("id");
        Map<String,String> map = new HashMap<>();
        map.put("name",name);
        map.put("clueId",clueId);
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonObj(response,cs.getActivityList(map));
    }

    private void removeRelation(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonFlag(response,cs.deleteRelation(id));

    }

    private void getRelation(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonObj(response,cs.getRelation(id));
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        request.setAttribute("clue",cs.getById(id));
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        String id = UUIDUtil.getUUID();
        String fullName = request.getParameter("fullName");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        User user = (User) request.getSession().getAttribute("user");
        String createBy = user.getName();
        String createTime = DateTimeUtil.getSysTime();
        String editBy = user.getName();
        String editTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullName(fullName);
        clue.setAddress(address);
        clue.setAppellation(appellation);
        clue.setCompany(company);
        clue.setContactSummary(contactSummary);
        clue.setCreateTime(createBy);
        clue.setCreateBy(createTime);
        clue.setDescription(description);
        clue.setEmail(email);
        clue.setJob(job);
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        clue.setMphone(mphone);
        clue.setPhone(phone);
        clue.setNextContactTime(nextContactTime);
        clue.setSource(source);
        clue.setState(state);
        clue.setWebsite(website);
        clue.setOwner(owner);
        PrintJson.printJsonFlag(response,cs.add(clue));
    }

    private void getClueList(HttpServletRequest request, HttpServletResponse response) {
        ClueService cs = (ClueService) ServiceFactory.get(new ClueServiceImpl());
        PrintJson.printJsonObj(response,cs.getList());
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService us = (UserService) ServiceFactory.get(new UserServiceImpl());
        List<User> userList = us.getUserList();
        PrintJson.printJsonObj(response,userList);
    }

}
