package com.cqcet.services;

import com.cqcet.dao.SubjectMapper;
import com.cqcet.entity.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 父板块
 */
@Service("SubjectService")
public class SubjectService {

    @Autowired
    private SubjectMapper subjectMapper;

    /**
     * 添加或更新父板块
     * @param subject
     */
    public void addOrUpdate(Subject subject){
        if (StringUtils.isEmpty(subject.getId())){
            //新增
            subjectMapper.add(subject);
        }else {
            //删除
            subjectMapper.update(subject);
        }
    }

    /**
     * 删除父板块
     * @param subjectId
     */
    public void remove(Integer subjectId){
        subjectMapper.remove(subjectId);
    }

    /**
     * 获取父板块数据
     * @return
     */
    public List<Subject> subjectList(){
        return subjectMapper.subjectList();
    }
}
