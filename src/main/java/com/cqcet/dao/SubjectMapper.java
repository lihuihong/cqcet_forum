package com.cqcet.dao;

import com.cqcet.entity.Subject;

import java.util.List;

public interface SubjectMapper {
    /**
     * 新增父板块
     */
    public void add(Subject subject);

    /**
     * 更新父板块
     */
    public void update(Subject subject);

    /**
     * 删除父板块
     */
    public void remove(Integer subjectId);

    /**
     * 查询父板块
     */
    public List<Subject> subjectList();
}
