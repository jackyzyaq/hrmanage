<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<div id="class_info_table" class="widgetcontent padding0 statement">
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
					        		<input type="text" title="编码" name="class_code" id="class_code"  class="mediuminput" value=""/>
					        	</td>
					        	<td style="font-weight:bold" align="center">班次</td>
					        	<td id="auto_class">
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold" align="center">工作时长</td>
					        	<td>
					        		<input type="text" title="工作时长" name="hours" id="hours" class="smallinput" value="8" onblur="replaceForHalf(this);checkTime();" onafterpaste="replaceForHalf(this);"/>&nbsp; 小时
					        	</td>
					        	<td style="font-weight:bold;" align="center">加班时数</td>
					        	<td>
					        		<input type="text" title="加班时数" name="over_hour" id="over_hour" class="smallinput" value="0" onblur="replaceForHalf(this);checkTime();"  onafterpaste="replaceForHalf(this);"/>&nbsp; 小时
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold" align="center">上班时间</td>
					        	<td>
					        		<input class="mediuminput" type="text" readonly="readonly" id="begin_time" name="begin_time" value=""  title="上班时间" onfocus="wTimeInstance();" onblur="checkTime();"/>
					        	</td>
					        	<td style="font-weight:bold" align="center">下班时间</td>
					        	<td>
					        		<input class="mediuminput" type="text" readonly="readonly" id="end_time" name="end_time" value=""  title="下班班时间"/>
					        	</td>
					        </tr>				        
					        <tr>
					        	<td style="font-weight:bold" align="center">用餐时间</td>
					        	<td>
					        		<input type="text" title="用餐时间" name="have_meals" id="have_meals" class="smallinput" value="30" readonly="readonly" onkeyup="replaceForNum(this);" onblur="replaceForNum(this);checkTime();"  onafterpaste="replaceForNum(this);"/>&nbsp; 分钟
					        	</td>
					        	<td style="font-weight:bold" align="center">工作餐</td>
					        	<td>
					        		<input type="checkbox" title="工作餐" name="mealses"  id="meals1" value="<%=Global.meals[0]%>"/><%=Global.meals[0]%>
		                            <input type="checkbox" title="工作餐" name="mealses"  id="meals2" value="<%=Global.meals[1]%>"/><%=Global.meals[1]%>
		                            <input type="checkbox" title="工作餐" name="mealses"  id="meals3" value="<%=Global.meals[2]%>"/><%=Global.meals[2]%>
		                            <input type="checkbox" title="工作餐" name="mealses"  id="meals4" value="<%=Global.meals[3]%>"/><%=Global.meals[3]%>
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold" align="center">有效</td>
					        	<td colspan="3">
						        	<select name="state" id="state" class="uniformselect">
		                            	<option value="1">是</option>
		                                <option value="0">否</option>
	                            	</select>
                            	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">备注</td>
					        	<td colspan="3">
					        		<input type="hidden" name="meals" id="meals" value="无" />
					        		<textarea rows="4" class="longinput" name="remark" id="remark">30分钟用餐时间不计入加班小时</textarea>
					        	</td>
					        </tr>					        
			         		</tbody>
			       		</table>
			     	</div>