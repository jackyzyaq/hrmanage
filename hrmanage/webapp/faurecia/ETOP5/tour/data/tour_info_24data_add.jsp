<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	String tour_info_id = StringUtils.defaultIfEmpty(request.getParameter("tour_info_id"), "0");
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	SimpleDateFormat sdfB = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/js/time/timedropper.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx }/js/time/timedropper.css"/>
<script type="text/javascript">
	$(function(){
		$("#report_date").click(function(){
			WdatePicker({startDate:'%y-%M-%d 07:00:00',dateFmt:'yyyy-MM-dd HH:00:00'});
		});
		$("#tour_info_form #tourInfoSubmit").click(function(){
			if(validateForm("tour_info_form")){
				if (confirm('是否提交？')) {
					var param = getParamsJson("tour_info_form");
					param['time']=param['time1']+'~'+param['time2'];
					param['emp_ids']=param['emp_id'];
					ajaxUrl(ctx+'/common/tour/tour24DataAdd.do',param,function(json){
						showMsgInfo(json.msg+'');
						document.location.reload(true);
					});
				}
			}
		});
	});
</script>
</head>
<body>
<div class="widgetbox" style="margin: 5px;">
	<div class="widgetcontent">
<form id="tour_info_form" class="stdform" onSubmit="return false;">
<div class="widgetcontent padding0 statement">
   <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
        <thead>
            <tr>
                <th class="head1" style="width: 15%"></th>
                <th class="head1" style="width: 25%"></th>
                <th class="head1" style="width: 15%"></th>
                <th class="head1" style="width: 15%"></th>
                <th class="head1" style="width: 15%"></th>
                <th class="head1" style="width: 15%"></th>
            </tr>
        </thead>
        <tbody>
			<tr>
				<td style="font-weight:bold" align="center">Date</td>
				<td>
					<input class="longinput"  type="text" id="report_date" title="Date" name="report_date" value="<%=report_date+" 07:00:00"%>"/>
				</td>
				<td style="font-weight:bold" align="center">Unit</td>
				<td>
					<input class="longinput"  type="text" id="unit" title="Unit" name="unit" value=""/>
				</td>
				<td style="font-weight:bold" align="center">Data</td>
				<td>
					<input class="longinput"  type="text" id="data24" title="Data" name="data24" value=""/>
				</td>
			</tr>
            <tr>
				<td colspan="6">
	            	<div class="stdformbutton">
	            	<input type="hidden" id="tour_info_id" name="tour_info_id" value="<%=tour_info_id%>"/>
					<button id="tourInfoSubmit" class="submit radius2">Submit</button>
					</div>
				</td>
            </tr>
        </tbody>
    </table>
</div><!--widgetcontent-->
</form>	    
	</div><!--widgetcontent-->
</div><!--widgetbox-->
</body>
</html>