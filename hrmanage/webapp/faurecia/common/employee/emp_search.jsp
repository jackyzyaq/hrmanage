<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PositionInfoService positionInfoService = (PositionInfoService) ctx.getBean("positionInfoService");
	ProjectInfoService projectInfoService = (ProjectInfoService) ctx.getBean("projectInfoService");
	GapInfoService gapInfoService = (GapInfoService) ctx.getBean("gapInfoService");
	PositionInfo tmpPi = new PositionInfo();
	tmpPi.setState(1);
	List<PositionInfo> pis = positionInfoService.findByCondition(tmpPi, null);
	
	ProjectInfo tmpPro = new ProjectInfo();
	tmpPro.setState(1);
	List<ProjectInfo> pros = projectInfoService.findByCondition(tmpPro, null);
	
	GapInfo tmpGap = new GapInfo();
	tmpGap.setState(1);
	List<GapInfo> gaps = gapInfoService.findByCondition(tmpGap, null);
%>
<script type="text/javascript">
$(function(){
	$("#dept_name").css("width","50%");
});
</script>
<div id="searchUser" class="overviewhead">
	<div>
	<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
		<thead>
			<tr>
				<th class="head1" style="width: 25%"></th>
			    <th class="head1" style="width: 25%"></th>
			    <th class="head1" style="width: 25%"></th>
			    <th class="head1" style="width: 25%"></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td align="left" colspan="4">
					<jsp:include page="/share/jsp/dept_role_ztree_checkbox.jsp"></jsp:include>
				</td>
			</tr>
			<tr>
				<td align="left">
					员工姓名： &nbsp;<input type="text" style="width:50%" id="zh_name" name="zh_name" value="" />
				</td>
				<td align="left">
					状态： &nbsp;
				    <select id="states" name="states">
				        <option value="1">在职</option>
				        <option value="2,3">非在职</option>
				    </select>
				</td>
				<td align="left">
					转正状态：&nbsp;
					<select name="try_state" id="try_state">
						<option value="">---请选择---</option>
						<%for(String try_state:Global.try_state){ %>
						<option value="<%=try_state%>"><%=try_state%></option>
						<%} %>
					</select>
				</td>
				<td align="left">
					办公/线上：&nbsp;
					<select name="type" id="type">
						<option value="">---请选择---</option>
						<%for(String type:Global.employee_type){ %>
						<option value="<%=type%>"><%=type%></option>
						<%} %>
					</select>
				</td>
			</tr>
			<tr>
				<td align="left" colspan="2">
					入职时间：&nbsp;
					<input style="width:25%" type="text" readonly="readonly" id="emp08_begin" name="emp08_begin" value=""  onfocus="wdateInstance();"/>
					~
					<input style="width:25%" type="text" readonly="readonly" id="emp08_end" name="emp08_end" value=""  onfocus="wdateInstance();"/>
				</td>
				<td align="left" colspan="2">
					离职薪资月：&nbsp;
					<input style="width:25%" type="text" readonly="readonly" id="emp04_begin" name="emp04_begin" value=""  onfocus="wdateInstance();"/>
					~
					<input style="width:25%" type="text" readonly="readonly" id="emp04_end" name="emp04_end" value=""  onfocus="wdateInstance();"/>
				</td>
			</tr>
			<tr>
				<td align="left" colspan="2">
					离辞职时间：&nbsp;
					<input style="width:25%" type="text" readonly="readonly" id="emp03_begin" name="emp03_begin" value=""  onfocus="wdateInstance();"/>
					~
					<input style="width:25%" type="text" readonly="readonly" id="emp03_end" name="emp03_end" value=""  onfocus="wdateInstance();"/>
				</td>
				<td align="left" colspan="2">
					合同截止时间：&nbsp;
					<input style="width:25%" type="text" readonly="readonly" id="begin_date" name="begin_date" value=""  onfocus="wdateInstance();"/>
					~
					<input style="width:25%" type="text" readonly="readonly" id="end_date" name="end_date" value=""  onfocus="wdateInstance();"/>
				</td>
			</tr>
		</tbody>
	</table>	
	</div>
	<br/>
	<div>
		<a id="searchBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>搜索</span></a>&nbsp;&nbsp;&nbsp;
		<a id="searchExportBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>导出</span></a>&nbsp;&nbsp;&nbsp;
		<a id="searchImportBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>导入</span></a>&nbsp;&nbsp;&nbsp;
		<a id="searchExportLeaveBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>剩余年假</span></a>&nbsp;&nbsp;&nbsp;
		<a id="searchExportOverBtn" style="cursor:pointer;" class="btn btn_search radius50"><span>剩余加班</span></a>&nbsp;&nbsp;&nbsp;
	</div>
</div>