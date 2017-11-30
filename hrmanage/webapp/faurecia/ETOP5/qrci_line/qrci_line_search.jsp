<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	boolean isSH = Boolean.parseBoolean(StringUtils.defaultIfEmpty(request.getParameter("isSH"), "false"));
	boolean isAllEmp = Boolean.parseBoolean(StringUtils.defaultIfEmpty(request.getParameter("isAllEmp"), "false"));

	UserInfo user = (UserInfo)session.getAttribute("user");
%>
<div id="search" class="overviewhead" style="margin-bottom:10px;">
	<div>
		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			<thead>
				<tr>
					<th class="head1"></th>
				    <th class="head1"></th>
				    <th class="head1"></th>
				    <th class="head1"></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td align="left">
						QRCI TYPE：&nbsp;<jsp:include page="/faurecia/ETOP5/qrci_line/auto_qrci_line.jsp" />&nbsp;
					</td>
					<td align="left">
						状态：&nbsp;
						<select id="state" name="state" style="height: 30px">
			            	<option value="0">无效</option>
			            	<option value="1" selected>有效</option>
			               	<option value="2">关闭</option>
			            </select>
						&nbsp;
					</td>
					<td align="left">
						提交者：&nbsp;<input type="text" id="operater" name="operater" value=""/>&nbsp;
					</td>
					<td align="left">
						<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>