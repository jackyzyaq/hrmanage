<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	EmployeeInfo employeeInfo = (EmployeeInfo)session.getAttribute("employeeInfo");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	String ext_1 = null;
	if(StringUtils.isEmpty(request.getParameter("ext_1"))){
		return ;
	}else{
		ext_1 = request.getParameter("ext_1");
	}
	String params = StringUtils.defaultIfEmpty(request.getParameter("params"), "");
	String kpi_type = "",dept_name = "",ext_2 = "",kpi_date = "",color = "",ext_2_name = "";
	if(!params.equals("")){
		for(String s:params.split("\\|")){
			if(s.split(":")[0].equals("kpi_type")){
				kpi_type = s.split(":")[1];
			}else if(s.split(":")[0].equals("dept_name")){
				dept_name = s.split(":")[1];
			}else if(s.split(":")[0].equals("ext_2")){
				ext_2 = s.split(":")[1];
			}else if(s.split(":")[0].equals("kpi_date")){
				kpi_date = s.split(":")[1];
			}else if(s.split(":")[0].equals("color")){
				color = s.split(":")[1];
			}else if(s.split(":")[0].equals("ext_2_name")){
				ext_2_name = s.split(":")[1];
			}
		}
	}
	kpi_date = (StringUtils.isEmpty(kpi_date)?sdf.format(new Date()):kpi_date);
	
	String year = (StringUtils.isEmpty(kpi_date)?StringUtils.defaultIfEmpty(request.getParameter("year"), ""):kpi_date.split("-")[0]);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(year)||StringUtils.isEmpty(year)){
		year = cal.get(Calendar.YEAR)+"";
	}
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	DepartmentKPIService departmentKPIService = (DepartmentKPIService) ctx.getBean("departmentKPIService");
	
	String default_kpi_data = (""+Global.department_kpi_io[1]+"|"+ext_2+"|"+kpi_type+"|"+dept_name+"|"+kpi_date+"");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/department_kpi/js/kpi.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<script type="text/javascript">
	$(function(){
		$("#ext_2").val('<%=ext_2%>');
		detail(document.getElementById('<%=default_kpi_data%>'));
	});
	function kpi_data_inner(){
		var year = $("#year").val();
		var dept_name = $("#dept_name").val();
		var kpi_type = $("#kpi_type").val();
		var ext_2 = $("#ext_2").val();
		var ext_1 = $("#ext_1").val();
		var _url = ctx+'/faurecia/ETOP5/department_kpi/kpi_data.jsp';
		var params = {};
		params['menu_id']=<%=menu_id%>;
		params['kpi_date']=$("#kpi_date").val();
		params['year']=year;
		params['kpi_type']=kpi_type;
		params['dept_name']=dept_name;
		params['ext_2']=ext_2;
		params['ext_1']=ext_1;
		inner_html(_url,params,'kpi_data',function(data){
			$("#kpi_data").html(data);
		});
	}

	var objAbj;
	function detail(obj){
		if(typeof(obj.id) != "undefined"&&obj.id.length>0){
			if(typeof(objAbj) != "undefined"){
				$(objAbj).attr("class","shadowdiv gradient1");
			}
			$(obj).removeAttr("class");
			$(obj).attr("class","shadowdiv");
			var kpi_data = obj.id.split('|');
			$("#dept_name").val(kpi_data[3]);
			$("#kpi_type").val(kpi_data[2]);
			$("#ext_2").val(kpi_data[1]);
			$("#ext_1").val(kpi_data[0]);
			objAbj = obj;
			kpi_data_inner();
		}
	}
