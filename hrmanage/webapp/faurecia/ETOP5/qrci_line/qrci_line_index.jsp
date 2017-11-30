<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String number = (request.getParameter("params").equals("0")?"":request.getParameter("params").split(":")[1].replace("-", ""));
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	String end_date = sdf.format(cal.getTime());
	cal.add(Calendar.DAY_OF_MONTH, -6);
	String begin_date = sdf.format(cal.getTime());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<script type="text/javascript">
	$(function(){
		$("#number").val('<%=number%>');
		$("#dept_name").css("height","18px");
		$("#dept_name").css("margin-top","2px");
		$("#dept_name").focus(function(){
			if($("#requestParam_dept_id").val()!=''){
				//deptEmployee();
				qrci_line_index_inner();
			}
		});
		$("#number").blur(function(){
			qrci_line_index_inner();
		}); 
		$("#emp_id").change(function(){
			qrci_line_index_inner();
		});		
		qrci_line_index_inner();
	});
	function qrci_line_index_inner(){
		var begin_date = $("#begin_date").val();
		var end_date = $("#end_date").val();
		var dept_id = $("#requestParam_dept_id").val();
		var emp_id = $("#emp_id").val();
		var number=$("#number").val();
		var _url = ctx+'/faurecia/ETOP5/qrci_line/qrci_line_index_inner.jsp';
		var params = {};
		params['menu_id']=<%=menu_id%>;
		params['begin_date']=begin_date;
		params['end_date']=end_date;
		params['dept_id']=(dept_id==null?"":dept_id);
		params['emp_id']=(emp_id==null?"":emp_id);
		params['number']=(number==null?"":number);
		inner_html(_url,params,'qrci_line_index_inner',function(data){
			$("#contentwrapper #qrci_line_index_inner").html(data);
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
		ajaxUrlFalse(_url,param,function(json){
			$("#emp_id").empty();
			var select_emp= "";
			$.each(json.rows, function (n, value) { 
	        	select_emp +="<option value=\""+value.id+"\" selected>"+value.zh_name+"</option>";
	        });
			$("#emp_id").append(select_emp);
			select_emp="";
			$("#emp_id").trigger("change");
		});
	}	
</script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<div class="widgetbox">
			<div class="one_hlaf">
				<div class="title" style="float:left"><h4>LINE QRCI  快速反应持续改进 &nbsp;</h4></div>
			</div>
			
			<div class="one_hlaf last">
				<div style="float: right" class="title" >
					<div style="float: right">
					<h4>
					[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/qrci_line/data/qrci_line_data_add.jsp?menu_id=<%=menu_id %>','Line QRCI 数据添加');">&nbsp;+&nbsp;</a>]
					&nbsp;|&nbsp;
					<jsp:include page="/share/jsp/screen_full.jsp" />
					</h4>
					</div>
					
					<div style="float: right">
					<h4>
					<input style="width: 80px;height: 18px;" type="text" readonly="readonly" id="end_date" name="end_date" value="<%=end_date %>"  onfocus="wdateInstance2(function(){if($('#end_date').val().Trim()==''){return false;}qrci_line_index_inner();});"/>
					&nbsp;|&nbsp;
					</h4>
					</div>
					
					<div style="float: right">
					<h4>
					<input style="width: 80px;height: 18px;" type="text" readonly="readonly" id="begin_date" name="begin_date" value="<%=begin_date %>"  onfocus="wdateInstance2(function(){if($('#begin_date').val().Trim()==''){return false;}qrci_line_index_inner();});"/>
					&nbsp;|&nbsp;
					</h4>
					</div>
					
<!-- 					<div style="float: right"> -->
<!-- 					<h4> -->
<!-- 					<select id="emp_id" name="emp_id" style="width: 80px;height:24px;margin-top: 2px;"></select> -->
<!-- 					&nbsp;|&nbsp; -->
<!-- 					</h4> -->
<!-- 					</div> -->
					
		            <div style="float: right">
					<h4>
					<jsp:include page="/share/jsp/dept_role_ztree.jsp">
						<jsp:param value="true" name="noRequireParentNode"/>
					</jsp:include>
					&nbsp;|&nbsp;
					</h4>
					</div>

		            <div style="float: right">
					<h4>
					<input placeholder="工位" style="width: 80px;height:17px;margin-top: 2px;" name="number" id="number"/>
					&nbsp;|&nbsp;
					</h4>
					</div>					
			    </div>
			</div>
		</div>
		<div id="qrci_line_index_inner"></div>
	</div>
</body>
</html>