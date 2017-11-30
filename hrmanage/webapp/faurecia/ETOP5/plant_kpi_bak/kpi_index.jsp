<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	EmployeeInfo employeeInfo = (EmployeeInfo)session.getAttribute("employeeInfo");
	String ext_1 = null;
	if(StringUtils.isEmpty(request.getParameter("ext_1"))){
		return ;
	}else{
		ext_1 = request.getParameter("ext_1");
	}
	String params = StringUtils.defaultIfEmpty(request.getParameter("params"), "");
	String kpi_type = "",dept_name = "",ext_2 = "",kpi_date = "";
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
			}
		}
	}
	
	
	String year = (StringUtils.isEmpty(kpi_date)?StringUtils.defaultIfEmpty(request.getParameter("year"), ""):kpi_date.split("-")[0]);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(year)||StringUtils.isEmpty(year)){
		year = cal.get(Calendar.YEAR)+"";
	}
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantKPIService plantKPIService = (PlantKPIService) ctx.getBean("plantKPIService");
	
	List<PlantKPI> listDept = plantKPIService.queryKPIDeptByInOrOut(ext_1);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/plant_kpi/js/kpi.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<script type="text/javascript">
	$(function(){
		$("#ext_2").val('<%=ext_2%>');
		//click_href('${ctx}/faurecia/ETOP5/plant_kpi/kpi_data_view.jsp');
		$("#ext_2").change(function(){
			loadKpiDept($(this).val(),'<%=dept_name%>');
		});
		$("#dept_name").change(function(){
			if($(this).val().length>0){
				loadKpiType($("#ext_2").val(),$(this).val(),'<%=kpi_type%>');
			}
		});
		$("#kpi_type").change(function(){
			kpi_data_inner();
		});
		$("#ext_2").trigger("change");
	});
	function loadKpiDept(ext_2,dept_name){
		var _url = ctx+"/faurecia/ETOP5/plant_kpi/data/load_kpi_dept.jsp";
		var param = {};
		param['ext_2']=ext_2;
		param['ext_1']='<%=ext_1%>';
		ajaxUrl(_url,param,function(json){
			$("#dept_name").empty();
			$("#dept_name").append("<option value=\"\" selected=\"selected\">---请选择---</option>");
			$.each(json.rows, function (n, value) {
				$("#dept_name").append("<option value=\""+value.dept_name+"\">"+value.dept_name+"</option>");
	        });
	        if(typeof(dept_name) == "undefined"){
	        }else{
	        	$("#dept_name").val(dept_name);
	        	$("#dept_name").trigger("change");
	        }
		});
	}
	function loadKpiType(ext_2,dept_name,kpi_type){
		var _url = ctx+"/faurecia/ETOP5/plant_kpi/data/load_kpi_type.jsp";
		var param = {};
		param['dept_name']=dept_name;
		param['ext_2']=ext_2;
		param['ext_1']='<%=ext_1%>';
		ajaxUrl(_url,param,function(json){
			$("#kpi_type").empty();
			$("#kpi_type").append("<option value=\"\" selected=\"selected\">---请选择---</option>");
			$.each(json.rows, function (n, value) {
				$("#kpi_type").append("<option value=\""+value.kpi_type+"\">"+value.kpi_type+"</option>");
	        });
	        if(typeof(kpi_type) == "undefined"){
	        }else{
	        	$("#kpi_type").val(kpi_type);
	        	$("#kpi_type").trigger("change");
	        }
		});
	}		
	function kpi_data_inner(){
		var year = $("#year").val();
		var dept_name = $("#dept_name").val();
		var kpi_type = $("#kpi_type").val();
		var ext_2 = $("#ext_2").val();
		var _url = ctx+'/faurecia/ETOP5/plant_kpi/kpi_data.jsp';
		var params = {};
		params['menu_id']=<%=menu_id%>;
		params['ext_1']='<%=ext_1%>';
		params['kpi_date']='<%=kpi_date%>';
		params['year']=year;
		params['kpi_type']=kpi_type;
		params['dept_name']=dept_name;
		params['ext_2']=ext_2;
		inner_html(_url,params,'kpi_data',function(data){
			$("#kpi_data").html(data);
		});
	}
</script>
</head>
<body>
	<div id="contentwrapper" style="margin-left: 20px;margin-bottom:10px;">
			<div>
				<h5>
				<input style="width: 60px;height: 18px;" type="text" readonly="readonly" id="year" name="year" value="<%=year %>"  onclick="wdateYearInstance('year',function(){if($('#year').val().Trim()==''){return false;}kpi_data_inner();});"/>
				&nbsp;|&nbsp;
				<select id="ext_2" name="ext_2" style="height:24px;">
					<option value="" selected>All</option>
					<%for(String t:Global.plant_kpi_qcdp){ %>
					<option value="<%=t%>"><%=t%></option>
					<%} %>
				</select>
				&nbsp;|&nbsp;
				<select id="dept_name" name="dept_name" style="height:24px;">
						<option value="" selected="selected">---请选择---</option>
				</select>
				&nbsp;|&nbsp;
				<select id="kpi_type" name="kpi_type" style="height:24px;">
						<option value="" selected="selected">---请选择---</option>
				</select>
				&nbsp;|&nbsp;
				[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/plant_kpi/data/plant_kpi_data_add.jsp?menu_id=<%=menu_id %>','KPI 数据添加');">&nbsp;+&nbsp;</a>]
				&nbsp;|&nbsp;
				<jsp:include page="/share/jsp/screen_full_open.jsp" />
				</h5>
			</div>
	</div>
	<div id="kpi_data" style="margin-left: 20px;margin-right:20px;"></div>
</body>
</html>
