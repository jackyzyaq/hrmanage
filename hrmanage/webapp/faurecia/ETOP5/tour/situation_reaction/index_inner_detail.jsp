<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	String dept_id 	= StringUtils.defaultIfEmpty(request.getParameter("dept_id"), "0");
	String tour_info_id = StringUtils.defaultIfEmpty(request.getParameter("tour_info_id"), "0");
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/js/ama/js/plugins/jquery.flot.stack.js"></script>
<script type="text/javascript" src="${ctx }/js/ama/js/plugins/jquery.flot.barnumbers.js"></script>
<style type="">
.stdtable thead th, .stdtable thead td {padding:5px; border-left: 0; text-align: center; }
.stdtable tbody tr td { padding:5px; color: #222;text-align: center; }
.stdtable th, .stdtable td { line-height: 18px; vertical-align: middle; color: #333;font-size: 11px;}
.stdtable tbody tr td:first-child {border-left: 1px solid #D1D1D1;}
.td_t{ font-size: 11px;font-weight:bold;}
.td_s{ font-size: 13px;font-weight:bold;}
</style>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/tour/js/kpi.js"></script>
<script type="text/javascript">
$(function(){
	//loadTab('tabs-1','/faurecia/ETOP5/tour/situation_reaction/status.jsp');
	loadTab(document.getElementById('tab_status'));
});
var objAbj;
function loadTab(obj){
	if(typeof(obj.id) != "undefined"&&obj.id.length>0){
		if(typeof(objAbj) != "undefined"){
			$(objAbj).attr("class","shadowdiv gradient1");
		}
		$(obj).removeAttr("class");
		$(obj).attr("class","shadowdiv");
		objAbj = obj;
		var params = {};
		params['menu_id']=<%=menu_id%>;
		params['tour_info_id']=<%=tour_info_id%>;
		params['report_date']='<%=report_date%>';
		params['dept_id']=<%=dept_id%>;
		inner_html(ctx+$(obj).attr("url"),params,'kpi_data',function(data){
			$("#kpi_data").html(data);
		});
	}
}
</script>
</head>
<body>
<div>
	<%
		String width = "130px",height="50px";
		out.print("<div style='cursor:pointer;width:140px;position:relative; margin:0px 5px 5px 10px; float:left;'>");
		out.print("<table style='width: 95%;height:"+height+";border: 4px solid "+Global.colors[3]+";'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;'>");
		out.print("<a href='javascript:history.back()'><img src='"+request.getContextPath()+"/images/sign-left-icon.png' width='60px' height='60px'/></a>");
		out.print("</td></tr></table>");
		out.print("</div>");
		out.print("<div id='tab_status' onclick='loadTab(this);' url='/faurecia/ETOP5/tour/situation_reaction/status.jsp' class='shadowdiv gradient1'  style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666' title='Status'>");
		out.print("Status");
		out.print("</td></tr></table>");
		out.print("</div>");
		out.print("<div id='tabs_reaction' onclick='loadTab(this);' url='/faurecia/ETOP5/tour/situation_reaction/reaction.jsp' class='shadowdiv gradient1'  style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666' title='Reaction'>");
		out.print("Reaction");
		out.print("</td></tr></table>");
		out.print("</div>");
		out.print("<div id='tabs_history' onclick='loadTab(this);' url='/faurecia/ETOP5/tour/situation_reaction/history.jsp' class='shadowdiv gradient1'  style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666' title='History'>");
		out.print("History");
		out.print("</td></tr></table>");
		out.print("</div>");
	%>
</div>
<div class="clearall"></div>
<div id="contentwrapper" style="margin-left: 10px;margin-right:10px;margin-bottom:5px;text-align:center;">
	<div id="kpi_data" ></div>
</div>
</body>
</html>