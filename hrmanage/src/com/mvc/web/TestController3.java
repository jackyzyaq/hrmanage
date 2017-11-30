package com.mvc.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping({"/test3/*"})
public class TestController3 {

   @RequestMapping({"login1.do"})
   public String testLogin(String username, String password, int age) {
      return "admin".equals(username) && "admin".equals(password) && age >= 5?"loginSuccess":"loginError";
   }
}
