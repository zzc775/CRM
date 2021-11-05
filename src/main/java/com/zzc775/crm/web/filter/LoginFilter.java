package com.zzc775.crm.web.filter;

import com.zzc775.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @ClassName LoginFilter
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/3 18:40
 * @Version 1.0
 **/
public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest)req;
        HttpServletResponse response = (HttpServletResponse) resp;
        User user = (User) request.getSession().getAttribute("user");
        String url = request.getServletPath();
        if ("/login.jsp".equals(url) || "/settings/user/login.do".equals(url)){
            chain.doFilter(req,resp);
        }else{
            //登入过放行
            if (user != null){
                chain.doFilter(req,resp);
            }else {
                /**未登入过重定向
                 * 为什么使用重定向:
                 * 转发后地址栏路径还是原路径
                 * 重定向会改变路径成重定向的路径
                 *
                 **/
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }
        }

    }
}
