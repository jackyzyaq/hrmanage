<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	String qrci_type = StringUtils.defaultIfEmpty(request.getParameter("qrci_type"), "");
	
	//ServletContext st = this.getServletConfig().getServletContext();
	//ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	//QRCIDataService qrciDataService = (QRCIDataService) ctx.getBean("qrciDataService");
	//QRCIData qrciData = qrciDataService.queryByQrciType(qrci_type);
	Calendar cal = Calendar.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script>
	$(function(){
		var _url = ctx+'/common/qrci/queryResult.do';
		var param = {};
		param['pageIndex']=1;
		param['pageSize']=1000;
		param['qrci_type']='<%=qrci_type%>';
		valueIn(_url,param,'qrci_data_form',function(json){
			$.each(json.rows, function (n, value) {
		        	$.each(value,function(name,value) {
						$("#qrci_data_form #"+name).val(value.replaceAll('\\\|',"\n"));
					});
		        });
		});
		$("#qrciDataSubmit").click(function(){
			//if(validateForm("qrci_data_form")){
					if (confirm('是否提交？')) {
						ajaxUrl(ctx+'/common/qrci/qrciDataEdit.do',validData({}),function(json){
							if(json.flag=='1'){
							}else{
								showMsgInfo(json.msg+'');
								parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
								qrci_data_view_inner();
							}
						});
					}
			//}
		});
		qrci_data_view_inner();
	});
	function qrci_data_view_inner(){
		var params = {};
		inner_html(ctx+'/faurecia/ETOP5/qrci/data/qrci_data_view.jsp',params,'qrci_data_view',null);
	}
	function validData(param){
		var valForm = $("#qrci_data_form table tbody").find("*");
		$.each(valForm,function(i,v){
			if(typeof(param[$(this).attr("name")])==='undefined'){
				param[$(this).attr("name")]=$(this).val().Trim().replaceAll('\r',"\|").replaceAll('\n',"\|");
			}else{
				param[$(this).attr("name")]=param[$(this).attr("name")]+$(this).val().Trim().replaceAll('\r',"\|").replaceAll('\n',"\|");
			}
		});
		return param;
	}
	function editFile(upload_uuid){
	}
	function changeTask(){
		$("#yesterday_task_to_be_checked").val($("#task_for_next_day_future").val());
		$("#task_for_next_day_future").val("");
	}
</script>	
</head>
<body>
	<div id="contentwrapper" class="contentwrapper widgetpage">
		<div class="widgetbox">
			<form id="qrci_data_form" class="stdform" onSubmit="return false;">
				<div class="title">
					<h4>QRCI Data&nbsp;</h4>
				</div>
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <thead>
			                <tr>
			                    <th class="head1" style="width:5%"></th>
			                    <th class="head1" style="width:15%"></th>
			                    <th class="head1" style="width:5%"></th>
			                    <th class="head1" style="width:15%"></th>
			                    <th class="head1" style="width:5%"></th>
			                    <th class="head1" style="width:15%"></th>
			                    <th class="head1" style="width:5%"></th>
			                    <th class="head1" style="width:15%"></th>
			                    <th class="head1" style="width:5%"></th>
			                    <th class="head1" style="width:15%"></th>
			                </tr>
			            </thead>
			            <tbody>
			            	<tr>
			            		<td><%=Global.qrci_head[0] %></td>
			                    <td colspan="3">
			                    	<input class="longinput" title="<%=Global.qrci_head[0] %>" type="text" readonly="readonly"  id="<%=Global.qrci_head[0].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[0].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" value="<%=qrci_type %>" />
			                    </td>
			                    <td><%=Global.qrci_head[1] %></td>
			                    <td>
			                    	<input class="longinput" title="<%=Global.qrci_head[1] %>" readonly="readonly" type="text"  onfocus="wdateInstance2();"  id="<%=Global.qrci_head[1].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[1].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" value="" />
			                    </td>
			                    <td><%=Global.qrci_head[2] %></td>
			                    <td>
			                    	<textarea rows="4" cols="4" class="longinput" title="<%=Global.qrci_head[2] %>" id="<%=Global.qrci_head[2].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[2].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>"></textarea>
			                    </td>
			                    <td><%=Global.qrci_head[3] %></td>
			                    <td>
			                    	<textarea rows="4" cols="4" class="longinput" title="<%=Global.qrci_head[3] %>" id="<%=Global.qrci_head[3].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[3].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" ></textarea>
			                    </td>
			                </tr>
			                <tr>
			            		<td><%=Global.qrci_head[4] %></td>
			                    <td>
			                    	<textarea rows="4" cols="4" style="margin: 2px;" class="longinput" title="<%=Global.qrci_head[4] %>" disabled="disabled" id="<%=Global.qrci_head[4].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[4].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>"></textarea>
			                    </td>
			                    <td><%=Global.qrci_head[5] %>
