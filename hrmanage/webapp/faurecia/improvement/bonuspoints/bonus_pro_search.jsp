<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ include file="/faurecia/improvement/connector.jsp"%>
<div id="search" class="overviewhead">
	<%-- 现有积分：&nbsp;<span><%=StringUtils.defaultIfEmpty(request.getParameter("bp_value"), "") %></span> --%>
	礼品名：&nbsp;<input id="proname" name="proname" value=""/>&nbsp;
	积分（小于）：&nbsp;<input id="BPValues" name="BPValues" value=""/>&nbsp;
	库存（大于）：&nbsp;<input id="prostock" name="prostock" value=""/>&nbsp;
	<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
</div>