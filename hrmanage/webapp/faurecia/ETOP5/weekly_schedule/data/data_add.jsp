<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	Calendar cal = Calendar.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
	$(function(){
		loadTab('tabs-1');
	});
	function loadTab(tab,_fn){
		$("#"+tab).empty();
		var url = '';
		if(tab=='tabs-1'){
			url = (ctx+'/faurecia/ETOP5/weekly_schedule/data/add_inner.jsp?menu_id=<%=menu_id%>');
		}else if(tab=='tabs-2'){
			url = (ctx+'/faurecia/ETOP5/weekly_schedule/data/data_view.jsp?menu_id=<%=menu_id%>');
		}
		if(url!='')
			inner_html(url,null,tab,function(data){
				$("#"+tab).html(data);
				if(typeof(_fn) == 'function'){
					_fn();
				}
			});
	}
	function managementScheduleIn(managementScheduleId){
		var _url = ctx+'/common/managementSchedule/queryResult.do';
		var param = {};
		param['pageIndex']=1;
		param['pageSize']=10;
		param['id']=managementScheduleId;
		ajaxUrl(_url,param,function(json){
			$.each(json.rows, function (n, value) {
				$.each(value, function(k, v){
					if(k=='time'){
						$("#"+k+"1").val(v.split("~")[0]);
						$("#"+k+"2").val(v.split("~")[1]);
					}else{
						$("#"+k).val(v);
					}
				});
	        });
	        $('#tabs-a-1').attr("onclick","loadTab('tabs-1')");
		});
	}		
</script>
</head>
<body>
<div class="widgetbox" style="margin: 5px;">
	<div class="widgetcontent">
	    <div id="tabs">
	        <ul>
	            <li><a id="tabs-a-1" href="#tabs-1" onclick="loadTab('tabs-1');">添加</a></li>
	            <li><a id="tabs-a-2" href="#tabs-2" onclick="loadTab('tabs-2');">列表</a></li>
	        </ul>
			<div id="tabs-1" ></div>
			<div id="tabs-2" ></div>
	    </div><!--#tabs-->
	</div><!--widgetcontent-->
</div><!--widgetbox-->
</body>
</html>