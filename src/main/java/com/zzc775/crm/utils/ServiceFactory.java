package com.zzc775.crm.utils;

/**
 * @ClassName ServiceFactory
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/2 19:27
 * @Version 1.0
 **/
public class ServiceFactory {
    public static Object get(Object obj){
        return new TransactionInvocationHandler(obj).getProxy();
    }
}
