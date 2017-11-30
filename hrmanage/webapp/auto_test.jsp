<%@ page language="java" pageEncoding="UTF-8"%>
<jsp:directive.page import="java.text.SimpleDateFormat"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%
String deptIdsRole = (String) session.getAttribute("deptIdsRole");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
body { font-family: sans-serif; font-size: 14px; line-height: 1.6em; margin: 0; padding: 0; }
.container { width: 800px; margin: 0 auto; }
.autocomplete-suggestions { border: 1px solid #999; background: #FFF; cursor: default; overflow: auto; -webkit-box-shadow: 1px 4px 3px rgba(50, 50, 50, 0.64); -moz-box-shadow: 1px 4px 3px rgba(50, 50, 50, 0.64); box-shadow: 1px 4px 3px rgba(50, 50, 50, 0.64); }
.autocomplete-suggestion { padding: 2px 5px; white-space: nowrap; overflow: hidden; }
.autocomplete-no-suggestion { padding: 2px 5px;}
.autocomplete-selected { background: #F0F0F0; }
.autocomplete-suggestions strong { font-weight: bold; color: #000; }
.autocomplete-group { padding: 2px 5px; }
.autocomplete-group strong { font-weight: bold; font-size: 16px; color: #000; display: block; border-bottom: 1px solid #000; }
input { font-size: 28px; padding: 10px; border: 1px solid #CCC; display: block; margin: 20px 0; }
</style>
    <script type="text/javascript" src="${ctx }/share/js/util.js"></script>
    <script type="text/javascript" src="${ctx }/js/autocomplete/scripts/jquery-1.8.2.min.js"></script>
    <script type="text/javascript" src="${ctx }/js/autocomplete/scripts/jquery.autocomplete.js"></script>
	<script type="text/javascript">
	$(function () {
	    $('#emp_name').autocomplete({
	        //lookup: [{"id":"1","value":"倪健1","emp_code":"FN000001"}],
	        serviceUrl: '${ctx}/common/employeeInfo/autoComplete.do?dept_ids=<%=deptIdsRole%>',
	        paramName:'emp_name',
    		onSelect: function (suggestion) {
        		//alert('You selected: ' + suggestion.zh_name + ', ' + suggestion.cgi);
        		$("#emp_id").val(suggestion.id);
    		},
    		onSearchComplete: function (query, suggestions) {
    			//alert(suggestions);
    		},
    		formatResult: function (suggestion, currentValue) {
    			currentValue = suggestion.value+'('+suggestion.id+')';
    			return currentValue;
    		}
	    });
	});
	</script>
</head>
<body>
    <div style="width: 50%; margin: 0 auto; clear: both;">
        <div>
            <input type="text" name="emp_name" id="emp_name" style="width: 100%; border-width: 5px;" value="倪健1"/>
        </div>
    </div>
    
    <div style="width: 50%; margin: 0 auto; clear: both;">
        <div>
            <input type="text" name="emp_id" id="emp_id" style="width: 100%; border-width: 5px;" value=""/>
        </div>
    </div>
</body>
</html>