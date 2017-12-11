<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/common/shareJsp/cartHead.jsp" %>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ include file="/faurecia/improvement/connector.jsp"%>
<%
    EmployeeInfo employeeInfo = (EmployeeInfo)session.getAttribute("employeeInfo");
	ServletContext st = request.getSession().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(st);
	DepartmentInfoService departmentInfoService = (DepartmentInfoService) ctx.getBean("departmentInfoService");
	String deptIds = departmentInfoService.getSubIdsById(employeeInfo.getDept_id(), null);
	/* if(StringUtils.isNotEmpty(deptIds)) {
		deptIds = deptIds+","+employeeInfo.getDept_id();
	} */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="${ctx}/faurecia/improvement/dashboard/js/highcharts.js"></script>
<script type="text/javascript">
$(function(){
		var params = {};
		var url= '${improve}' + '/fhrapi/db/dbindex';
		params['depts'] = $("#deptIds").val();
		params['EMPId'] = '<%= employeeInfo.getId()%>';
		$.ajax({
			url : url, // 请求链接
			data: params,
			type:"POST",     // 数据提交方式
			cache: false,
			timeout: 5000,
			async:false,
			dataType: 'json',
			success:function(data){
				initRPT(data);
				initReward(data.rewards[0]);
				initMsg(data);
			},
			error:function(data){
				showMsgInfo(data.msg);
			}
		});	
	});

</script>
</head>
<body>
<br />
<!-- <dir style="display: none;"> -->
	<%if (employeeInfo != null&&employeeInfo.getId()!=null){ %>
	        <div class="widgetbox">
				<div class="title">
					<h3>
						所属部门：<%=Util.getDeptAllNameById(employeeInfo.getDept_id(), Global.departmentInfoMap) %>
						&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
						直属主管：
						<jsp:include page="/share/jsp/leaderAll.jsp">
									<jsp:param value="<%=employeeInfo.getDept_id() %>" name="dept_id"/>
									<jsp:param value="<%=employeeInfo.getZh_name() %>" name="zh_name"/>
								</jsp:include>
					</h3>
				</div>
			</div>
			<div class="widgetbox" style="display: inline-block;width: 80%;">
				<div class="title">
					<h3><span id="target_situation"></span></h3>
				</div></div>
			<div style="display: inline;font-size: 12px;">
				<div class="one_third">
					<div id="month_kpi" style="border: 0.5px;color:read; ">月报表</div>
				</div><!--one_half-->
				<div class="one_third last" style="width: 60%;">
					<div id="daily_kpi">日报表</div>
				</div>
			</div>
			<div class="widgetbox" style="display: inline-block;width: 80%;font-size: 12px;">
				<div class="title">
					<h3>最佳（<span id="reward_date"></span>）</h3>
				</div>
				<div class="widgetcontent padding0 statement">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable" style="font-size: 12px;">
						<thead>
							<tr>
								<th	class="head1">编号</th>
								<th class="head0">员工</th>
								<th class="head1">部门</th>
								<th class="head0">内容</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><span id="imp_code"></span></td>
								<td><span id="empname"></span></td>
								<td><span id="dept_name"></span></td>
								<td><span id="imp_solution"></span></td>
							</tr>
						</tbody>
					</table>
				</div>
			<!--widgetcontent-->
			</div>
            <div class="widgetbox" style="display: inline-block;width: 80%;">
			<div class="title">
				<h3>提醒</h3>
			</div>
			<div class="widgetcontent padding0 statement">
				<table cellpadding="0" cellspacing="0" border="0" class="stdtable" style="font-size: 12px;">
					<thead>
						<tr>
							<th class="head0">审批</th>
							<th class="head1">指标</th>
							<th class="head0">积分</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><a style="cursor:pointer" onclick="jumpLabelPage('/portal/portal_left.jsp','58','236','0');"><span id="audit_check"></span></a></td>
							<td><a style="cursor:pointer" onclick="jumpLabelPage('/portal/portal_left.jsp','58','240','0');"><span id="target_value"></span></a></td>
							<td><a style="cursor:pointer" onclick="jumpLabelPage('/portal/portal_left.jsp','58','249','0');"><span id="bonus_points"></span></a></td>
						</tr>
					</tbody>
				</table>
			</div>
	<!--widgetcontent-->
</div>
            <div style="width: 100%;padding-bottom: 50px;"></div>
            
	<%}%><!-- </dir> -->
	
