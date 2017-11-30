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
<script type="text/javascript" src="${ctx }/js/ama/js/plugins/jquery.smartWizard-2.0.min.js"></script>
<script type="text/javascript">
	$(function(){
		$("#kpitarget #plantKPISubmit").click(function(){
			if(validateForm("kpitarget")){
				if(!isNumeric($("#kpitarget #target_start").val())||!isNumeric($("#kpitarget #target_end").val())){
					showMsgInfo('TARGET值必须数值！');
					return ;
				}
				if (confirm('是否提交？')) {
						var param = getParamsJson("kpitarget");
						ajaxUrl(ctx+'/common/plantKPI/plantKPITargetAdd.do',param,function(json){
							showMsgInfo(json.msg+'');
							parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
							plant_kpi_view_inner();
						});
					}
			}
		});
		$("#kpiactual #plantKPISubmit").click(function(){
			if(validateForm("kpiactual")){
				if(!isNumeric($("#kpiactual #actual").val())){
					showMsgInfo('ACTUAL值必须数值！');
					return ;
				}
				if($("#kpiactual #ext_3").val()=='正向'){
					if(parseFloat($("#kpiactual #actual").val())>=parseFloat($("#kpiactual #target").val())){
						$("#kpiactual #health_png").val('${ctx}/images/<%=Global.plant_kpi_health[0]%>.png');
					}else{
						$("#kpiactual #health_png").val('${ctx}/images/<%=Global.plant_kpi_health[1]%>.png');
					}
				}else if($("#kpiactual  #ext_3").val()=='反向'){
					if(parseFloat($("#kpiactual #actual").val())<=parseFloat($("#kpiactual #target").val())){
						$("#kpiactual #health_png").val('${ctx}/images/<%=Global.plant_kpi_health[0]%>.png');
					}else{
						$("#kpiactual #health_png").val('${ctx}/images/<%=Global.plant_kpi_health[1]%>.png');
					}
				}
				if (confirm('是否提交？')) {
						var param = getParamsJson("kpiactual");
						param['kpi_date'] = param['kpi_date']+" 00:00:00";
						ajaxUrl(ctx+'/common/plantKPI/plantKPIAdd.do',param,function(json){
							showMsgInfo(json.msg+'');
							parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
							plant_kpi_view_inner();
						});
					}
			}
		});
		plant_kpi_view_inner();
	});
	function plant_kpi_view_inner(){
		var params = {};
		inner_html(ctx+'/faurecia/ETOP5/plant_kpi/data/plant_kpi_data_view.jsp',params,'plant_kpi_view');
	}
</script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<div class="widgetbox">
			<div class="title">
				<h4>PLANT KPI</h4>
			</div>
			<div class="widgetcontent">
				<div id="tabs">
					<ul>
						<li><a href="#kpitarget"><span>TARGET</span></a></li>
						<li><a href="#kpiactual"><span>ACTUAL</span></a></li>
					</ul>
					<div id="kpitarget" class="formwiz">
						<jsp:include page="/faurecia/ETOP5/plant_kpi/data/plant_kpi_data_target_add.jsp" />
					</div>
					<div id="kpiactual" class="formwiz">
						<jsp:include page="/faurecia/ETOP5/plant_kpi/data/plant_kpi_data_actual_add.jsp" />
					</div>
				</div>
			</div>
		</div>
		<div id="plant_kpi_view"></div>
	</div>
</body>
</html>