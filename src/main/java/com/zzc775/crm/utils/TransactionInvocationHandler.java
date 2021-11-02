package com.zzc775.crm.utils;

import org.apache.ibatis.session.SqlSession;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * @ClassName TransactionInvacationHandler
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/2 19:16
 * @Version 1.0
 **/
public class TransactionInvocationHandler implements InvocationHandler {

    Object target;


    public TransactionInvocationHandler(Object target) {
        this.target = target;
    }


    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {


        //事务代理
        SqlSession session = null;
        Object obj = null;
        try {
            session = SqlSessionUtil.getSqlSession();
            obj = method.invoke(target);
            session.commit();
        }catch (Exception e) {
            session.rollback();
            e.printStackTrace();
        }finally {
            SqlSessionUtil.close();
        }
        return obj;
    }

    public Object getProxy(){
        return Proxy.newProxyInstance(target.getClass().getClassLoader(),target.getClass().getInterfaces(),this);
    }
}
