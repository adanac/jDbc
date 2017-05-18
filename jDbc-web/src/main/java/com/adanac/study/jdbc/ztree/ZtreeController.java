package com.adanac.study.jdbc.ztree;

import com.adanac.study.bean.ZTree;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ZtreeController {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    @RequestMapping("/test")
    public String index() {
        return "test";
    }
    
    @RequestMapping("/ztree")
    public String ztree() {
        return "ztree";
    }
    
    @RequestMapping("/getAllTree")
    @ResponseBody
    public List<ZTree> getAllTree() {
        String sql = "select * from t_ztree";
        List<ZTree> list = jdbcTemplate.query(sql, new BeanPropertyRowMapper<ZTree>(ZTree.class));
        return list;
    }
    
    @RequestMapping(value="/add", method=RequestMethod.POST)
    @ResponseBody
    public String add(ZTree zTree) {
        String sql = "insert into t_ztree values(?, ?, ?)";
        int i = jdbcTemplate.update(sql, new Object[]{zTree.getId(), zTree.getPid(), zTree.getName()});
        if (i > 0) {
            System.out.println("插入： " + zTree);
            return "success";
        } else {
            return "fail";
        }
    }
    
    @RequestMapping(value="/rename", method=RequestMethod.POST)
    @ResponseBody
    public String rename(ZTree zTree) {
        String sql = "update t_ztree set name = ? where id = ?";
        int i = jdbcTemplate.update(sql, new Object[]{zTree.getName(), zTree.getId()});
        if (i > 0) {
            System.out.println("重命名： " + zTree);
            return "success";
        } else {
            return "fail";
        }
    }
    
    @RequestMapping("/remove")
    @ResponseBody
    public String remove(ZTree zTree) {
        String sql = "delete from t_ztree where id = ?";
        int i = jdbcTemplate.update(sql, new Object[]{zTree.getId()});
        if (i > 0) {
            System.out.println("删除： " + zTree);
            return "success";
        } else {
            return "fail";
        }
    }
}
