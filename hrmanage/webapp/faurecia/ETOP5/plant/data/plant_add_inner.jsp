<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	String begin_year = StringUtils.defaultIfEmpty(request.getParameter("begin_year"), "");
	String type = StringUtils.defaultIfEmpty(request.getParameter("type"), "");
	String level = StringUtils.defaultIfEmpty(request.getParameter("level"), "");
	SimpleDateFormat sdfD = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script>
	$(function(){
		$('#level1').val('<%=level%>');
		$("#begin_year").val("<%=(StringUtils.defaultIfEmpty((begin_year.length()==4?sdfD.format(cal.getTime()):begin_year),sdfD.format(cal.getTime()))) %>");
		<%if(!StringUtils.isEmpty(type)){%>
		$("#type").val("<%=type%>");
		<%}%>
		$("#begin_year").click(function(){
			wdateYearMonthInstance('begin_year',function(){
			});
		});		
		$("#datepoint").click(function(){
			wdateInstance2(function(){
			});
		});	
		$("#plantAddSubmit").click(function(){
			if($("#upload_uuid").val()==""){
				$("#upload_uuid").val("0");
			}
			if(validateForm("plant_form")){
				if($("#upload_uuid").val()=="0"){
					$("#upload_uuid").val("");
				}
				if (confirm('是否提交？')) {
					var param = getParamsJson("plant_form");
					param['begin_year'] = param['begin_year']+"-01 00:00:00";
					param['datepoint'] = param['datepoint']+" 00:00:00";
					ajaxUrl(ctx+'/common/plant/plantAdd.do',param,function(json){
						if(json.flag=='1'){
						}else{
							showMsgInfo(json.msg+'');
							parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
						}
					});
				}
			}
		});
	});
</script>
</head>
<body>
	<div id="contentwrapper">
		<div class="widgetbox">
			<form id="plant_form" class="stdform" onSubmit="return false;">
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <thead>
			                <tr>
			                    <th class="head1" style="width:5%"></th>
			                    <th class="head1" style="width:20%"></th>
			                    <th class="head1" style="width:5%"></th>
			                    <th class="head1" style="width:20%"></th>
			                    <th class="head1" style="width:10%"></th>
			                    <th class="head1" style="width:20%"></th>
			                    <th class="head1" style="width:10%"></th>
			                    <th class="head1" style="width:10%"></th>
			                </tr>
			            </thead>
			            <tbody>
			            	<tr>
			                    <td>月份</td>
			                    <td>
			                    	<input class="longinput" title="月份" type="text" readonly="readonly" id="begin_year" name="begin_year" value=""/>
			                    </td>
			                    <td>Level</td>
			                    <td>
			                    	<select id="level1" name="level1">
			                    		<option value="<%=Global.level[0] %>" selected><%=Global.level[0] %></option>
			                    		<option value="<%=Global.level[1] %>" ><%=Global.level[1] %></option>
			                    		<option value="<%=Global.level[2] %>" ><%=Global.level[2] %></option>
			                    	</select>
			                    </td>
			                    <td>类型</td>
			                    <td>
			                    	<select id="type" name="type">
			                    		<option value="<%=Global.plant_type[0] %>" selected><%=Global.plant_type[0] %></option>
			                    	</select>
			                    </td>
			                    <td>状态</td>
			                    <td>
			                    	<select id="state" name="state">
			                    		<option value="1" selected>有效</option>
			                    		<option value="0">无效</option>
			                    	</select>
			                    </td>
			                </tr>
							<tr>
			                    <td>责任人</td>
			                    <td>
			                    	<input class="longinput" title="责任人" type="text" id="handler" name="handler" value=""/>
			                    </td>
			                    <td>时间节点</td>
			                    <td>
			                    	<input class="longinput" title="时间节点" type="text" readonly="readonly" id="datepoint" name="datepoint" value=""/>
			                    </td>
			                    <td></td>
			                    <td>
<!-- 			                    	<select id="ext_1" name="ext_1"> -->
<!-- 			                    		<option value="高" selected>高</option> -->
<!-- 			                    		<option value="中" >中</option> -->
<!-- 			                    		<option value="低" >低</option> -->
<!-- 			                    	</select> -->
			                    	<input type="hidden" id="ext_1" name="ext_1" value="低"/>
			                    </td>
			                    <td></td>
			                    <td>
			                    </td>
			                </tr>
							<tr>
			                    <td>PLANT</td>
			                    <td colspan="7">
			                    	<textarea rows="4" style="margin: 2px;" class="longinput" title="Plant内容" id="plant" name="plant"></textarea>
			                    </td>
			                </tr>
			                <tr>
								<td style="font-weight:bold" colspan="8">
			        				<div>
				                    	<jsp:include page="/share/jsp/upload_file_more.jsp">
				                    		<jsp:param value="upload_uuid" name="input_name"/>
				                    	</jsp:include>
							        </div>
								</td>
							</tr>
			                <tr>
			                	<td colspan="8">
				                	<div class="stdformbutton">
				                	<input type="hidden" id="id" name="id" value="0"/>
									<button id="plantAddSubmit" class="submit radius2">提交</button>
									</div>
			                	</td>
			                </tr>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->
			</form>
		</div>
		<!--widgetbox-->
	</div>
</body>
</html>
