<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<div id="searchUser" class="overviewhead">
	职位代码：&nbsp;<input type="text" id="pos_code" name="pos_code" value=""/>  &nbsp; &nbsp;
	职位名称: &nbsp;<input type="text" id="pos_name" name="pos_name" value="" />  &nbsp; &nbsp;
	有效: &nbsp;
	    <select id="" name="state">
	        <option value="1">是</option>
	        <option value="0">否</option>
	    </select>	
	<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
</div>