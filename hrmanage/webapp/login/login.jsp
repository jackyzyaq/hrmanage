<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/login/js/login.js"></script>
</head>
<body class="loginpage">
	<div class="loginbox">
    	<div class="loginboxinner">
        	
            <div class="logo">
            	<h1 class="logo"><%=StringUtils.defaultIfEmpty((String)Global.configFile.get("logo"), "") %>.<span><%=StringUtils.defaultIfEmpty((String)Global.configFile.get("os_module"), "") %></span></h1>
				<span class="slogan"><font style="font-size: 18px;font-weight: normal; text-transform: uppercase; color: #fb9337"><%=StringUtils.defaultIfEmpty((String)Global.configFile.get("os_module_name"), "") %></font></span>
            </div><!--logo-->
            
            <br clear="all" /><br />
            
            <div class="nousername">
				<div class="loginmsg">用户名不正确.</div>
            </div><!--nousername-->
            
            <div class="nopassword">
				<div class="loginmsg">密码不正确.</div>
                <div class="loginf">
                    <div class="thumb"><img alt="" src="${ctx }/js/ama/images/thumbs/avatar1.png" /></div>
                    <div class="userlogged">
                        <h4></h4>
                        <a href="index.html">Not <span></span>?</a> 
                    </div>
                </div><!--loginf-->
            </div><!--nopassword-->
            <div class="username">
            	<div class="usernameinner">
                   	<input type="text" name="name" id="username" />
                </div>
            </div>
            <div class="password">
            	<div class="passwordinner">
                  	<input type="password" name="pwd" id="password" />
                </div>
            </div>
            <button id="login" class="stdbtn btn_orange">登录</button>
            <div class="keep"><input type="checkbox" name="flag"/>记住密码</div>
        </div><!--loginboxinner-->
    </div><!--loginbox-->
</body>
</html>