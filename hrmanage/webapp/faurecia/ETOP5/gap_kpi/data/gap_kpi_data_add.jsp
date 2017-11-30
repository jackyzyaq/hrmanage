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
		$("#kpitarget #gapKPISubmit").click(function(){
			if(validateForm("kpitarget")){
				if(!isNumeric($("#kpitarget #target_start").val())||!isNumeric($("#kpitarget #target_end").val())){
					showMsgInfo('TARGET值必须数值！');
					return ;
				}
				if (confirm('是否提交？')) {
					var param = getParamsJson("kpitarget");
					ajaxUrl(ctx+'/common/gapKPI/validKPITarget.do',param,function(json){
						if(json.msg==''){
							ajaxUrl(ctx+'/common/gapKPI/gapKPITargetAdd.do',param,function(json){
								showMsgInfo(json.msg+'');
								parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
								gap_kpi_view_inner();
							});
						}else{
							if (confirm(json.msg+'，提交后会清除原先的数据，是否继续？')) {
								ajaxUrl(ctx+'/common/gapKPI/gapKPITargetAdd.do',param,function(json){
									showMsgInfo(json.msg+'');
									parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
									gap_kpi_view_inner();
								});
							}
						}
					});
				}
			}
		});
		$("#kpiactual #gapKPISubmit").click(function(){
			if(validateForm("kpiactual")){
				if(!isNumeric($("#kpiactual #actual").val())){
					showMsgInfo('ACTUAL值必须数值！');
					return ;
				}
				
				if (confirm('是否提交？')) {
						var param = getParamsJson("kpiactual");
						param['kpi_date'] = param['kpi_date']+" 00:00:00";
						param['ext_10'] = $("#kpiactual #parent").val();
						ajaxUrl(ctx+'/common/gapKPI/gapKPIAdd.do',param,function(json){
							showMsgInfo(json.msg+'');
							parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
							gap_kpi_view_inner();
						});
					}
			}
		});
		gap_kpi_view_inner();
	});
	function gap_kpi_view_inner(){
		var params = {};
		inner_html(ctx+'/faurecia/ETOP5/gap_kpi/data/gap_kpi_data_view.jsp',params,'gap_kpi_view');
	}
</script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<div class="widgetbox">
			<div class="title">
				<h4>Gap KPI</h4>
			</div>
			<div class="widgetcontent">
				<div id="tabs">
					<ul>
						<li><a href="#kpitarget"><span>TARGET</span></a></li>
						<li><a href="#kpiactual"><span>ACTUAL</span></a></li>
					</ul>
					<div id="kpitarget" class="formwiz">
						<jsp:include page="/faurecia/ETOP5/gap_kpi/data/gap_kpi_data_target_add.jsp" />
					</div>
					<div id="kpiactual" class="formwiz">
						<jsp:include page="/faurecia/ETOP5/gap_kpi/data/gap_kpi_data_actual_add.jsp" />
					</div>
				</div>
			</div>
		</div>
		<div id="gap_kpi_view"></div>
	</div>
</body>
</html>