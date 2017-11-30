<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	int class_info_id = StringUtils.isEmpty(request.getParameter("class_info_id"))?-1:Integer.parseInt(request.getParameter("class_info_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	ClassInfoService classInfoService = (ClassInfoService) ctx.getBean("classInfoService");
	
	ClassInfo mi = classInfoService.queryById(class_info_id,null);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/class_info/js/class_info.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/common/class_info/js/class_info_ext.js"></script>
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
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<div>
				<div class="widgetbox">
					<div class="widgetcontent padding0 statement">
				   		<table id="class_info_table" cellpadding="0" cellspacing="0" border="0" class="stdtable">
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
					        		<input type="text" title="编码" name="class_code" id="class_code"  class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getClass_code(),"") %>"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">班次</td>
					        	<td>
					        		<input type="text" title="班次" name="class_name" id="class_name"  class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getClass_name(),"") %>"/>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold" align="center">工作时长</td>
					        	<td>
					        		<input type="text" title="工作时长" name="hours" id="hours" class="smallinput" value="<%=mi.getHours() %>" onblur="replaceForHalf(this);checkTime();" onafterpaste="replaceForHalf(this);"/>&nbsp; 小时
					        	</td>
					        	<td style="font-weight:bold;" align="center">加班时数</td>
					        	<td>
					        		<input type="text" title="加班时数" name="over_hour" id="over_hour" class="smallinput" value="<%=mi.getOver_hour() %>" onblur="replaceForHalf(this);checkTime();"  onafterpaste="replaceForHalf(this);"/>&nbsp; 小时
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold" align="center">上班时间</td>
					        	<td>
					        		<input class="mediuminput" type="text" readonly="readonly" id="begin_time" name="begin_time" value="<%=StringUtils.defaultIfEmpty(mi.getBegin_time(),"") %>"  title="上班时间" onfocus="wTimeInstance();" onblur="checkTime();"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">下班时间</td>
					        	<td>
					        		<input class="mediuminput" type="text" readonly="readonly" id="end_time" name="end_time" value="<%=StringUtils.defaultIfEmpty(mi.getEnd_time(),"") %>"  title="下班班时间"/>
					        	</td>
					        </tr>				        
					        <tr>
					        	<td style="font-weight:bold" align="center">用餐时间</td>
					        	<td>
					        		<input type="text" title="用餐时间" name="have_meals" id="have_meals" class="smallinput" value="<%=mi.getHave_meals() %>" onkeyup="replaceForNum(this);" onblur="replaceForNum(this);checkTime();"  onafterpaste="replaceForNum(this);"/>&nbsp; 分钟
					        	</td>
					        	<td style="font-weight:bold" align="center">工作餐</td>
					        	<td>
					        		<input type="checkbox" title="工作餐" name="mealses"  id="meals1" value="<%=Global.meals[0]%>" <%=mi.getMeals().indexOf(Global.meals[0])>-1?"checked":"" %>/><%=Global.meals[0]%>
		                            <input type="checkbox" title="工作餐" name="mealses"  id="meals2" value="<%=Global.meals[1]%>" <%=mi.getMeals().indexOf(Global.meals[1])>-1?"checked":"" %>/><%=Global.meals[1]%>
		                            <input type="checkbox" title="工作餐" name="mealses"  id="meals3" value="<%=Global.meals[2]%>" <%=mi.getMeals().indexOf(Global.meals[2])>-1?"checked":"" %>/><%=Global.meals[2]%>
		                            <input type="checkbox" title="工作餐" name="mealses"  id="meals4" value="<%=Global.meals[3]%>" <%=mi.getMeals().indexOf(Global.meals[3])>-1?"checked":"" %>/><%=Global.meals[3]%>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold" align="center">有效</td>
					        	<td colspan="3">
						        	<select name="state" id="state" class="uniformselect">
		                            	<option value="1" <%=mi.getState().intValue()==1?"checked":"" %>>是</option>
                                		<option value="0" <%=mi.getState().intValue()==0?"checked":"" %>>否</option>
	                            	</select>
                            	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">备注</td>
					        	<td colspan="3">
					        		<textarea rows="4" class="longinput" name="remark" id="remark"><%=StringUtils.defaultIfEmpty(mi.getRemark(),"")%></textarea>
					        	</td>
					        </tr>					        
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
		</form>
	</div>
</body>
</html>