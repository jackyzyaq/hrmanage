<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	Calendar cal = Calendar.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script>
	$(function(){
		$("#pipdDataSubmit").click(function(){
			if(validateForm("pipd_data_form")){
				var msg = validData().Trim();
				if(msg.length>0){
					showMsgInfo(msg);
				}else{
					if (confirm('是否提交？')) {
						var param = getParamsJson("pipd_data_form");
						param['type'] = '',param['reality_pipd_data'] = '',param['must_pipd_data'] = '';
						param['type1'] = '',param['reality_pipd_data1'] = '',param['must_pipd_data1'] = '';
						var valForm = $("#pipd_data_form table tbody").find("*");
						$.each(valForm,function(i,v){
							if($(this).is("tr")&&typeof($(this).attr('id'))!="undefined"){
								param['type1'] = param['type1']+$("#"+$(this).attr('id')+" #type").val()+"|";
								param['reality_pipd_data1'] = param['reality_pipd_data1']+$("#"+$(this).attr('id')+" #reality_pipd_data").val()+"|";
								param['must_pipd_data1'] = param['must_pipd_data1']+$("#"+$(this).attr('id')+" #must_pipd_data").val()+"|";
							}
						});
						param['report_date'] = param['report_date']+"-01 00:00:00";
						ajaxUrl(ctx+'/common/pipd/pipdDataAdd.do',param,function(json){
							if(json.flag=='1'){
							}else{
								showMsgInfo(json.msg+'');
								parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
								pipd_data_view_inner();
							}
						});
					}
				}
				
			}
		
		});
		pipd_data_view_inner();
	});
	function pipd_data_view_inner(){
		var params = {};
		inner_html(ctx+'/faurecia/ETOP5/pipd/data/pipd_data_view.jsp',params,'pipd_data_view',null);
	}
	function validData(){
		var msg = '';
		var valForm = $("#pipd_data_form table tbody").find("*");
		$.each(valForm,function(i,v){
			if($(this).is("tr")&&typeof($(this).attr('id'))!="undefined"){
				if(!isNumeric($("#"+$(this).attr('id')+" #reality_pipd_data").val())||!isNumeric($("#"+$(this).attr('id')+" #must_pipd_data").val())){
					msg = "数据格式不对！";
				}
			}
		});
		return msg;
	}
</script>	
</head>
<body>
	<div id="contentwrapper" class="contentwrapper widgetpage">
		<div class="widgetbox">
			<form id="pipd_data_form" class="stdform" onSubmit="return false;">
				<div class="title">
					<h4><%=Global.pip_head[0].replace("<br/>","")%>&nbsp;</h4>
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
			                    <th class="head1" style="width:10%"></th>
			                </tr>
			            </thead>
			            <tbody>
			            	<tr>
			            		<td>月份</td>
			                    <td>
			                    	<input class="longinput" title="月份" type="text" readonly="readonly" id="report_date" name="report_date" value="<%=cal.get(Calendar.YEAR)+"-"+(cal.get(Calendar.MONTH)+1) %>"  onclick="wdateYearMonthInstance('report_date');"/>
			                    </td>
			                    <td></td>
			                    <td></td>
			                    <td></td>
			                    <td></td>
			                    <td></td>
			                </tr>
			                <%for(String type:Global.pip_item){ 
			                	type=type.replace("<br/>", "");
			                %>
			            	<tr id="<%=type%>">
			            		<td>数据类型</td>
			                    <td>
			                    	<input class="longinput" title="数据类型" type="text" readonly="readonly" id="type" name="type" value="<%=type %>" />
			                    </td>
			                    <td>达标值</td>
			                    <td>
			                    	<input class="longinput" title="达标值" type="text" id="must_pipd_data" name="must_pipd_data" value=""/>
			                    </td>
			                    <td>实际值</td>
			                    <td>
			                    	<input class="longinput" title="实际值" type="text" id="reality_pipd_data" name="reality_pipd_data" value=""/>
			                    </td>
			                    <td></td>
			                </tr>
			                <%} %>
			                <tr>
			                	<td colspan="7">
				                	<div class="stdformbutton">
				                	<input type="hidden" id="sub_type" name="sub_type" value="<%=Global.pip_head[0]%>"/>
									<button id="pipdDataSubmit" class="submit radius2">提交</button>
									</div>
			                	</td>
			                </tr>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->
			</form>
		</div>
		<!--widgetbox-->
		<div id="pipd_data_view"></div>
	</div>
</body>
</html>
