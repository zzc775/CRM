package com.zzc775.crm.workbench.dao;

import com.zzc775.crm.workbench.domain.Clue;

import java.util.List;

public interface ClueDao {
    List<Clue> getAll();

    int add(Clue clue);

    Clue getById(String id);

    int delete(String[] ids);

    Clue getRawById(String id);

    int update(Clue clue);
}