<!-- 			                    <br/><a style="cursor:pointer" onclick="changeTask();">【移动】</a> -->
			                    </td>
			                    <td>
			                    	<textarea rows="4" cols="4"  style="margin: 2px;" class="longinput" title="<%=Global.qrci_head[5] %>" id="<%=Global.qrci_head[5].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[5].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>"></textarea>
			                    </td>
			                    <td><%=Global.qrci_head[6] %></td>
			                    <td>
			                    	<textarea rows="4" cols="4" style="margin: 2px;" class="longinput" title="<%=Global.qrci_head[6] %>" id="<%=Global.qrci_head[6].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[6].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>"></textarea>
			                    </td>
			                    <td><%=Global.qrci_head[7] %></td>
			                    <td>
			                    	<textarea rows="4" cols="4" style="margin: 2px;" class="longinput" title="<%=Global.qrci_head[7] %>" id="<%=Global.qrci_head[7].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[7].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>"></textarea>
			                    </td>
			                    <td><%=Global.qrci_head[8] %></td>
			                    <td>
			                    	<textarea rows="4" cols="4" style="margin: 2px;" class="longinput" title="<%=Global.qrci_head[8] %>" id="<%=Global.qrci_head[8].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[8].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>"></textarea>
			                    </td>
			                </tr>
			                <tr>
			            		<td><%=Global.qrci_head[9] %></td>
			                    <td>
			                    	<input class="longinput" title="<%=Global.qrci_head[9] %>" type="text"  id="<%=Global.qrci_head[9].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[9].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" value="" />
			                    </td>
			                    <td><%=Global.qrci_head[10] %></td>
			                    <td>
			                    	<input class="longinput" title="<%=Global.qrci_head[10] %>" type="text"  id="<%=Global.qrci_head[10].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[10].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" value="" />
			                    </td>
			                    <td><%=Global.qrci_head[11] %></td>
			                    <td>
			                    	<input class="longinput" title="<%=Global.qrci_head[11] %>" type="text"  id="<%=Global.qrci_head[11].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[11].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" value="" />
			                    </td>
			                    <td><%=Global.qrci_head[12] %></td>
			                    <td>
			                    	<input class="longinput" title="<%=Global.qrci_head[12] %>" type="text"  id="<%=Global.qrci_head[12].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=Global.qrci_head[12].replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" value="" />
			                    </td>
			                    <td>状态</td>
			                    <td>
			                    	<select id="state" name="state">
			                    		<option value="0">无效</option>
			                    		<option value="1">有效</option>
			                    		<option value="2">关闭</option>
			                    	</select>
			                    </td>
			                </tr>
							<tr>
			            		<td><%=Global.qrci_head[13] %></td>
			                    <td colspan="2">
			                    	<input class="longinput" title="<%=Global.qrci_head[13] %>" type="text"  id="<%=(Global.qrci_head[13]+"_pic").replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=(Global.qrci_head[13]+"_pic").replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" value="" />
			                    </td>
			                    <td><%=Global.qrci_head[14] %></td>
			                    <td colspan="2">
			                    	<input class="longinput" title="<%=Global.qrci_head[14] %>" type="text"  id="<%=(Global.qrci_head[14]+"_pic").replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=(Global.qrci_head[14]+"_pic").replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" value="" />
			                    </td>
			                    <td><%=Global.qrci_head[15] %></td>
			                    <td colspan="2">
			                    	<input class="longinput" title="<%=Global.qrci_head[15] %>" type="text"  id="<%=(Global.qrci_head[15]+"_pic").replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" name="<%=(Global.qrci_head[15]+"_pic").replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase() %>" value="" />
			                    </td>
			                    <td></td>
			                </tr>			                
			                <tr>
			                    <td colspan="10">
			                    	<%String upload_input_name =  (Global.qrci_head[13]+"|"+Global.qrci_head[14]+"|"+Global.qrci_head[15]).replace("<br/>", "_").replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("/", "_").toLowerCase();%>
			                    	<jsp:include page="/share/jsp/upload_file_more.jsp">
			                    		<jsp:param value="<%=upload_input_name %>" name="input_name"/>
			                    	</jsp:include>
			                    </td>
			                </tr>
			                <tr>
			                	<td colspan="10">
				                	<div class="stdformbutton">
				                	<input type="hidden" id="id" name="id" value="0"/>
									<button id="qrciDataSubmit" class="submit radius2">提交</button>
									</div>
			                	</td>
			                </tr>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->
			</form>
		</div>
		<!--widgetbox-->
		<div id="qrci_data_view" style="overflow:auto;overflow-x:true;"></div>
	</div>
</body>
</html>
