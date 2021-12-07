package com.zzc775.crm.vo;

import java.util.List;

/**
 * @ClassName PaginationVO
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/8 15:53
 * @Version 1.0
 **/
public class PaginationVO<T> {
    int total;
    List<T> dataList;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
