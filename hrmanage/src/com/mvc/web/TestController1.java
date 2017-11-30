package com.mvc.web;

import com.yq.authority.pojo.UserInfo;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

@Controller
@SessionAttributes({"user", "userError"})
public class TestController1 {

   @RequestMapping({"/test/mt.do"})
   public String mt(HttpServletResponse response, ModelMap model, String cgi) {
      System.out.println("start");
      UserInfo user = new UserInfo();
      user.setId(Integer.valueOf(1));
      model.addAttribute("user", user);
      return "index";
   }

   @RequestMapping({"/test/login2.do"})
   public ModelAndView testLogin2(String username, String password, int age) {
      return "admin".equals(username) && "admin".equals(password) && age >= 5?new ModelAndView(new RedirectView("index.jsp")):new ModelAndView("loginError");
   }
}
