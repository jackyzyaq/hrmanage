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
	SimpleDateFormat sdfB = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	
%>
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
				<td style="font-weight:bold" align="center">问题描述</td>
				<td>
					<%!String problem_discription = "<input type='text' class='longinput' id='problem_discription' name='problem_discription' title='问题描述' value=''/>"; %>
					问题是什么：<br/>&nbsp;&nbsp;&nbsp;<%=problem_discription.replace("problem_discription","problem_discription_1") %><br/>
					为什么是问题：<br/>&nbsp;&nbsp;&nbsp;<%=problem_discription.replace("problem_discription","problem_discription_2") %><br/>
					什么时间发现：<br/>&nbsp;&nbsp;&nbsp;<%=problem_discription.replace("problem_discription","problem_discription_3").replace("value=''","value='"+sdfB.format(cal.getTime())+"' readonly='readonly'  onclick='wdateInstance1()'") %><br/>
					什么时间产生：<br/>&nbsp;&nbsp;&nbsp;<%=problem_discription.replace("problem_discription","problem_discription_4").replace("value=''","value='"+sdfB.format(cal.getTime())+"' readonly='readonly'  onclick='wdateInstance1()'")  %><br/>
					谁发现：<br/>&nbsp;&nbsp;&nbsp;<%=problem_discription.replace("problem_discription","problem_discription_5") %><br/>
					谁制造：<br/>&nbsp;&nbsp;&nbsp;<%=problem_discription.replace("problem_discription","problem_discription_6") %><br/>
					哪里发现：<br/>&nbsp;&nbsp;&nbsp;<%=problem_discription.replace("problem_discription","problem_discription_7") %><br/>
					哪里产生：<br/>&nbsp;&nbsp;&nbsp;<%=problem_discription.replace("problem_discription","problem_discription_8") %><br/>
					怎样发现：<br/>&nbsp;&nbsp;&nbsp;<%=problem_discription.replace("problem_discription","problem_discription_9") %><br/>
					多少：<br/>&nbsp;&nbsp;&nbsp;<%=problem_discription.replace("problem_discription","problem_discription_10") %><br/>
				</td>
				<td style="font-weight:bold" align="center">标准检查</td>
				<td>
					<%!String standards_check = "<select id='standards_check' name='standards_check' title='标准检查'><option value='是' selected>是</option><option value='否'>否</option><option value='NA'>NA</option></select>"; %>
					1.是否按WI操作<br/>&nbsp;&nbsp;&nbsp;<%=standards_check.replace("standards_check","standards_check_1") %><br/>
					2.首件是否符合<br/>&nbsp;&nbsp;&nbsp;<%=standards_check.replace("standards_check","standards_check_2") %><br/>
					3.PY是否符合<br/>&nbsp;&nbsp;&nbsp;<%=standards_check.replace("standards_check","standards_check_3") %><br/>
					4.CP是否符合<br/>&nbsp;&nbsp;&nbsp;<%=standards_check.replace("standards_check","standards_check_4") %><br/>
					5.多岗位是否符合<br/>&nbsp;&nbsp;&nbsp;<%=standards_check.replace("standards_check","standards_check_5") %><br/>
					6.是否有变化点<br/>&nbsp;&nbsp;&nbsp;<%=standards_check.replace("standards_check","standards_check_6") %><br/>
					7.5S是否符合<br/>&nbsp;&nbsp;&nbsp;<%=standards_check.replace("standards_check","standards_check_7") %><br/>
					8.维修保养是否符合<br/>&nbsp;&nbsp;&nbsp;<%=standards_check.replace("standards_check","standards_check_8") %><br/>
					9.其它<br/>&nbsp;&nbsp;&nbsp;<%=standards_check.replace("standards_check","standards_check_9") %>
				</td>
				<td style="font-weight:bold" align="center">是否更新了文件/是否培训员工</td>
				<td>
					<%!String updates = "<select id='updates' name='updates' title='是否更新了文件、否培训员工'><option value='是' selected>是</option><option value='否'>否</option><option value='NA'>NA</option></select>"; %>
					A）PFMEA更新<br/>&nbsp;&nbsp;&nbsp;<%=updates.replace("updates","updates_1") %><br/>
					B）CP更新<br/>&nbsp;&nbsp;&nbsp;<%=updates.replace("updates","updates_2") %><br/>
					C）首件表更新<br/>&nbsp;&nbsp;&nbsp;<%=updates.replace("updates","updates_3") %><br/>
					D）WI更新<br/>&nbsp;&nbsp;&nbsp;<%=updates.replace("updates","updates_4") %><br/>
					E）5S指导书更新<br/>&nbsp;&nbsp;&nbsp;<%=updates.replace("updates","updates_5") %><br/>
					F）一级维护操作指导书更新<br/>&nbsp;&nbsp;&nbsp;<%=updates.replace("updates","updates_6") %><br/>
					G）二级维护操作指导书更新<br/>&nbsp;&nbsp;&nbsp;<%=updates.replace("updates","updates_7") %><br/>
					H）防错指导书更新<br/>&nbsp;&nbsp;&nbsp;<%=updates.replace("updates","updates_8") %><br/>
					I）培训记录<br/>&nbsp;&nbsp;&nbsp;<%=updates.replace("updates","updates_9") %><br/>
					J）其它更新<br/>&nbsp;&nbsp;&nbsp;<%=updates.replace("updates","updates_10") %>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">原因分析</td>
				<td>
					<input class="longinput" type="text" id="cause_analysis" title="原因分析" name="cause_analysis" value=""/>
				</td>
				<td style="font-weight:bold" align="center">备注</td>
				<td>
					<input class="longinput" type="text" id="remark" title="备注" name="remark" value=""/>
				</td>
				<td style="font-weight:bold" align="center">
					是否关闭
				</td>
				<td>
					<select id='is_close' name='is_close' title='是否关闭'>
						<option value='YES' selected>YES</option>
						<option value='NO'>NO</option>
					</select>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">
					是否重复发生
				</td>
				<td>
					<select id='is_re_happend' name='is_re_happend' title='是否重复发生'>
						<option value='YES' selected>YES</option>
						<option value='NO'>NO</option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">
					是否上升
				</td>
				<td>
					<select id='is_up' name='is_up' title='是否上升'>
						<option value='YES' selected>YES</option>
						<option value='NO'>NO</option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">上升的UAP QRCI编号</td>
				<td>
					<input class="longinput" type="text" id="up_number" title="上升的UAP QRCI编号" name="up_number" value="NA"/>
				</td>
			</tr>			
        </tbody>
    </table>
</div><!--widgetcontent-->
