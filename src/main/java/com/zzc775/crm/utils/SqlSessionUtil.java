package com.zzc775.crm.utils;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;

/**
 * @ClassName SqlSessionUtill
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/2 19:05
 * @Version 1.0
 **/
public class SqlSessionUtil {
    private static SqlSessionFactory sessionFactory;
    private static final ThreadLocal<SqlSession> t = new ThreadLocal<SqlSession>();
    static {
        String resource = "mybatis-config.xml";
        try {
            InputStream resourceAsFile = Resources.getResourceAsStream(resource);
            sessionFactory = new SqlSessionFactoryBuilder().build(resourceAsFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static SqlSession getSqlSession(){
        SqlSession session = t.get();
        if (session == null){
            session = sessionFactory.openSession();
            t.set(session);
        }
        return session;
    }

    public static void close(){
        SqlSession session = t.get();
        if (session!=null){
            session.close();
            t.remove();
        }
    }

}
