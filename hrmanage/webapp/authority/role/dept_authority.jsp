<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	int role_id = StringUtils.isEmpty(request.getParameter("role_id"))?-1:Integer.parseInt(request.getParameter("role_id"));
	String role_name = StringUtils.defaultIfEmpty(request.getParameter("role_name"),"");
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	DepartmentInfoService departmentInfoService=(DepartmentInfoService)ctx.getBean("departmentInfoService");
	
	List<DepartmentInfo> deptResult = departmentInfoService.findByDeptRole(role_id);
	String _dept_id = "";
	String _dept_name = "";
	if(deptResult!=null&&deptResult.size()>0){
		for(DepartmentInfo mi:deptResult){
			_dept_id +=mi.getId()+",";
			_dept_name +=mi.getDept_name()+",";
		}
		_dept_id = _dept_id.substring(0,_dept_id.length()-1);
		_dept_name = _dept_name.substring(0,_dept_name.length()-1);
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
                            	<jsp:include page="/share/jsp/dept_ztree_checkbox.jsp">
                            		<jsp:param value="<%=_dept_id %>" name="dept_id"/>
                            		<jsp:param value="<%=_dept_name %>" name="dept_name"/>
                            	</jsp:include>
                            </span>
                            <button id="deptAuthoritySubmit" class="submit radius2">提交</button>
                        </div>
                        <br clear="all" />
                    </form>
        	</div>
</body>
</html>


        
