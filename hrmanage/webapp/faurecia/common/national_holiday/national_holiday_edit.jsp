<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	int national_holiday_id = StringUtils.isEmpty(request.getParameter("national_holiday_id"))?-1:Integer.parseInt(request.getParameter("national_holiday_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	NationalHolidayService nationalHolidayService = (NationalHolidayService) ctx.getBean("nationalHolidayService");
	
	NationalHoliday mi = nationalHolidayService.queryById(national_holiday_id,null);
	String month = mi.getHolidays().split(",")[0].split("-")[1];
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/national_holiday/js/national_holiday.js"></script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
                    <form class="yqstdform" onSubmit="return false;">
                    	<div>
                        	<label>名称</label>
                            <span class="field">
                            <select name="holiday_name" id="holiday_name" class="uniformselect">
                            	<option value="">---请选择---</option>
                            	<%for(String s:Global.holidays_name){ %>
                            	<option value="<%=s%>" <%=mi.getHoliday_name().equals(s)?"selected":"" %>><%=s%></option>
                            	<%} %>
                            </select>
                            </span>
                        </div>
                        <div>
                        	<label>日期</label>
                            <span class="field">
                           	<jsp:include page="/share/jsp/date.jsp">
                           		<jsp:param value="<%=month %>" name="month"/>
                           		<jsp:param value="<%=mi.getHolidays() %>" name="holidays"/>
                           	</jsp:include>
                            </span>
                        </div>
                        <div>
                        	<label>有效</label>
                            <span class="field">
                            <select name="state" id="state" class="uniformselect">
                            	<option value="1" <%=mi.getState().intValue()==1?"selected":"" %>>是</option>
                                <option value="0" <%=mi.getState().intValue()==0?"selected":"" %>>否</option>
                            </select>
                            </span>
                        </div>
                        <br clear="all" />
                        <div class="stdformbutton">
                        	<button id="editSubmit" class="submit radius2">提交</button>
                            <input type="reset" class="reset radius2" value="Reset" />
                            <input type="hidden" name="id" value="<%=mi.getId()%>"/>
                            <input type="hidden" value="" id="holidays" name="holidays"/>
                        </div>
                    </form>
        	</div>
</body>
</html>