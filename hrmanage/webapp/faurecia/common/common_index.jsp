<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
    int sub_menu_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("sub_menu_id"), "0"));
    String params = StringUtils.defaultIfEmpty(request.getParameter("params"), "");
    String ids = Util.getMenuAllIdsById(sub_menu_id,menuInfoMap);
    MenuInfo menu3Level = null;
    if(ids.split(",").length>2){
    	menu3Level = menuInfoMap.get(Integer.parseInt(ids.split(",")[2]));
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
</head>
<body class="withvernav">
<div class="bodywrapper">
    <div class="centercontent">
        <div class="pageheader">
            <ul class="hornav">
            <%
            int i=(menu3Level == null?0:menu3Level.getId());
    		for(Integer key:menuInfoMap.keySet()){ 
    			MenuInfo mi = menuInfoMap.get(key);
    			if(mi.getParent_id().intValue()!=Integer.parseInt(menu_id)||mi.getIs_menu().intValue()==2)continue;
    			if(i==0){
    				i=key;
    			}
    		%>
    		<li class="<%=(i==key?"current":"")%> "><a style="cursor:pointer;" onclick="$('#portal_right li').each(function(){$(this).attr('class','');});$(this).parent().attr('class','current');common_frame_src('${ctx }<%=mi.getUrl() %><%=(mi.getUrl().indexOf("?")>-1?"&":"?")%>menu_id=<%=mi.getId()%>','iframe_menu_<%=mi.getId()%>');"><%=mi.getMenu_name() %></a></li>
        	<%} %>
            </ul>
        </div>
        <div id="contentwrapper" class="contentwrapper"></div>
	</div>
	<script type="text/javascript">
	$(function(){
		$("#contentwrapper").css("height",$(window).height());
		if(<%=(i==0?"false":"true")%>){
			var defaultUrl = '<%=(i==0?"":StringUtils.defaultIfEmpty(menuInfoMap.get(i).getUrl(),""))%><%=(menuInfoMap.get(i).getUrl().indexOf("?")>-1?"&":"?")%>menu_id=<%=i%>';
			common_frame_src("${ctx }"+defaultUrl+"&params=<%=params %>","iframe_menu_<%=i%>");
		}else{
			$("#contentwrapper").empty();
		}
	});	
	function common_frame_src(url,name){
		$("#contentwrapper").empty();
		var content = '<iframe scrolling="yes" id="'+name+'" name="'+name+'" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
		$("#contentwrapper").html(content);
	}
	</script>
</div><!--bodywrapper-->
</body>
</html>	