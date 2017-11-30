<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int role_id = StringUtils.isEmpty(request.getParameter("role_id"))?-1:Integer.parseInt(request.getParameter("role_id"));
	String role_name = StringUtils.defaultIfEmpty(request.getParameter("role_name"),"");
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	UserInfoService userInfoService=(UserInfoService)ctx.getBean("userInfoService");
	
	List<UserInfo> userResult = userInfoService.findByUserRole(role_id);
	String _user_id = "";
	String _user_name = "";
	if(userResult!=null&&userResult.size()>0){
		for(UserInfo mi:userResult){
			_user_id +=mi.getId()+",";
			_user_name +=mi.getZh_name()+",";
		}
		_user_id = _user_id.substring(0,_user_id.length()-1);
		_user_name = _user_name.substring(0,_user_name.length()-1);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
		$(function(){
		});
</script>
<script type="text/javascript" src="${ctx }/authority/role/js/role.js"></script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
                    <form class="yqstdform" onSubmit="return false;">
                    	<div class="stdformbutton">
                            <input type="hidden" name="role_id" value="<%=role_id%>"/>
                        </div>
                        <div>
                        	<label><%=role_name %>授权</label>
                            <span class="field">
                            	<jsp:include page="/share/jsp/user_ztree_checkbod.jsp">
                            		<jsp:param value="<%=_user_id %>" name="user_id"/>
                            		<jsp:param value="<%=_user_name %>" name="user_name"/>
                            	</jsp:include>
                            </span>
                            <button id="userAuthoritySubmit" class="submit radius2">提交</button>
                        </div>
                        <br clear="all" />
                    </form>
        	</div>
</body>
</html>


        
