package com.zzc775.crm.workbench.service;

import com.zzc775.crm.vo.PaginationVO;
import com.zzc775.crm.workbench.domain.Activity;
import com.zzc775.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    boolean save(Activity activity);
    PaginationVO<Activity> getActivityList(Map<String, Object> map);

    boolean delete(String[] ids);

    Activity get(String id);

    boolean update(Activity activity);

    Activity getDetail(String id);

    List<ActivityRemark> getRemarkList(String id);

    boolean remarkSave(ActivityRemark activityRemark);

    boolean deleteRemark(String id);

    Map<String,Object> getRemarkContent(String id);

    boolean updateRemark(Map<String,String> map);

    List<Activity> getListByName(String name);
}
