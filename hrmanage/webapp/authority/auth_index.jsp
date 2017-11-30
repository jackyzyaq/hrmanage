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
</head>
<body class="withvernav">
<div class="bodywrapper">
    <div class="centercontent">
        <div class="pageheader">
            <ul class="hornav">
            <%
            int i=0;
    		for(Integer key:menuInfoMap.keySet()){ 
    			MenuInfo mi = menuInfoMap.get(key);
    			if(mi.getParent_id().intValue()!=Integer.parseInt(menu_id))continue;
    			if(i==0){
    				i=key;
    			}
    		%>
    		<li class="<%=(i==key?"current":"")%> "><a style="cursor:pointer;" onclick="$('#portal_right li').each(function(){$(this).attr('class','');});$(this).parent().attr('class','current');authority_frame_src('${ctx }<%=mi.getUrl() %>?menu_id=<%=mi.getId()%>','iframe_menu_<%=mi.getId()%>');"><%=mi.getMenu_name() %></a></li>
        	<%} %>
            </ul>
        </div>
        
        <div id="contentwrapper" class="contentwrapper"></div>
	</div>
	<script type="text/javascript">
	$(function(){
		$("#contentwrapper").css("height",$(window).height());
		if(<%=(i==0?"false":"true")%>){
			var defaultUrl = '<%=(i==0?"":StringUtils.defaultIfEmpty(menuInfoMap.get(i).getUrl(),""))%>?menu_id=<%=i%>';
			authority_frame_src("${ctx }"+defaultUrl,"iframe_menu_<%=i%>");
		}else{
			$("#contentwrapper").empty();
		}
	});	
	function authority_frame_src(url,name){
		$("#contentwrapper").empty();
		var content = '<iframe scrolling="yes" id="'+name+'" name="'+name+'" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
		$("#contentwrapper").html(content);
	}
	</script>
</div><!--bodywrapper-->
</body>
</html>	