<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
%>
<div id="searchUser" class="overviewhead">
	用户名：&nbsp;<input type="text" id="name" name="name" value=""/>  &nbsp; &nbsp;
	名称: &nbsp;<input type="text" id="zh_name" name="zh_name" value="" />  &nbsp; &nbsp;
	有效: &nbsp;
	    <select id="" name="state">
	        <option value="1">是</option>
	        <option value="0">否</option>
	    </select>	
	<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
</div>