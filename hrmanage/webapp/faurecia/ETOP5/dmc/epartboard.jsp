<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
	$(function(){
	});	
	function loadTab(obj){
		if(typeof($(obj).attr("url")) != "undefined"&&$(obj).attr("url").length>0){
			click_no($(obj).attr("url"));
		}
	}
</script>
</head>
<body>
<div>
	<%
		String width = "160px",height="50px";
		out.print("<div onclick='loadTab(this);' url='http://cnantmii0001.ant.cn.corp:50000/XMII/CM/SC_DMC/SHOP_FLOOR_MANAGEMENT/HOME/ShopFloorMngt.irpt?plcid=CD539_40&operator=A&j_username=dmcts5&j_password=Faurecia2' class='shadowdiv gradient1' style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666'>");
		out.print("CD539 40%");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div onclick='loadTab(this);' url='http://cnantmii0001.ant.cn.corp:50000/XMII/CM/SC_DMC/SHOP_FLOOR_MANAGEMENT/HOME/ShopFloorMngt.irpt?plcid=CD539_50&operator=A&j_username=dmcts5&j_password=Faurecia2' class='shadowdiv gradient1' style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666'>");
		out.print("CD539 50%");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div onclick='loadTab(this);' url='http://cnantmii0001.ant.cn.corp:50000/XMII/CM/SC_DMC/SHOP_FLOOR_MANAGEMENT/HOME/ShopFloorMngt.irpt?plcid=CD539&operator=A&j_username=dmcts5&j_password=Faurecia2' class='shadowdiv gradient1' style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666'>");
		out.print("CD539 60%");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div onclick='loadTab(this);' url='http://cnantmii0001.ant.cn.corp:50000/XMII/CM/SC_DMC/SHOP_FLOOR_MANAGEMENT/HOME/ShopFloorMngt.irpt?plcid=L200&operator=A&j_username=dmcts5&j_password=Faurecia2' class='shadowdiv gradient1' style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666'>");
		out.print("L200");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div onclick='loadTab(this);' url='http://cnantmii0001.ant.cn.corp:50000/XMII/CM/SC_DMC/SHOP_FLOOR_MANAGEMENT/HOME/ShopFloorMngt.irpt?plcid=L300&operator=A&j_username=dmcts5&j_password=Faurecia2' class='shadowdiv gradient1' style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666'>");
		out.print("L300");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div onclick='loadTab(this);' url='http://cnantmii0001.ant.cn.corp:50000/XMII/CM/SC_DMC/SHOP_FLOOR_MANAGEMENT/HOME/ShopFloorMngt.irpt?plcid=CD539W&operator=A&j_username=dmcts5&j_password=Faurecia2' class='shadowdiv gradient1' style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666'>");
		out.print("CD539W");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div class='clearall'></div><br/>");
		
		out.print("<div onclick='loadTab(this);' url='http://cnantmii0001.ant.cn.corp:50000/XMII/CM/SC_DMC/SHOP_FLOOR_MANAGEMENT/HOME/ShopFloorMngt.irpt?plcid=E2XX40W&operator=A&j_username=dmcts5&j_password=Faurecia2' class='shadowdiv gradient1' style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666'>");
		out.print("E2XX40W");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div onclick='loadTab(this);' url='http://cnantmii0001.ant.cn.corp:50000/XMII/CM/SC_DMC/SHOP_FLOOR_MANAGEMENT/HOME/ShopFloorMngt.irpt?plcid=E2XX60W&operator=A&j_username=dmcts5&j_password=Faurecia2' class='shadowdiv gradient1' style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666'>");
		out.print("E2XX60W");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div onclick='loadTab(this);' url='http://cnantmii0001.ant.cn.corp:50000/XMII/CM/SC_DMC/SHOP_FLOOR_MANAGEMENT/HOME/ShopFloorMngt.irpt?plcid=PQ25W1&operator=A&j_username=dmcts5&j_password=Faurecia2' class='shadowdiv gradient1' style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666'>");
		out.print("PQ25W1");
		out.print("</td></tr></table>");
		out.print("</div>");
		
		out.print("<div onclick='loadTab(this);' url='http://cnantmii0001.ant.cn.corp:50000/XMII/CM/SC_DMC/SHOP_FLOOR_MANAGEMENT/HOME/ShopFloorMngt.irpt?plcid=PQ25W1&operator=A&j_username=dmcts5&j_password=Faurecia2' class='shadowdiv gradient1' style='cursor:pointer;width:"+width+";position:relative; margin:5px 20px 5px 0px; float:left;'>");
		out.print("<table style='width: 100%;height:"+height+";border: 4px solid "+Global.colors[2]+";overflow: hidden;'>");
		out.print("<tr><td style='text-align: center; vertical-align: middle;font-size:24px;font-weight:bold;color:#666'>");
		out.print("PQ25W2");
		out.print("</td></tr></table>");
		out.print("</div>");		
	%>
</div><!--bodywrapper-->
</body>
</html>	