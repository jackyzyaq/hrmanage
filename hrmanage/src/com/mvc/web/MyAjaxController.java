package com.mvc.web;

import com.yq.authority.pojo.UserInfo;
import com.yq.authority.service.UserInfoService;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping({"myajax.do"})
public class MyAjaxController {

   @Resource
   private UserInfoService userService;


   @RequestMapping(
      params = {"method=test1"},
      method = {RequestMethod.GET}
   )
   @ResponseBody
   public List test1(String uname, String a) throws Exception {
      System.out.println(uname);
      System.out.println(a);
      System.out.println("MyAjaxController.test1()");
      ArrayList list = new ArrayList();
      return list;
   }

   @RequestMapping(
      params = {"method=test2"},
      method = {RequestMethod.POST}
   )
   @ResponseBody
   public List test2(@ModelAttribute("user") UserInfo user) throws Exception {
      System.out.println(user.getName());
      System.out.println(user.getPwd());
      System.out.println("MyAjaxController.test2()");
      ArrayList list = new ArrayList();
      return list;
   }

   @RequestMapping(
      params = {"method=save"}
   )
   public String save(String uname) {
      System.out.println("UserController.reg()");
      System.out.println(uname);
      return "index";
   }
}
