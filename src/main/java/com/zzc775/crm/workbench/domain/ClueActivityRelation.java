package com.zzc775.crm.workbench.domain;



/**
 * tbl_clue_activity_relation
 * @author 
 */
public class ClueActivityRelation {
    private String id;

    private String clueId;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getClueId() {
        return clueId;
    }

    public void setClueId(String clueId) {
        this.clueId = clueId;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    private String activityId;

}