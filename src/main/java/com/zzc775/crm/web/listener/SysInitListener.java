package com.zzc775.crm.web.listener;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.zzc775.crm.settings.domain.DicValue;
import com.zzc775.crm.settings.service.DicService;
import com.zzc775.crm.settings.service.Impl.DicServiceImp;
import com.zzc775.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

/**
 * @ClassName SysInitListener
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/12/7 9:49
 * @Version 1.0
 **/
public class SysInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext application = sce.getServletContext();
        DicService ds = (DicService) ServiceFactory.get(new DicServiceImp());
        Map<String,List<DicValue>> dicList = ds.getAll();
        dicList.forEach(application::setAttribute);

        ResourceBundle stage2Possibility = ResourceBundle.getBundle("Stage2Possibility");
        Map<String,String>  map = new HashMap<>();
        ObjectMapper om = new ObjectMapper();
        Enumeration<String> keys = stage2Possibility.getKeys();
        while(keys.hasMoreElements()){
            String key = keys.nextElement();
            String value = stage2Possibility.getString(key);
            map.put(key,value);
        }
        String stageJson = "";
        try {
            stageJson = om.writeValueAsString(map);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        application.setAttribute("stageJson",stageJson);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContextListener.super.contextDestroyed(sce);
    }
}
