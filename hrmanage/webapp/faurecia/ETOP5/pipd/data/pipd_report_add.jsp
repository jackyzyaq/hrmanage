<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String type = StringUtils.defaultIfEmpty(request.getParameter("type"), "");
	String sub_type = StringUtils.defaultIfEmpty(request.getParameter("sub_type"), "");
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"), "");
	String end_month = StringUtils.defaultIfEmpty(request.getParameter("end_month"), "");
	String img_id = StringUtils.defaultIfEmpty(request.getParameter("img_id"), "");
	String pipd_down_id = StringUtils.defaultIfEmpty(request.getParameter("pipd_down_id"), "");
	Calendar cal = Calendar.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script>
	$(function(){
		$("#obj1 #file").attr("accept","<%=Global.UPLOAD_ACCEPT_3%>");
		$("#obj2 #file").attr("accept","<%=Global.UPLOAD_ACCEPT_1%>");
		$("#pipdReportSubmit").click(function(){
			if(validateForm("pipd_report_form")){
					if (confirm('是否提交？')) {
						var param = getParamsJson("pipd_report_form");
						param['begin_month'] = param['begin_month']+"-01 00:00:00";
						param['end_month'] = param['end_month']+"-01 00:00:00";
						ajaxUrl(ctx+'/common/pipdReport/pipdReportAdd.do',param,function(json){
							if(json.flag=='1'){
							}else{
								showMsgInfo(json.msg+'');
								parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
								pipd_report_view_inner();
							}
						});
					}
			}
		});
		pipd_report_view_inner();
	});
	function pipd_report_view_inner(){
		var params = {};
		params['type']='<%=type %>';
		params['sub_type']='<%=sub_type %>';
		inner_html(ctx+'/faurecia/ETOP5/pipd/data/pipd_report_view.jsp',params,'pipd_report_view',null);
	}
	function editFile(upload_uuid){
	}	
</script>	
</head>
<body>
	<div id="contentwrapper" class="contentwrapper widgetpage">
		<div class="widgetbox">
			<form id="pipd_report_form" class="stdform" onSubmit="return false;">
				<div class="title">
					<h4><%=type+"&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+sub_type %></h4>
				</div>
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <thead>
			                <tr>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                    <th class="head1"></th>
			                </tr>
			            </thead>
			            <tbody>
			            	<tr>
			                    <td>数据类型</td>
			                    <td>
			                    	<input class="longinput" title="数据类型" type="text" readonly="readonly" id="type" name="type" value="<%=type %>" />
			                    </td>
			                    <td>类型2</td>
			                    <td>
			                    	<input class="longinput" title="类型2" type="text" readonly="readonly" id="sub_type" name="sub_type" value="<%=sub_type %>" />
			                    </td>
			                    <td>开始月份</td>
			                    <td>
			                    	<input class="longinput" title="开始月份" type="text" readonly="readonly" id="begin_month" name="begin_month" value="<%=begin_month %>"  onclick="wdateYearMonthInstance('begin_month');"/>
			                    </td>
			                    <td>结束月份</td>
			                    <td>
			                    	<input class="longinput" title="结束月份" type="text" readonly="readonly" id="end_month" name="end_month" value="<%=end_month %>"  onclick="wdateYearMonthInstance('end_month');"/>
			                    </td>
			                </tr>
							<tr>
			                    <td align="left" colspan="8">
							       	<jsp:include page="/share/jsp/upload_file.jsp"></jsp:include>
								</td>
			                </tr>
			                <tr>
			                    <td align="left" colspan="8">
			        				<div id="obj2" class="upload_file">
										<input type="file" id="file" name="file" onchange="fileUpload('obj2','upload_uuid_pic');" value="sss" accept=".gif,.GIF,.jpg,.JPG,.png,.PNG"/>
										<input type="button" id="txt_id" value="上传图片" />
										<div style="text-align: left;">
										<input type="hidden" id="upload_uuid_pic" name="upload_uuid_pic" value="upload_uuid_pic"  title="上传文件"/>
										</div>
										<div id="msg"></div>
									</div>
								</td>
			                </tr>			                
			                <tr>
			                	<td colspan="8">
				                	<div class="stdformbutton">
									<button id="pipdReportSubmit" class="submit radius2">提交</button>
									</div>
			                	</td>
			                </tr>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->
			</form>
		</div>
		<!--widgetbox-->
		<div id="pipd_report_view"></div>
	</div>
</body>
</html>