<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int role_id = StringUtils.isEmpty(request.getParameter("role_id"))?-1:Integer.parseInt(request.getParameter("role_id"));
	String role_name = StringUtils.defaultIfEmpty(request.getParameter("role_name"),"");
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	MenuInfoService menuInfoService=(MenuInfoService)ctx.getBean("menuInfoService");
	
	List<MenuInfo> menuResult = menuInfoService.findByMenuRole(role_id);
	String menu_id = "";
	String menu_name = "";
	if(menuResult!=null&&menuResult.size()>0){
		for(MenuInfo mi:menuResult){
			menu_id +=mi.getId()+",";
			menu_name +=mi.getMenu_name()+",";
		}
		menu_id = menu_id.substring(0,menu_id.length()-1);
		menu_name = menu_name.substring(0,menu_name.length()-1);
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
                            	<jsp:include page="/share/jsp/menu_ztree_checkbod.jsp">
                            		<jsp:param value="<%=menu_id %>" name="parent_menu_id"/>
                            		<jsp:param value="<%=menu_name %>" name="parent_menu_name"/>
                            	</jsp:include>
                            </span>
                            <button id="menuAuthoritySubmit" class="submit radius2">提交</button>
                        </div>
                        <br clear="all" />
                    </form>
        	</div>
</body>
</html>


        
