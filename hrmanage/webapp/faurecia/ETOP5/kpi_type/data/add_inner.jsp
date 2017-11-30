<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	SimpleDateFormat sdfD = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script>
	$(function(){
		$("#kpiTypeAddSubmit").click(function(){
			if(validateForm("kpitType_form")){
				if (confirm('是否提交？')) {
					var param = getParamsJson("kpitType_form");
					ajaxUrl(ctx+'/common/kpiType/kpiTypeAdd.do',param,function(json){
						if(json.flag=='1'){
						}else{
							showMsgInfo(json.msg+'');
							parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
						}
					});
				}
			}
		});
	});
</script>
</head>
<body>
	<div id="contentwrapper">
		<div class="widgetbox">
			<form id="kpitType_form" class="stdform" onSubmit="return false;">
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <thead>
			                <tr>
			                    <th class="head1" style="width:13%"></th>
			                    <th class="head1" style="width:20%"></th>
			                    <th class="head1" style="width:13%"></th>
			                    <th class="head1" style="width:20%"></th>
			                    <th class="head1" style="width:14%"></th>
			                    <th class="head1" style="width:20%"></th>
			                </tr>
			            </thead>
			            <tbody>
			            	<tr>
			                    <td>所属上级</td>
			                    <td>
			                    	<jsp:include page="/share/jsp/kpi_type_ztree.jsp" />
			                    </td>
			                    <td>名称</td>
			                    <td>
			                    	<input type="text" name="name" id="name"  class="mediuminput" value=""/>
			                    </td>
			                    <td>状态</td>
			                    <td>
			                    	<select id="state" name="state">
			                    		<option value="1" selected>有效</option>
			                    	</select>
			                    </td>
			                </tr>
			                <tr>
			                	<td colspan="8">
				                	<div class="stdformbutton">
				                	<input type="hidden" id="id" name="id" value="0"/>
									<button id="kpiTypeAddSubmit" class="submit radius2">提交</button>
									</div>
			                	</td>
			                </tr>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->
			</form>
		</div>
		<!--widgetbox-->
	</div>
</body>
</html>
