<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	int emp_id = StringUtils.isEmpty(request.getParameter("emp_id"))?-1:Integer.parseInt(request.getParameter("emp_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	
%>
<script type="text/javascript">
$(function(){
	loadHistory(document.getElementById('<%=Global.employee_history_type[0]%>'));
});
var objAbj;
function loadHistory(obj){
	if(typeof(obj.id) != "undefined"&&obj.id.length>0){
		if(typeof(objAbj) != "undefined"){
			$(objAbj).css("background-color","");
		}
		$(obj).css("background-color","#DDDDFF");
		objAbj = obj;
		var params = {};
		params['emp_id']=<%=emp_id%>;
		params['history_type']=obj.id;
		inner_html(ctx+'/faurecia/common/employee/emp_history_inner.jsp',params,'history_list',null);
	}
}
</script>
<div>
		<%
		out.print("<div id='"+(Global.employee_history_type[0])+"' class='shadowdiv' onclick='loadHistory(this);' style='cursor:pointer;width:80px;position:relative; margin:5px 5px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:20px;border: 2px solid "+Global.colors[2]+";'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size: 16px;font-weight: bold;'>");
		out.print("职位");
		out.print("</td></tr></table>");
		out.print("</div>");
		out.print("<div id='"+(Global.employee_history_type[1])+"' class='shadowdiv' onclick='loadHistory(this);' style='cursor:pointer;width:120px;position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:20px;border: 2px solid "+Global.colors[2]+";'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size: 16px;font-weight: bold;'>");
		out.print("HR Status");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div id='"+(Global.employee_history_type[2])+"' class='shadowdiv' onclick='loadHistory(this);' style='cursor:pointer;width:120px;position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:20px;border: 2px solid "+Global.colors[2]+";'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size: 16px;font-weight: bold;'>");
		out.print("合同归属");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div id='"+(Global.employee_history_type[3])+"' class='shadowdiv' onclick='loadHistory(this);' style='cursor:pointer;width:120px;position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:20px;border: 2px solid "+Global.colors[2]+";'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size: 16px;font-weight: bold;'>");
		out.print("MOD/MOI");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div id='"+(Global.employee_history_type[4])+"' class='shadowdiv' onclick='loadHistory(this);' style='cursor:pointer;width:120px;position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:20px;border: 2px solid "+Global.colors[2]+";'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size: 16px;font-weight: bold;'>");
		out.print("ContractType");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div id='"+(Global.employee_history_type[5])+"' class='shadowdiv' onclick='loadHistory(this);' style='cursor:pointer;width:80px;position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:20px;border: 2px solid "+Global.colors[2]+";'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size: 16px;font-weight: bold;'>");
		out.print("部门");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div id='"+(Global.employee_history_type[6])+"' class='shadowdiv' onclick='loadHistory(this);' style='cursor:pointer;width:80px;position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:20px;border: 2px solid "+Global.colors[2]+";'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size: 16px;font-weight: bold;'>");
		out.print("合同");
		out.print("</td></tr></table>");
		out.print("</div>");
		%>			
</div>
<div id="history_list" style="margin-top: 60px;"></div>