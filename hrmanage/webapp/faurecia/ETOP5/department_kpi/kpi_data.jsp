<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String ext_1 = null,dept_name = null,ext_2 = StringUtils.defaultIfEmpty(request.getParameter("ext_2"), "");
	if(StringUtils.isEmpty(request.getParameter("ext_1"))||
		StringUtils.isEmpty(request.getParameter("dept_name"))){
		return ;
	}else{
		ext_1 = request.getParameter("ext_1");
		dept_name = request.getParameter("dept_name");
	}
	String kpi_type = StringUtils.defaultIfEmpty(request.getParameter("kpi_type"), "");
	String kpi_date = StringUtils.defaultIfEmpty(request.getParameter("kpi_date"), "");
	String year = (StringUtils.isEmpty(kpi_date)?StringUtils.defaultIfEmpty(request.getParameter("year"), ""):kpi_date.split("-")[0]);
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(year)){
		year = String.valueOf(cal.get(Calendar.YEAR));
	}
	if(StringUtils.isEmpty(kpi_type)){
		return ;
	}
	if(StringUtils.isEmpty(kpi_date)){
		ServletContext st = this.getServletConfig().getServletContext();
		ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
		DepartmentKPIService departmentKPIService = (DepartmentKPIService) ctx.getBean("departmentKPIService");
		DepartmentKPI departmentKPI = departmentKPIService.findMaxDayofMonth(kpi_type,year+"-01-01",year+"-12-31",dept_name,ext_1,ext_2);
		if(departmentKPI==null){
			return ;
		}else{
			kpi_date = sdf.format(departmentKPI.getKpi_date());
		}
	}
	
%>
<script type="text/javascript">
	$(function(){
		kpi_month_inner();
	});
	function kpi_month_inner(){
		var year = '<%=year%>';
		var kpi_type = '<%=kpi_type%>';
		var _url = ctx+'/faurecia/ETOP5/department_kpi/kpi_month_inner.jsp';
		var params = {};
		params['menu_id']=<%=menu_id%>;
		params['ext_1']='<%=ext_1%>';
		params['ext_2']='<%=ext_2%>';
		params['dept_name']='<%=dept_name%>';
		params['year']=year;
		params['kpi_type']=kpi_type;
		inner_html(_url,params,'contentwrapper #kpi_month_inner',function(data){
			$("#contentwrapper #kpi_month_inner").html(data);
			kpi_day_inner('<%=year%>','<%=Integer.parseInt(kpi_date.split("-")[1])%>','<%=kpi_type%>','<%=kpi_date%>');
		});
	}
	function kpi_day_inner(year,_month,kpi_type,kpi_date){
		if(typeof(kpi_date)=='undefined'||kpi_date == ''){
			kpi_date = '';
		}else{
			year = kpi_date.split('-')[0];
			_month = kpi_date.split('-')[1];
		}
		inner_html(ctx+'/faurecia/ETOP5/department_kpi/kpi_day_inner.jsp?ext_1=<%=ext_1%>&ext_2=<%=ext_2%>&dept_name=<%=dept_name%>&kpi_date='+kpi_date+'&menu_id=<%=menu_id%>&year='+year+'&month='+_month+'&kpi_type='+kpi_type
					,null,'kpi_day_inner',null);
	}
	
</script>
<div id="contentwrapper" style='margin-top: 10px;'>
	<div class="two_fifth">
		<div id="kpi_month_inner" class="shadowdiv" style="background-color:#FDFFFF;margin-bottom: 5px;"></div>
	</div>
	<div class="three_fifth last">
		<div id="kpi_day_inner" class="shadowdiv" style="background-color:#FDFFFF;margin-bottom: 5px;"></div>
	</div>
</div>