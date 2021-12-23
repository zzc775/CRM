package com.zzc775.crm.workbench.web.controller;

import com.zzc775.crm.utils.PrintJson;
import com.zzc775.crm.utils.ServiceFactory;
import com.zzc775.crm.workbench.service.CustomerService;
import com.zzc775.crm.workbench.service.Impl.CustomerServiceImpl;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class CustomerController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = request.getServletPath();
        if ("/workbench/customer/getList.do".equals(url)){
            getList(request,response);
        }
    }

    private void getList(HttpServletRequest request, HttpServletResponse response) {
        CustomerService cs = (CustomerService) ServiceFactory.get(new CustomerServiceImpl());
        PrintJson.printJsonObj(response,cs.getList1());
    }
}
