package com.zzc775.crm.settings.dao;


import com.zzc775.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getByCode(String code);
}