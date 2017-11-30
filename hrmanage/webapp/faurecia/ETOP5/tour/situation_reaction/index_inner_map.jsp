<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String report_date = StringUtils.defaultIfEmpty(request.getParameter("report_date"), "");
	String dept_id 	= StringUtils.defaultIfEmpty(request.getParameter("dept_id"), "0");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	if(StringUtils.isEmpty(report_date)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	TourService tourService = (TourService) ctx.getBean("tourService");
	TourRecordService tourRecordService = (TourRecordService) ctx.getBean("tourRecordService");
	Tour tour = tourService.queryMap(Integer.parseInt(dept_id));
	
%>
<div style="margin-top:0px;">
	<script type="text/javascript">
	$(function(){
		$("#ext_1_photo").css("width",_document_body_width/2);
		$("#ext_1_photo").css("height",_document_body_height/2);
	});
	function editFile(map_upload){
		var param = getParamsJson("tour_map");
		param['dept_id']='<%=dept_id%>';
		ajaxUrl(ctx+'/common/tour/tourMapAdd.do',param,function(json){
			parent.showMsgInfo(json.msg+'');
			$("#tabs-a-2").click();
		});
	}
	</script>
	<div  id="tour_map">
	<jsp:include page="/share/jsp/upload_file_more.jsp">
		<jsp:param value="map_upload" name="input_name"/>
		<jsp:param value="<%=Global.UPLOAD_ACCEPT_1 %>" name="accept"/>
	</jsp:include>
	</div>
	<div class="clearall"></div>
	<%if(tour!=null){ %>
	<div style="margin: 5px"><img id="ext_1_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(tour.getMap_upload(), "0")  %>" alt="" width="40" height="40" /></div>
	<%} %>
</div>