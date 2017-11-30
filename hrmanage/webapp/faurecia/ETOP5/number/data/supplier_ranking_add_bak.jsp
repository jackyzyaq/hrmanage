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
	var _employee_type = '<%=Global.employee_type[0]%>';
	$(function(){
		$("#begin_month").val("<%=cal.get(Calendar.YEAR)+"-"+(cal.get(Calendar.MONTH)+1) %>");
		$("#supplierRankingSubmit").click(function(){
			if(validateForm("supplier_ranking_form")){
				if(!isNumeric($("#kpi_1").val())){
					showMsgInfo('数据格式不对！');
				}else{
					if (confirm('是否提交？')) {
						var param = getParamsJson("supplier_ranking_form");
						param['begin_month'] = param['begin_month']+"-01 00:00:00";
						ajaxUrl(ctx+'/common/supplierranking/supplierRankingAdd.do',param,function(json){
							if(json.flag=='1'){
							}else{
								showMsgInfo(json.msg+'');
								parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
								supplier_ranking_view_inner();
							}
						});
					}
				}
			}
		});
		supplier_ranking_view_inner();
	});
	function supplier_ranking_view_inner(){
		var params = {};
		ranking_inner(ctx+'/faurecia/ETOP5/number/data/supplier_ranking_view.jsp',params,'supplier_ranking_view');
	}
</script>
<script type="" src="${ctx }/faurecia/ETOP5/number/data/js/number_data.js"></script>	
</head>
<body>
	<div id="contentwrapper" class="contentwrapper widgetpage">
		<div class="widgetbox">
			<form id="supplier_ranking_form" class="stdform" onSubmit="return false;">
				<div class="title">
					<h4>供应商排行榜</h4>
				</div>
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <thead>
			                <tr>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                </tr>
			            </thead>
			            <tbody>
			            	<tr>
					        	<td>供应商</td>
					        	<td id="auto_spplier">
					        		<jsp:include page="/share/jsp/auto_supplier.jsp">
					        			<jsp:param value="#contentwrapper #auto_spplier" name="parent_div"/>
					        		</jsp:include>
					        	</td>
			                </tr>
							<tr>
			                    <td>月份</td>
			                    <td>
			                    	<input class="smallinput" title="月份" type="text" readonly="readonly" id="begin_month" name="begin_month" value=""/>
			                    </td>
			                </tr>
							<tr>
			                    <td>数据</td>
			                    <td>
			                    	<input class="longinput" title="数据" type="text" id="kpi_1" name="kpi_1" value=""/>
			                    </td>
			                </tr>
			                <tr>
			                	<td colspan="2">
				                	<div class="stdformbutton">
									<button id="supplierRankingSubmit" class="submit radius2">提交</button>
									</div>
			                	</td>
			                </tr>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->
			</form>
		</div>
		<!--widgetbox-->
		<div id="supplier_ranking_view"></div>
	</div>
</body>
</html>
