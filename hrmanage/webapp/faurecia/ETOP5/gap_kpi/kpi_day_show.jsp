<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	GapKPIService gapKPIService = (GapKPIService) ctx.getBean("gapKPIService");
	String 	ext_1 = StringUtils.defaultIfEmpty(request.getParameter("ext_1"), ""),
			ext_2 = StringUtils.defaultIfEmpty(request.getParameter("ext_2"), ""),
			dept_name = StringUtils.defaultIfEmpty(request.getParameter("dept_name"), ""),
			kpi_type = StringUtils.defaultIfEmpty(request.getParameter("kpi_type"), ""),
			kpi_date = StringUtils.defaultIfEmpty(request.getParameter("kpi_date"), "");
	
	
	GapKPI pk = gapKPIService.queryByType(sdf.parse(kpi_date), kpi_type, dept_name, ext_1, ext_2);
	if(pk==null){
		pk = new GapKPI();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
</head>
<body>
<div>
<form id="gap_kpi_actual_form" class="stdform" onSubmit="return false;">
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
				<td style="font-weight:bold" align="center">Date</td>
				<td>
					<input class="mediuminput" disabled="disabled" type="text" id="kpi_date" title="Date" name="kpi_date" value="<%=pk.getKpi_date()==null?"-":sdf.format(pk.getKpi_date())%>"/>
				</td>
				<td style="font-weight:bold" align="center">Department</td>
				<td>
					<select id="dept_name" name="dept_name" disabled="disabled">
						<option value="" selected="selected"><%=StringUtils.defaultIfEmpty(pk.getDept_name(), "-")%></option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">KPI</td>
				<td>
					<select id="kpi_type" name="kpi_type" style="width:150px;" disabled="disabled">
						<option value="" selected="selected"><%=StringUtils.defaultIfEmpty(pk.getKpi_type(), "-")%></option>
					</select>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">INPUT/OUTPUT</td>
				<td>
					<select id="ext_1" name="ext_1" title="INPUT、OUTPUT" disabled="disabled" >
						<option value="" selected><%=StringUtils.defaultIfEmpty(pk.getExt_1(), "-")%></option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">Correct/Opposite</td>
				<td>
					<select id="ext_3" name="ext_3" title="Correct、Opposite"  disabled="disabled" >
						<option value="" selected><%=StringUtils.defaultIfEmpty(pk.getExt_3(), "-")%></option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">QCDPN</td>
				<td>
					<select id="ext_2" name="ext_2" title="QCDP" disabled="disabled" >
						<option value="" selected><%=StringUtils.defaultIfEmpty(pk.getExt_2(), "-")%></option>
					</select>
				</td>
			</tr>			
			<tr>
				<td style="font-weight:bold" align="center">Target</td>
				<td>
					<input type="text" name="target" id="target" disabled="disabled"  class="mediuminput" title="Target" value="<%=pk.getTarget()==null?"-":pk.getTarget().toString()%>"/>
				</td>
				<td style="font-weight:bold" align="center">Actual-Daily</td>
				<td>
					<input type="text" name="actual" id="actual"  class="mediuminput" title="Actual-Daily" value="<%=pk.getActual()==null?"-":pk.getActual().toString()%>" disabled="disabled"/>
				</td>
				<td style="font-weight:bold" align="center">Actual-Cumulate</td>
				<td>
					<input type="text" name="cum" id="cum"  class="smallinput" title="Actual-Cumulate" value="<%=pk.getCum()==null?"-":pk.getCum().toString()%>"  disabled="disabled"/>
				</td>				
			</tr>
			<tr>
            	<td style="font-weight:bold" align="center">Resp</td>
				<td>
					<input class="mediuminput" type="text" id="ext_6" title="Resp" name="ext_6" value="<%=StringUtils.defaultIfEmpty(pk.getExt_6(), "-")%>"  disabled="disabled"/>
				</td>
				<td style="font-weight:bold" align="center">Deadline</td>
				<td>
					<input class="mediuminput" type="text"  disabled="disabled" id="ext_7" title="Deadline" name="ext_7" value="<%=StringUtils.defaultIfEmpty(pk.getExt_7(), "-")%>"/>
				</td>
				<td style="font-weight:bold" align="center">StationNO.</td>
				<td>
				<%String number = StringUtils.defaultIfEmpty(pk.getSubtitle(), ""); %>
				<jsp:include page="/share/jsp/jump_menu229.jsp" >
					<jsp:param value="<%=number %>" name="number"/>
				</jsp:include>
				</td>
            </tr>
            <tr>
            	<td style="font-weight:bold" align="center">Issue Description</td>
				<td>
					<textarea rows="6" class="mediuminput" name="ext_4" id="ext_4" title="Issue Description" disabled="disabled"><%=StringUtils.defaultIfEmpty(pk.getExt_4(), "-")%></textarea>
				</td>
				<td style="font-weight:bold" align="center">Action Plan</td>
				<td>
					<textarea rows="6" class="mediuminput" name="ext_5" id="ext_5" title="Action Plan" disabled="disabled"><%=StringUtils.defaultIfEmpty(pk.getExt_5(), "-")%></textarea>
				</td>
				<td></td>
				<td></td>
            </tr>
            <tr>
            	<td style="font-weight:bold" align="center">分类原因</td>
				<td colspan="3">
					<textarea rows="6" class="mediuminput" name="ext_10" id="ext_10" title="分类原因" disabled="disabled"><%=StringUtils.defaultIfEmpty(pk.getExt_10(), "-")%></textarea>
				</td>
				<td></td>
				<td></td>
            </tr>             
        </tbody>
    </table>
</div><!--widgetcontent-->
</form>
</div>
</body>
</html>