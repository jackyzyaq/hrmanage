<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
	String kpi_date = StringUtils.defaultIfEmpty(request.getParameter("kpi_date"), "");
	String ext_1 = StringUtils.defaultIfEmpty(request.getParameter("ext_1"), "");
	String ext_2 = StringUtils.defaultIfEmpty(request.getParameter("ext_2"), "");
	String ext_2_name = StringUtils.defaultIfEmpty(request.getParameter("ext_2_name"), "");
	String background = StringUtils.defaultIfEmpty(request.getParameter("background"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	if(StringUtils.isEmpty(kpi_date)||StringUtils.isEmpty(ext_1)||StringUtils.isEmpty(ext_2)||StringUtils.isEmpty(ext_2_name)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	GapKPIService gapKPIService = (GapKPIService) ctx.getBean("gapKPIService");
	
	List<GapKPI> list = gapKPIService.getKPITypeAndDeptSql(ext_2, ext_1);
	if(list!=null&&!list.isEmpty()){
		for(int i=0;i<list.size();i++){
		String objId = ext_2+"_"+i;
		GapKPI pk = list.get(i);
		String kpi_type = StringUtils.defaultIfEmpty(pk.getKpi_type(), "");
		String dept_name = StringUtils.defaultIfEmpty(pk.getDept_name(), "");
		String kpi_data = (""+ext_1+"|"+ext_2+"|"+kpi_type+"|"+pk.getDept_name()+"|"+kpi_date+"|"+background+"|"+ext_2_name);
		pk = gapKPIService.queryByType(sdf.parse(kpi_date), kpi_type, dept_name,ext_1,ext_2);
		String color = null;
		if(pk==null){
			pk = new GapKPI();
			color = Global.colors[2];
		}else{
			color = (pk.getHealth_png().indexOf(Global.gap_kpi_health[0])>-1?Global.colors[0]:(pk.getHealth_png().indexOf(Global.gap_kpi_health[1])>-1?Global.colors[1]:Global.colors[2]));
		}		
%>
<script type="text/javascript">
$(function(){
	circleProgress('<%=objId%>', '<%=pk.getActual()==null?"-":Util.formatDouble1(Double.valueOf(pk.getActual())) %>','<%=color%>');
});
</script>
<div class="shadowdiv" style='margin:5px 5px 5px 5px;'>
		<table cellpadding='0' cellspacing='0' border='0' class='stdtable'><thead><tr><th colspan='2' class='head0' style="<%=StringUtils.isEmpty(background)?"":"background-color:"+background%>">
		<font style='font-size: 16px;'><%=ext_2_name %></font>
		</th></tr></thead>
		<tbody>
		<tr><td colspan='2'>
			<div class='widgetcontent userlistwidget nopadding'  id='<%=kpi_data %>' onclick='detail(this);' style='cursor:pointer;'>
				<ul>
					<li>
						<div style='font-size: 14px;font-weight: bold;height: 40px' title="<%=dept_name+"-"+kpi_type%>"><%=(dept_name+"-"+kpi_type).length()>30?(dept_name+"-"+kpi_type).substring(0,30)+"...":(dept_name+"-"+kpi_type) %></div>
						<div class="clearall"></div>
						<div style='float:right;margin-top: 40px;'><canvas id='<%=objId%>' width='65' height='65'></canvas></div>
						<div class='info'>
     							Target
							<p style='font-size: 14px;text-indent:2em'>
								<a style="cursor:pointer;"><%=pk.getTarget()==null?"-":Util.formatDouble1(Double.valueOf(pk.getTarget())) %></a>
							</p>
								Unit
							<p style='font-size: 14px;text-indent:2em'><a  style="cursor:pointer;"><%=StringUtils.defaultIfEmpty(pk.getExt_8(), "-") %></a></p>
 								Cumulate
							<p style='font-size: 14px;text-indent:2em'><a  style="cursor:pointer;"><%=pk.getCum()==null?"-":Util.formatDouble1(Double.valueOf(pk.getCum())) %></a></p>
						</div><!--info-->
					</li>
				</ul>
			</div><!--widgetcontent-->
		</td></tr>
		</tbody>
		</table>
	</div>
<%	
		}
	}else{
		String objId = ext_2+"_"+0;
%>
	<div class="shadowdiv" style='margin:5px 5px 5px 5px;'>
		<table cellpadding='0' cellspacing='0' border='0' class='stdtable'><thead><tr><th colspan='2' class='head0' style="<%=StringUtils.isEmpty(background)?"":"background-color:"+background%>">
		<font style='font-size: 16px;'><%=ext_2_name %></font>
		</th></tr></thead>
		<tbody>
		<tr><td colspan='2'>
			<div class='widgetcontent userlistwidget nopadding'  id='' style='cursor:pointer;'>
				<ul>
					<li>
						<div style='font-size: 14px;font-weight: bold;height: 40px'>-</div>
						<div class="clearall"></div>
						<div style='float:right;margin-top: 40px;'><canvas id='<%=objId%>' width='65' height='65'></canvas></div>
						<div class='info'>
     							Target
							<p style='font-size: 14px;text-indent:2em'>
								<a style="cursor:pointer;">-</a>
							</p>
								Unit
							<p style='font-size: 14px;text-indent:2em'><a  style="cursor:pointer;">-</a></p>
 								Cumulate
							<p style='font-size: 14px;text-indent:2em'><a  style="cursor:pointer;">-</a></p>
						</div><!--info-->
					</li>
				</ul>
			</div><!--widgetcontent-->
		</td></tr>
		</tbody>
		</table>
	</div>
<%	
	}	
%>
