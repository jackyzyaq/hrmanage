<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
%>
<div id="searchUser" class="overviewhead">
	菜单代码：&nbsp;<input type="text" id="menu_code" name="menu_code" value=""/>  &nbsp; &nbsp;
	菜单名称: &nbsp;<input type="text" id="menu_name" name="menu_name" value="" />  &nbsp; &nbsp;
	上级菜单名称: &nbsp;<input type="text" id="parent_menu_name" name="parent_menu_name" value="" />  &nbsp; &nbsp;	
	有效: &nbsp;
	    <select id="" name="state">
	        <option value="1">是</option>
	        <option value="0">否</option>
	    </select>	
	<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
</div>