<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String type = StringUtils.defaultIfEmpty(request.getParameter("type"), "");
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"), "");
	String end_month = StringUtils.defaultIfEmpty(request.getParameter("end_month"), "");
	Calendar cal = Calendar.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script>
	$(function(){
		<%if(!StringUtils.isEmpty(type)){%>
		$("#type").val('<%=type%>');
		<%}%>
		$("#pipdPrioritiesManagementSubmit").click(function(){
			if(validateForm("pipd_priorities_management_form")){
					if (confirm('是否提交？')) {
						var param = getParamsJson("pipd_priorities_management_form");
						param['begin_month'] = param['begin_month']+"-01 00:00:00";
						param['end_month'] = param['end_month']+"-01 00:00:00";
						ajaxUrl(ctx+'/common/pipdPrioritiesManagement/pipdPrioritiesManagementAdd.do',param,function(json){
							if(json.flag=='1'){
							}else{
								showMsgInfo(json.msg+'');
								parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
								pipd_priorities_management_view_inner();
							}
						});
					}
			}
		});
		pipd_priorities_management_view_inner();
	});
	function pipd_priorities_management_view_inner(){
		var params = {};
		params['type']='<%=type %>';
		inner_html(ctx+'/faurecia/ETOP5/pipd/data/pipd_priorities_management_view.jsp',params,'pipd_priorities_management_view',null);
	}
	function editFile(upload_uuid){
	}	
</script>	
</head>
<body>
	<div id="contentwrapper" class="contentwrapper widgetpage">
		<div class="widgetbox">
			<form id="pipd_priorities_management_form" class="stdform" onSubmit="return false;">
				<div class="title">
					<h4>Priorities Management<%="&nbsp;&nbsp;&nbsp;"+type+"&nbsp;&nbsp;&nbsp;" %></h4>
				</div>
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <thead>
			                <tr>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                </tr>
			            </thead>
			            <tbody>
			            	<tr>
			                    <td>数据类型</td>
			                    <td>
			                    	<select id="type" name="type" title="数据类型">
			                    		<%for(int i=0;i<Global.pip_item.length;i++){ 
			                    			String item = Global.pip_item[i];
			                    		%>
			                    		<option value="<%=item.replace("<br/>","")%>" <%=(i==0?"selected":"") %>><%=item.replace("<br/>","")%></option>
			                    		<%} %>
			                    	</select>
			                    </td>
			                    <td>开始月份</td>
			                    <td>
			                    	<input class="longinput" title="开始月份" type="text" readonly="readonly" id="begin_month" name="begin_month" value="<%=begin_month %>"  onclick="wdateYearMonthInstance('begin_month');"/>
			                    </td>
			                    <td>结束月份</td>
			                    <td>
			                    	<input class="longinput" title="结束月份" type="text" readonly="readonly" id="end_month" name="end_month" value="<%=end_month %>"  onclick="wdateYearMonthInstance('end_month');"/>
			                    </td>
			                    <td></td>
			                    <td></td>
			                </tr>
			                <tr>
			                    <td>Breakthrough</td>
			                    <td>
			                    	<input class="longinput" title="Breakthrough" type="text" id="kpi_v1" name="kpi_v1" value="" />
			                    </td>
			                    <td>DailyManagement</td>
			                    <td>
			                    	<input class="longinput" title="DailyManagement" type="text" id="kpi_v2" name="kpi_v2" value="" />
			                    </td>
			                    <td>MacroActivities</td>
			                    <td>
			                    	<input class="longinput" title="MacroActivities" type="text" id="kpi_v3" name="kpi_v3" value="" />
			                    </td>
			                    <td>Responsible</td>
			                    <td>
			                    	<input class="longinput" title="Responsible" type="text" id="kpi_v4" name="kpi_v4" value="" />
			                    </td>
			                </tr>
			                <tr>
			                    <td>Support</td>
			                    <td>
			                    	<input class="longinput" title="Support" type="text" id="kpi_v5" name="kpi_v5" value="" />
			                    </td>
			                    <td>OutputKPI</td>
			                    <td>
			                    	<input class="longinput" title="OutputKPI" type="text" id="kpi_v6" name="kpi_v6" value="" />
			                    </td>
			                    <td>Initial16.6</td>
			                    <td>
			                    	<input class="longinput" title="Initial16.6" type="text" id="kpi_v7" name="kpi_v7" value="" />
			                    </td>
			                    <td>Actual16.6</td>
			                    <td>
			                    	<input class="longinput" title="Actual16.6" type="text" id="kpi_v8" name="kpi_v8" value="" />
			                    </td>
			                </tr>
			                <tr>
			                    <td>Tgt6m16.12</td>
			                    <td>
			                    	<input class="longinput" title="Tgt6m16.12" type="text" id="kpi_v9" name="kpi_v9" value="" />
			                    </td>
			                    <td>Tgt12m17.6</td>
			                    <td>
			                    	<input class="longinput" title="Tgt12m17.6" type="text" id="kpi_v10" name="kpi_v10" value="" />
			                    </td>
			                    <td>Tgt18m17.12</td>
			                    <td>
			                    	<input class="longinput" title="Tgt18m17.12" type="text" id="kpi_v11" name="kpi_v11" value="" />
			                    </td>
			                    <td></td>
			                    <td></td>
			                </tr>
			                <tr>
			                	<td colspan="8">
				                	<div class="stdformbutton">
									<button id="pipdPrioritiesManagementSubmit" class="submit radius2">提交</button>
									</div>
			                	</td>
			                </tr>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->
			</form>
		</div>
		<!--widgetbox-->
		<div id="pipd_priorities_management_view"></div>
	</div>
</body>
</html>