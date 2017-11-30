<%@page import="com.yq.faurecia.pojo.DepartmentInfo"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.common.service.*"%>
<%
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	CommonService commonService = (CommonService) ctx.getBean("commonService");
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	SkillService skillService = (SkillService) ctx.getBean("skillService");
	
	int emp_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("emp_id"), "0"));
	EmployeeInfo employeeInfo = employeeInfoService.queryById(emp_id);
	
	List<Skill> skillList = skillService.queryByEmpId(emp_id);
%>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
</head>
<body>
<div id="contentwrapper" class="contentwrapper"  style="padding:0px">
	<div class="widgetbox">
		<div class="widgetcontent padding0 statement">
	   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
		        <thead>
		            <tr>
		                <th class="head1" style="width: 30%"></th>
		                <th class="head1" style="width: 70%"></th>
		            </tr>
		        </thead>
		        <tbody>
		        <tr>
		        	<td style="font-weight:bold" align="center">姓名</td>
		        	<td>
		        		<%=StringUtils.defaultIfEmpty(employeeInfo.getZh_name(), "") %>
		        	</td>
		        </tr>
		        <tr>
		        	<td style="font-weight:bold" align="center">入职日期</td>
		        	<td>
		        		<%=Util.convertToString(employeeInfo.getEmp08()).replace(" 00:00:00","") %>
		        	</td>
		        </tr>		        
		        <tr>
		        	<td style="font-weight:bold" align="center">多岗位</td>
		        	<td>
		        		<%if(skillList!=null&&!skillList.isEmpty()) 
		        			for(Skill skill:skillList){
		        			if(!skill.getType_name().equals(Global.skill_type[0]))continue;
		        		%>
		        		<%=StringUtils.defaultIfEmpty(skill.getSkill(), "-") %><br/>
		        		<%}else{ %>
		        		-
		        		<%} %>
		        	</td>
		        </tr>
		        <tr>
		        	<td style="font-weight:bold" align="center">特种作业</td>
		        	<td>
		        		<%if(skillList!=null&&!skillList.isEmpty()) 
		        			for(Skill skill:skillList){
		        			if(!skill.getType_name().equals(Global.skill_type[1]))continue;
		        		%>
		        		<%=StringUtils.defaultIfEmpty(skill.getSkill(), "-") %><br/>
		        		<%}else{ %>
		        		-
		        		<%} %>
		        	</td>
		        </tr>		        
         		</tbody>
       		</table>
     	</div>
   </div>
</div>	
</body>
</html>