<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int role_id = StringUtils.isEmpty(request.getParameter("role_id"))?-1:Integer.parseInt(request.getParameter("role_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	RoleInfoService roleInfoService = (RoleInfoService) ctx.getBean("roleInfoService");
	
	RoleInfo mi = roleInfoService.queryById(role_id,null);
	String parent_role_name = StringUtils.isEmpty(mi.getParent_name())?"":mi.getParent_name();
	int parent_role_id = mi.getParent_id()==null?0:mi.getParent_id();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/authority/role/js/role.js"></script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
                    <form class="yqstdform" onSubmit="return false;">
                        <div>
                        	<label>上级菜单</label>
                            <span class="field">
                            	<jsp:include page="/share/jsp/role_ztree.jsp" >
                            		<jsp:param value="<%=parent_role_id %>" name="parent_role_id"/>
                            		<jsp:param value="<%=parent_role_name %>" name="parent_role_name"/>
                            		<jsp:param value="<%=role_id %>" name="role_id"/>
                            	</jsp:include>
                            </span>
                        </div>
                        <div>
                        	<label>菜单代码</label>
                            <span class="field">
                            <input type="text" name="role_code" id="role_code"  class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getRole_code(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>菜单名称</label>
                            <span class="field">
                            <input type="text" name="role_name" id="role_name" class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getRole_name(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>描述</label>
                            <span class="field">
                            <textarea rows="4" class="mediuminput" name="description" id="description"><%=StringUtils.defaultIfEmpty(mi.getDescription(), "")%></textarea>
                            </span> 
                        </div>
                        
                        <div>
                        	<label>有效</label>
                            <span class="field">
                            <select name="state" id="state" class="uniformselect">
                            	<option value="1" <%=mi.getState().intValue()==1?"selected":"" %>>是</option>
                                <option value="0" <%=mi.getState().intValue()==0?"selected":"" %>>否</option>
                            </select>
                            </span>
                        </div>
                        <br clear="all" />
                        <div class="stdformbutton">
                        	<button id="editSubmit" class="submit radius2">提交</button>
                            <input type="reset" class="reset radius2" value="Reset" />
                            <input type="hidden" name="id" value="<%=mi.getId()%>"/>
                        </div>
                    </form>
        	</div>
</body>
</html>


        
