<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	int dept_id = StringUtils.isEmpty(request.getParameter("dept_id"))?-1:Integer.parseInt(request.getParameter("dept_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	DepartmentInfoService deptInfoService = (DepartmentInfoService) ctx.getBean("departmentInfoService");
	
	DepartmentInfo mi = deptInfoService.queryById(dept_id,null);
	String parent_dept_name = StringUtils.isEmpty(mi.getParent_dept_name())?"":mi.getParent_dept_name();
	int parent_dept_id = mi.getParent_id()==null?0:mi.getParent_id();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/dept/js/dept.js"></script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
                    <form class="yqstdform" onSubmit="return false;">
                        <div>
                        	<label>上级部门</label>
                            <span class="field">
                            	<jsp:include page="/share/jsp/dept_ztree.jsp" >
                            		<jsp:param value="<%=parent_dept_id %>" name="parent_dept_id"/>
                            		<jsp:param value="<%=parent_dept_name %>" name="parent_dept_name"/>
                            		<jsp:param value="<%=dept_id %>" name="dept_id"/>
                            	</jsp:include>
                            </span>
                        </div>
                        <div>
                        	<label>部门代码</label>
                            <span class="field">
                            <input type="text" name="dept_code" id="dept_code"  class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getDept_code(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>部门名称</label>
                            <span class="field">
                            <input type="text" name="dept_name" id="dept_name" class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getDept_name(), "")%>"/>
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