</script>
</head>
<body>
<div>
		<%
		List<DepartmentKPI> tmpList = null;
		String width = "130px",height="100px";
		out.print("<div style='cursor:pointer;width:140px;position:relative; margin:5px 5px 5px 10px; float:left;'>");
		out.print("<table style='width: 100%;height:20px;border: 2px solid "+Global.colors[2]+";'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size: 16px;font-weight: bold;'>");
		out.print(""+(ext_2_name)+"");
		out.print("</td></tr></table>");
		out.print("</div>");
		out.print("<div style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:20px;border: 2px solid "+Global.colors[2]+";'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size: 16px;font-weight: bold;'>");
		out.print(""+(Global.department_kpi_io[1])+"");
		out.print("</td></tr></table>");
		out.print("</div>");
		if(!StringUtils.isEmpty(ext_2)&&ext_1.toUpperCase().equals(Global.department_kpi_io[1].toUpperCase())){
			tmpList = departmentKPIService.getKPITypeAndDeptSql(ext_2, Global.department_kpi_io[0]);
			for(int i=0;i<tmpList.size();i++){
				DepartmentKPI p = tmpList.get(i);
				out.print("<div style='cursor:pointer;width:"+width+";position:relative; margin:5px 5px 5px 0px; float:left;' "+((i+1)==tmpList.size()?("class='last'"):(""))+">");
				out.print("<table style='width: 100%;height:20px;border: 2px solid "+Global.colors[2]+";'>");
				out.print("<tr><td style='text-align: center; vertical-align: middle;font-size: 16px;font-weight: bold;'>");
				out.print(""+(Global.department_kpi_io[0])+"");
				out.print("</td></tr></table>");
				out.print("</div>");
			}
		}
		%>			
</div>
<div class="clearall"></div>
<div>
		<%
		out.print("<div style='cursor:pointer;width:140px;position:relative; margin:5px 5px 5px 10px; float:left;'>");
		out.print("<table style='width: 95%;height:"+height+";border: 4px solid "+Global.colors[3]+";'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;'>");
		out.print("<a href='javascript:history.back()'><img src='"+request.getContextPath()+"/images/sign-left-icon.png' width='60px' height='60px'/></a>");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div id='"+default_kpi_data+"' class='shadowdiv gradient1' onclick='detail(this);' style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+StringUtils.defaultIfEmpty(color, Global.colors[2])+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;' title='"+(dept_name+"-"+kpi_type)+"'>");
		out.print(""+(dept_name+"<br/>"+kpi_type)+"");
		out.print("</td></tr></table>");
		out.print("</div>");
		if(!StringUtils.isEmpty(ext_2)&&ext_1.toUpperCase().equals(Global.department_kpi_io[1].toUpperCase())){
			for(int i=0;i<tmpList.size();i++){
				DepartmentKPI p = tmpList.get(i);
				String kpi_data = (""+Global.department_kpi_io[0]+"|"+ext_2+"|"+p.getKpi_type()+"|"+p.getDept_name()+"|"+kpi_date+"");
				String kpi_name = p.getDept_name()+"<br/>"+p.getKpi_type()+"";
				DepartmentKPI departmentKPITmp = departmentKPIService.queryByType(sdf.parse(kpi_date), p.getKpi_type(), p.getDept_name(), Global.department_kpi_io[0], ext_2);
				color = (departmentKPITmp==null||StringUtils.isEmpty(departmentKPITmp.getHealth_png())||departmentKPITmp.getHealth_png().equals("-")?Global.colors[2]:(departmentKPITmp.getHealth_png().indexOf(Global.department_kpi_health[0])>-1?Global.colors[0]:Global.colors[1]));
				out.print("<div id='"+kpi_data+"' class='shadowdiv gradient1' onclick='detail(this);' style='cursor:pointer;width:"+width+";position:relative; margin:5px 5px 5px 0px; float:left;' "+((i+1)==tmpList.size()?("class='last'"):(""))+">");
				out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+(color)+";overflow: hidden;'>");
				out.print("<tr><td style='text-align: center; vertical-align: middle;' title='"+kpi_name.replace("<br/>","-")+"'>");
				out.print(""+(kpi_name.length()>50?kpi_name.substring(0,50)+"...":kpi_name));
				out.print("</td></tr></table>");
				out.print("</div>");
			}
		}
		%>			
</div>
<div id="contentwrapper" style="margin-left: 10px;margin-right:10px;margin-bottom:5px;text-align:center;">
		<input type="hidden" id="year" name="year" value="<%=year %>"/>
		<input type="hidden" id="ext_2" name="ext_2" value="<%=ext_2 %>"/>
		<input type="hidden" id="ext_1" name="ext_1" value="<%=ext_1 %>"/>
		<input type="hidden" id="dept_name" name="dept_name" value="<%=dept_name %>"/>
		<input type="hidden" id="kpi_type" name="kpi_type" value="<%=kpi_type %>"/>
		<input type="hidden" id="kpi_date" name="kpi_date" value="<%=kpi_date%>"/>
	<div class="clearall"></div>
	<div id="kpi_data" ></div>
</div>
</body>
</html>
