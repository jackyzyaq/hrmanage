<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	int annual_leave_id = StringUtils.isEmpty(request.getParameter("annual_leave_id"))?-1:Integer.parseInt(request.getParameter("annual_leave_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	AnnualLeaveService annualLeaveService = (AnnualLeaveService) ctx.getBean("annualLeaveService");
	
	AnnualLeave mi = annualLeaveService.queryById(annual_leave_id,null);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/annual_leave/js/annual_leave.js"></script>
<script type="text/javascript">
$(function(){
	var param = {};
	param['root_div_id'] = 'contentwrapper';
	param['id'] = '<%=mi.getId()%>';
	param['pojo_object'] = '<%=mi.getClass().getName()%>';
	createRigthMenu(param);
});
</script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<form class="stdform stdform2" onSubmit="return false;">
			<div>
				<div class="widgetbox">
					<div class="widgetcontent padding0 statement">
				   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
					        <thead>
					            <tr>
					                <th class="head1"></th>
					                <th class="head1"></th>
					                <th class="head1"></th>
					                <th class="head1"></th>
					            </tr>
					        </thead>
					        <tbody>
					        <tr>
					        	<td style="font-weight:bold;" align="center">编码</td>
					        	<td>
					        		<input type="text" name="status_code" id="status_code"  class="smallinput" value="<%=StringUtils.defaultIfEmpty(mi.getStatus_code(), "")%>"/>
					        	</td>
					        	<td style="font-weight:bold" align="center"></td>
					        	<td>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold" align="center">社会工龄&nbsp;&gt;=&nbsp;</td>
					        	<td>
					        		<input type="text" name="work_down" id="work_down" class="smallinput" value="<%=mi.getWork_down()==null?0:mi.getWork_down()%>" onkeyup="replaceForNum(this);" onafterpaste="replaceForNum(this);"/>&nbsp;年
					        	</td>
					        	<td style="font-weight:bold;" align="center">社会工龄&nbsp;&lt;&nbsp;</td>
					        	<td>
					        		<input type="text" name="work_up" id="work_up" class="smallinput" value="<%=mi.getWork_up()==null?0:mi.getWork_up()%>" onkeyup="replaceForNum(this);" onafterpaste="replaceForNum(this);"/>&nbsp;年
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">法定年假</td>
					        	<td>
					        		<input type="text" name="leave01" id="leave01" class="smallinput" value="<%=mi.getLeave01()==null?0:mi.getLeave01() %>" onkeyup="replaceForNum(this);" onafterpaste="replaceForNum(this);"/>&nbsp;天
					        	</td>
					        	<td style="font-weight:bold;" align="center">公司年假</td>
					        	<td>
					        		<input type="text" name="leave02" id="leave02" class="smallinput" value="<%=mi.getLeave02()==null?0:mi.getLeave02() %>" onkeyup="replaceForNum(this);" onafterpaste="replaceForNum(this);"/>&nbsp;天
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">有效</td>
					        	<td>
					        		<select name="state" id="state" class="uniformselect">
		                            	<option value="1" <%=mi.getState().intValue()==1?"selected":"" %>>是</option>
                               	 		<option value="0" <%=mi.getState().intValue()==0?"selected":"" %>>否</option>
		                            </select>
					        	</td>
					        	<td style="font-weight:bold;" align="center"></td>
					        	<td>
					        	</td>
					        </tr>					        
					        <tr>
					        	<td style="font-weight:bold;" align="center">描述</td>
					        	<td colspan=3>
					        		<textarea rows="4" class="mediuminput" name="remark" id="remark"><%=StringUtils.defaultIfEmpty(mi.getRemark(), "")%></textarea>
					        	</td>
					        </tr>
					         					        
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
            <div>
            <input type="hidden" name="id" value="<%=mi.getId()%>"/>
			</div>
		</form>		
	</div>
</body>
</html>