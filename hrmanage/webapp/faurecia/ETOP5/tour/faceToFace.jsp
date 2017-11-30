<%@page import="com.yq.faurecia.service.DepartmentInfoService"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DAY_OF_MONTH, -1);
	
	
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	DepartmentInfoService departmentInfoService = (DepartmentInfoService) ctx.getBean("departmentInfoService");
	DepartmentInfo dept = departmentInfoService.queryById(1,null);
	List<DepartmentInfo> deptList = departmentInfoService.findByParentId(1);
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/tour/js/index.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
<script type="text/javascript">
	$(function(){
		var div_width = parseInt(_document_width/8);
		$(".vernav2").css("width",div_width+"px");
		$(".withvernav").css("background","#fff url(${ctx}/js/ama/images/line.ccc.png) repeat-y "+div_width+"px 0");
		$("#index").css("margin-left",div_width+"px");
		$("#index").css("position","relative");
		index_inner('<%=dept.getId()%>');
		$("#formsub").slideDown();
	});
	function index_inner(deptId){
		var report_date = $("#report_date").val();
		var _url = ctx+'/faurecia/ETOP5/tour/faceToFace_inner.jsp';
		var params = {};
		params['report_date']=report_date;
		params['dept_id']=deptId;
		inner_html(_url,params,'index',function(data){
			$("#index").html(data);
		});
	}
</script>
</head>
<body class="withvernav">
	<table cellpadding='0' cellspacing='0' border='0' class='stdtable'>
		<thead>
			<tr>
				<th colspan='2' class="gradient">
					<div style="margin-left: 0px;margin-bottom:10px;" >
						<div class="one_hlaf">
							<div style="float: left">
								<h4><font style="color: <%=Global.colors[3]%>">Face To Face</font></h4>
							</div>
						</div>		
						<div class="one_hlaf last">
							<div style="float: right">
								<h5>
								<input style="width: 80px;height: 18px;" type="text" readonly="readonly" id="report_date" name="report_date" value="<%=sdf.format(cal.getTime())%>"  onfocus="wdateInstance2(function(){if($('#report_date').val().Trim()==''){return false;}index_inner('<%=dept.getId()%>');});"/>
								&nbsp;|&nbsp;
								[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="validateEtopPwd('${ctx}/faurecia/ETOP5/tour/data/tour_info_data_add.jsp?menu_id=<%=menu_id %>','TOUR 数据添加');">&nbsp;+&nbsp;</a>]
								&nbsp;|&nbsp;
								<jsp:include page="/share/jsp/screen_full_open.jsp" />
								</h5>
							</div>
						</div>
					</div>
					<div class="clearall"></div>
				</th>
			</tr>
		</thead>
		<tbody>
		<tr>
			<td>
				<div class="bodywrapper">
					<div class="vernav2 iconmenu" style="position:fixed;top: 36px;">
						<ul id="left_ul">
				        	<li><a href="#formsub" class="elements">FTF</a>
				            	<span class="arrow"></span>
				            	<ul id="formsub">
				               		<li><a href="javascript:index_inner('<%=dept.getId()%>');"><%=dept.getDept_code().replace("&", "")%></a></li>
				               		<%
				               			if(deptList!=null){
				               				               		for(DepartmentInfo di:deptList){ 
				               				               			if(!Util.containsIndexOf(Global.tour_depts, di.getDept_code())) continue;
				               		%>
				                    <li><a href="javascript:index_inner('<%=di.getId()%>');"><%=di.getDept_code().replace("&", "") %></a></li>
				                    <%}} %>
				                </ul>
				            </li>
						</ul>	
					</div>
					<div id="index" style="margin-left: 0px;margin-right:0px;"></div>
				</div><!--bodywrapper-->
				
			</td>
		</tr>
		</tbody>
	</table>
	<script type="text/javascript">
			$("#index").css("height",window.screen.availHeight-120);
	</script>	
</body>
</html>
