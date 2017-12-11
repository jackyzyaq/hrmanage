<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ include file="/faurecia/improvement/connector.jsp"%>
<script type="text/javascript">

function wdateInstanceforImp(){
	WdatePicker({dateFmt:'yyyyMM',alwaysUseStartDate:false});
}
</script>
<div id="search" class="overviewhead">
	部门：&nbsp;<input id="targetDeptName" name="targetDeptName" value=""/>&nbsp;
	月份：&nbsp;<input class="Wdate" onclick="wdateInstanceforImp();" type="text" readonly="readonly" id="targetMonth" name="targetMonth" value=""/>&nbsp;
	<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>
</div>