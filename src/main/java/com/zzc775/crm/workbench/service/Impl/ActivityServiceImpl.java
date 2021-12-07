package com.zzc775.crm.workbench.service.Impl;

import com.zzc775.crm.utils.SqlSessionUtil;
import com.zzc775.crm.vo.PaginationVO;
import com.zzc775.crm.workbench.dao.ActivityDao;
import com.zzc775.crm.workbench.dao.ActivityRemarkDao;
import com.zzc775.crm.workbench.domain.Activity;
import com.zzc775.crm.workbench.domain.ActivityRemark;
import com.zzc775.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName ActivityServiceImpl
 * @Description TODO
 * @Author zzc775
 * @Email 2021405018@qq.com
 * @Date 2021/11/3 20:06
 * @Version 1.0
 **/
public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);

    @Override
    public boolean save(Activity activity) {
        int count = activityDao.save(activity);
        System.out.println(count);
        return count == 1;
    }

    @Override
    public PaginationVO<Activity> getActivityList(Map<String, Object> map) {
        PaginationVO<Activity> paginationVO = new PaginationVO();
        int total = activityDao.getTotal(map);
        List<Activity> activityList = activityDao.getActivityList(map);
        paginationVO.setTotal(total);
        paginationVO.setDataList(activityList);
        return paginationVO;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        //取得要删除的备注数量
        int remarkCount = activityRemarkDao.getCountByAIds(ids);

        //删除备注
        if (remarkCount != activityRemarkDao.deleteByAIds(ids)){
            flag = false;
        }

        //
        if (ids.length != activityDao.delete(ids)){
            flag = false;
        }

        return flag;
    }

    @Override
    public Activity get(String id) {
        return activityDao.getById(id);
    }

    @Override
    public boolean update(Activity activity) {
        return activityDao.update(activity) == 1;
    }

    @Override
    public Activity getDetail(String id) {
        return activityDao.getDetail(id);

    }

    @Override
    public List<ActivityRemark> getRemarkList(String id) {
        return activityRemarkDao.getByAIds(id);
    }

    @Override
    public boolean remarkSave(ActivityRemark activityRemark) {
        return activityRemarkDao.save(activityRemark) == 1;
    }

    @Override
    public boolean deleteRemark(String id) {
        return activityRemarkDao.deleteById(id) == 1;
    }

    @Override
    public Map<String, Object> getRemarkContent(String id) {
        Map<String,Object> result = new HashMap<>();
        String content = activityRemarkDao.getContentById(id);
        result.put("success",false);
        if (content != null){
            result.put("success",true);
            result.put("content",content);
        }
        return result;
    }

    @Override
    public boolean updateRemark(Map<String,String> map) {
        return activityRemarkDao.update(map) == 1;
    }
}
