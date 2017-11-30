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
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	if(StringUtils.isEmpty(kpi_date)||StringUtils.isEmpty(ext_1)||StringUtils.isEmpty(ext_2)||StringUtils.isEmpty(ext_2_name)){
		return ;
	}
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	GapKPIService gapKPIService = (GapKPIService) ctx.getBean("gapKPIService");
	

	GapKPI pKPI = new GapKPI();
	pKPI.setKpi_date(sdf.parse(kpi_date));
	pKPI.setExt_2(ext_2);
	pKPI.setExt_1(ext_1);
	List<GapKPI> list = gapKPIService.findByCondition(pKPI, null);
	if(list!=null&&!list.isEmpty()){
		for(GapKPI pk:list){
			out.print("<div style='margin-top:10px;'>");
			out.print("<table cellpadding='0' cellspacing='0' border='0' class='stdtable'><thead><tr><th colspan='2' class='head0'>"+ext_2_name+"</th></tr></thead><tbody>");
			String kpi_type = StringUtils.defaultIfEmpty(pk.getKpi_type(), "");
			String kpi_data = (""+pk.getExt_1()+"|"+pk.getExt_2()+"|"+kpi_type+"|"+pk.getDept_name()+"|"+sdf.format(pk.getKpi_date())+"");
			out.print("<tr id='"+kpi_data+"' onclick='detail(this);' style='cursor:pointer;'>");
			out.print("<td title='"+kpi_type+"' style='width:70%'>"+(kpi_type)+"</td>");
			out.print("<td style='width:30%'>"+(pk==null||StringUtils.isEmpty(pk.getHealth_png())||pk.getHealth_png().equals("-")?
						"N/A":"<img src='"+pk.getHealth_png())+"'</td>");
			out.print("</tr>");
			out.print("</tbody></table>");
			out.print("</div>");
		}
	}else{
		out.print("<div style='margin-top:10px;'>");
		out.print("<table cellpadding='0' cellspacing='0' border='0' class='stdtable'><thead><tr><th colspan='2' class='head0'>"+ext_2_name+"</th></tr></thead><tbody>");
		out.print("<tr><td colspan='2'>N/A</td></tr>");
		out.print("</tbody></table>");
		out.print("</div>");
	}	
%>
