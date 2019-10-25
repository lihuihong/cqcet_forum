package com.cqcet.entity;

import lombok.Data;

/**
 * 父板块
 */
@Data
public class Subject {
    private Integer id;
    private String name;

    @Override
    public String toString() {
        return "Subject{" +
                "id=" + id +
                ", name='" + name + '\'' +
                '}';
    }
}
