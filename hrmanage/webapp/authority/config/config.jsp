<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	ConfigInfoService configInfoService = (ConfigInfoService) ctx.getBean("configInfoService");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	$("#configSubmit").click(function(){
		$("table tbody").find("tr").each(function(){
			var tdArr = $(this).children();
			var name = tdArr.eq(0).text().Trim();
			var value = tdArr.eq(1).find("input").val();
			if(name.Trim()=='提交'||value.Trim()==''||value.indexOf('-')==-1){
			}else{
				var param = {};
				param['name'] = name;
				param['value'] = value;
				ajaxUrl(ctx+'/authority/config/keep_data_config.jsp',param,function(json){
					if(json.flag==0){
						parent.showMsgInfo(json.name+'操作失败！');
					}
				});
			}
		});
	});
});
</script>
</head>
	<body>
		<div id="contentwrapper" class="contentwrapper">
        	<form id="config_form" class="stdform" onSubmit="return false;">
        		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
					<thead>
			        	<tr>
			        		<th class="head1" style="width:10%"></th>
							<th class="head1" style="width:20%"></th>
							<th class="head1" style="width:70%"></th>
			            </tr>
			        </thead>        		
        			<tbody>
			            	<tr>
			            		<td><%=Global.breaktime_type[2].split("\\|")[0] %></td>
			                    <td>
			                    	<input class="longinput" type="text"  id="value" name="value" value="<%=StringUtils.defaultIfEmpty(configInfoService.queryValueByName(Global.breaktime_type[2].split("\\|")[0]), "")%>"/>
			                    </td>
			                    <td>
			                    	格式：**-**
			                    </td>
			                </tr>
			            	<tr>
			            		<td><%=Global.breaktime_type[0].split("\\|")[0] %></td>
			                    <td>
			                    	<input class="longinput" type="text"  id="value" name="value" value="<%=StringUtils.defaultIfEmpty(configInfoService.queryValueByName(Global.breaktime_type[0].split("\\|")[0]), "")%>"/>
			                    </td>
			                    <td>
			                    	格式：**-**
			                    </td>
			                </tr>
			            	<tr>
			            		<td><%=Global.breaktime_type[3].split("\\|")[0] %></td>
			                    <td>
			                    	<input class="longinput" type="text"  id="value" name="value" value="<%=StringUtils.defaultIfEmpty(configInfoService.queryValueByName(Global.breaktime_type[3].split("\\|")[0]), "")%>"/>
			                    </td>
			                    <td>
			                    	格式：**-**
			                    </td>
			                </tr>
			                <tr>
			                	<td colspan="3">
       	 							<div class="stdformbutton">
										<button id="configSubmit" class="submit radius2">提交</button>
									</div>			                	
			                	</td>
			                </tr>
			    	</tbody>
        		</table>
        	</form>
        </div>
	</body>
</html>