<script type="text/javascript">
	function initReward(data){
		$("#reward_date").html(data.reword_value);
		$("#empname").html(data.improve_emp_name);
		$("#dept_name").html(data.improve_dept_name);
		$("#imp_solution").html(data.improve_solution);
		$("#imp_code").html(data.improve_code);
	}
	function initMsg(data){
		//alert(data.auditcheck[0]);
		$("#audit_check").html(data.auditcheck[0]);
		var ts = "当月指标：【"+data.imptarget[0]+"】&nbsp;已完成：【"+data.currentmonthimp[0]+"】"
		$("#target_situation").html(ts);
		$("#target_value").html(data.imptarget[0]);
		$("#bonus_points").html(data.bonuspoints[0]);
	}
	function initRPT(rptdata){
		console.info(rptdata.monthdata[0].vdata);
		Highcharts.chart('month_kpi', {
			credits: {
			     enabled: false
			},
		    chart: {
		        type: 'column'
		    },
		    title: {
		        text: '月达标情况'
		    },
		    /* subtitle: {
		        text: 'Source: WorldClimate.com'
		    }, */
		    xAxis: {
		        categories: rptdata.monthdata[0].month,
		        crosshair: true
		    },
		    yAxis: {
		        min: 0,
		        title: ''
		    },
		    tooltip: {
		        headerFormat: '<span style="font-size:10px">{point.key}</span><table style="font-size: 10px;width: 80px;">',
		        pointFormat: '<tr align="left"><td style="color:{series.color};padding:0;text-align: left;">{series.name}: </td>' +
		            '<td style="padding:0;text-align: left;"><b>{point.y:.0f}</b></td></tr>',
		        footerFormat: '</table>',
		        shared: true,
		        useHTML: true
		    },
		    plotOptions: {
		        column: {
		            pointPadding: 0.2,
		            borderWidth: 0
		        }
		    },
		    series: [{
		        name: '指标',
		        data: rptdata.targetmonthdata[0].vdata
		
		    },{
		        name: '完成量',
		        data: rptdata.monthdata[0].vdata
		
		    }]
		});
		
		Highcharts.chart('daily_kpi', {
			credits: {
			     enabled: false
			},
		    chart: {
		        type: 'line'
		    },
		    title: {
		        text: '当月达标情况'
		    },
		    /* subtitle: {
		        text: 'Source: WorldClimate.com'
		    }, */
		    xAxis: {
		        categories: rptdata.dailydata[0].daily,
		        crosshair: true
		    },
		    yAxis: {
		        min: 0,
		        title: ''
		    },
		    tooltip: {
		        headerFormat: '<span style="font-size:10px">{point.key}</span><table style="font-size: 10px;width: 80px;">',
		        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
		            '<td style="padding:0"><b>{point.y:.0f}</b></td></tr>',
		        footerFormat: '</table>',
		        shared: true,
		        useHTML: true
		    },
		    plotOptions: {
		        column: {
		            pointPadding: 0.2,
		            borderWidth: 0
		        }
		    },
		    series: [{
		        name: '指标',
		        data: rptdata.targetdailydata[0].vdata
		
		    }, {
		        name: '完成量',
		        data: rptdata.dailydata[0].vdata
		
		    }]
		});
}		
	</script>
	<input type="hidden" name="deptIds" id="deptIds" value="<%=deptIds%>" />
</body>
</html>