<%@page import="com.yq.faurecia.service.DepartmentInfoService"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	Map<Integer, MenuInfo> menuInfoMap = (Map<Integer, MenuInfo>) session.getAttribute("menuRole");
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	String end_date = sdf.format(cal.getTime());
	cal.add(Calendar.DAY_OF_MONTH, -6);
	String begin_date = sdf.format(cal.getTime());
	
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/change_management/js/index.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<script type="text/javascript">
	$(function(){
		$("#dept_name").css("height","18px");
		$("#dept_name").css("margin-top","2px");
		$("#dept_name").focus(function(){
			if($("#requestParam_dept_id").val()!=''){
				deptEmployee();
			}
		});
		$("#emp_id").change(function(){
			change_management_inner();
		});		
		change_management_inner();
	});
	function change_management_inner(){
		var begin_date = $("#begin_date").val();
		var end_date = $("#end_date").val();
		var dept_id = $("#requestParam_dept_id").val();
		var emp_id = $("#emp_id").val();
		var _url = ctx+'/faurecia/ETOP5/change_management/index_inner.jsp';
		var params = {};
		params['begin_date']=begin_date;
		params['end_date']=end_date;
		params['dept_id']=(dept_id==null?"":dept_id);
		params['emp_id']=(emp_id==null?"":emp_id);
		inner_html(_url,params,'change_management_sheet',function(data){
			$("#change_management_sheet").html(data);
		});
	}
	
	function deptEmployee(){
		var _url = ctx+'/common/employeeInfo/queryResult.do';
		var param = {};
		param['state']='1';
		param['pageIndex']=1;
		param['pageSize']=1000;
		//param['type']='<%=Global.employee_type[0]%>';
		param['dept_id']=$("#requestParam_dept_id").val();
		ajaxUrl(_url,param,function(json){
			$("#emp_id").empty();
			var count=0;
			var select_emp= "<option value=\"0\" selected>---请选择---</option>";
			$.each(json.rows, function (n, value) { 
				if(value.position_name.indexOf("GAP Leader")>-1){
					if(count==0)select_emp.replace("selected", "");
					select_emp +="<option value=\""+value.id+"\" "+(count==0?"selected":"")+">"+value.zh_name+"</option>";
					count++;
				}
	        });
			$("#emp_id").append(select_emp);
			select_emp="";
			$("#emp_id").trigger("change");
		});
	}
</script>
</head>
<body >
	<table cellpadding='0' cellspacing='0' border='0' class='stdtable'>
		<thead>
			<tr>
				<th colspan='2' class="gradient">
					<div style="margin-left: 0px;margin-bottom:10px;" >
						<div class="one_hlaf">
							<div style="float: left">
								<h4><font style="color: <%=Global.colors[3]%>">变化点管理板</font></h4>
							</div>
						</div>		
						<div class="one_hlaf last">
							<div style="float: right">
								<h5>
								<input style="width: 80px;height: 18px;" type="text" readonly="readonly" id="begin_date" name="begin_date" value="<%=begin_date %>"  onfocus="wdateInstance2(function(){if($('#begin_date').val().Trim()==''){return false;}change_management_inner();});"/>
								&nbsp;|&nbsp;
								<input style="width: 80px;height: 18px;" type="text" readonly="readonly" id="end_date" name="end_date" value="<%=end_date %>"  onfocus="wdateInstance2(function(){if($('#end_date').val().Trim()==''){return false;}change_management_inner();});"/>
								&nbsp;|&nbsp;
								[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/change_management/data/add.jsp?menu_id=<%=menu_id %>','变化点 数据添加');">&nbsp;+&nbsp;</a>]
								&nbsp;|&nbsp;
								<jsp:include page="/share/jsp/screen_full_open.jsp" />
								</h5>
							</div>
		            		<div style="float: right">
								<h5>
								<select id="emp_id" name="emp_id" style="width: 80px;height:24px;margin-top: 2px;"></select>
								&nbsp;|&nbsp;
								</h5>
		            		</div>
		            		<div style="float: right">
								<h5>
								<jsp:include page="/share/jsp/dept_role_ztree.jsp">
									<jsp:param value="true" name="noRequireParentNode"/>
								</jsp:include>
								&nbsp;|&nbsp;
								</h5>
		            		</div>
							<div class="clearall"></div>
						</div>
					</div>
					<div class="clearall"></div>
				</th>
			</tr>
		</thead>
		<tbody>
		<tr>
			<td>
				<div id="change_management_sheet" style="margin-left: 0px;margin-right:0px;"></div>
			</td>
		</tr>
		</tbody>
	</table>
</body>
</html>