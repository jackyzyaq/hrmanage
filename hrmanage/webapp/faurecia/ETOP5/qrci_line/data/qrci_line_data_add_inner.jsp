<%@page import="com.yq.faurecia.service.DepartmentInfoService"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
%>
<script type="text/javascript">
	$(function(){
		qrci_lineIn(0);
		$("#qrci_line_info_form #qrci_lineInfoSubmit").click(function(){
			if(validateForm("qrci_line_info_form")){
				if (confirm('是否提交？')) {
					var param = getParamsJson("qrci_line_info_form");
					param['opening_date']=param['opening_date']+' 00:00:00';
					ajaxUrl(ctx+'/common/qrci_line/qrciLineDataAdd.do',param,function(json){
						showMsgInfo(json.msg+'');
						parent.document.getElementById('iframe_menu_<%=menu_id%>').contentWindow.location.reload(true);
						if(json.flag==1){
							qrci_lineIn(json.id);
						}
					});
				}
			}
		});
	});
</script>
<form id="qrci_line_info_form" class="stdform" onSubmit="return false;">
<div class="widgetcontent padding0 statement">
   <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
        <thead>
            <tr>
                <th class="head1" style="width: 10%"></th>
                <th class="head1" style="width: 25%"></th>
                <th class="head1" style="width: 10%"></th>
                <th class="head1" style="width: 25%"></th>
                <th class="head1" style="width: 10%"></th>
                <th class="head1" style="width: 20%"></th>
            </tr>
        </thead>
        <tbody>
			<tr>
				<td style="font-weight:bold" align="center">GAP</td>
				<td>
					<jsp:include page="/share/jsp/dept_role_ztree.jsp">
						<jsp:param value="true" name="noRequireParentNode"/>
					</jsp:include>
				</td>
				<td style="font-weight:bold" align="center">
					LINE QRCI NO.
				</td>
				<td>
					<select id="number1" name="number1" title="LINE QRCI NO." style="width:120px;">
						<option value="" selected>---请选择---</option>
						<%for(String s:Global.stationNumberSet){ %>
						<option value="<%=s%>"><%=s%></option>
						<%} %>
					</select>	
				</td>
				<td style="font-weight:bold" align="center">召开日期</td>
				<td>
					<input class="longinput" type="text" id="opening_date" title="召开日期" name="opening_date" value="<%=sdfA.format(cal.getTime()) %>" readonly="readonly"  onclick="wdateInstance2()"/>
				</td>
			</tr>
        </tbody>
    </table>
</div><!--widgetcontent-->
<div id="qrci_line_edit"></div>
<div class="stdformbutton" style="padding: 5px">
	<input type="hidden" id="id" name="id" value="0">
	<input type="hidden" id="number2" name="number2" value="">
	<button id="qrci_lineInfoSubmit" class="submit radius2">Submit</button>
</div>
</form>
<form id="qrci_line_edit_ext" class="stdform" onSubmit="return false;"></form>