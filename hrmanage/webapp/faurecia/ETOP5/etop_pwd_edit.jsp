<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int user_id = StringUtils.isEmpty(request.getParameter("user_id"))?-1:Integer.parseInt(request.getParameter("user_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	UserInfoService userInfoService = (UserInfoService) ctx.getBean("userInfoService");
	
	UserInfo mi = userInfoService.queryById(user_id,null);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	$('#contentwrapper #tabs-3 #editSubmit').click(function(){
		if(validateForm('contentwrapper #tabs-3')){
			if($("#contentwrapper #pwd").length>0&&$("#contentwrapper #pwd").val().Trim()==""){
					parent.showInfo("请输入密码！");
					return false;
			}else
			if($("#contentwrapper #repwd").length>0&&$("#contentwrapper #repwd").val().Trim()==""){
					parent.showInfo("请再次输入密码！");
					return false;
			}else
			if($("#contentwrapper #repwd").length>0&&$("#contentwrapper #repwd").val().Trim()!=$("#contentwrapper #pwd").val().Trim()){
					parent.showInfo("二次输入密码不同！");
					return false;
			}
			
			if (confirm('是否提交？')) {
				var param = getParamsJson("contentwrapper #tabs-3");
				ajaxUrl(ctx+'/common/etop5/rePwd.do',param,function(json){
					if(json.flag=='1'){
						showInfo('操作成功！');
					}else{
						showInfo('操作错误！');
					}
				});
			}
		}
	});				
});
</script>
</head>
<body>
	<div class="bodywrapper">
        	<div id="contentwrapper" class="contentwrapper"  style="padding:0px">
						<div class="widgetbox">
                            <div class="widgetcontent">
                                <div id="tabs">
                                    <div id="tabs-3">
					                    <form id="tabs-3-form" class="yqstdform" onSubmit="return false;">
					                        <div>
					                        	<label>密码</label>
					                            <span class="field">
					                            <input type="password" name="pwd" id="pwd" class="mediuminput" value=""/>
					                            </span>
					                        </div> 
					                        <div>
					                        	<label>再次输入密码</label>
					                            <span class="field">
					                            <input type="password" name="repwd" id="repwd" class="mediuminput" value=""/>
					                            </span>
					                        </div>              
					                        <br clear="all" />
					                        <div class="stdformbutton">
					                        	<button id="editSubmit" class="submit radius2">提交</button>
					                            <input type="reset" class="reset radius2" value="Reset" />
					                        </div>
					                    </form>
                                    </div>
                                </div><!--#tabs-->
                            </div><!--widgetcontent-->
                        </div><!--widgetbox-->
        	</div><!--contentwrapper-->
	</div>
</body>
</html>


        
