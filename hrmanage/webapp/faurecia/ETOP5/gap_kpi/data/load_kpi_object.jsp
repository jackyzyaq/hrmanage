<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="net.sf.json.JSONException"%>
<%@ page import="net.sf.json.JSONObject"%>
<%
	String kpi_date = StringUtils.defaultIfEmpty(request.getParameter("kpi_date"), "");
	String dept_name = StringUtils.defaultIfEmpty(request.getParameter("dept_name"), "");
	String kpi_type = StringUtils.defaultIfEmpty(request.getParameter("kpi_type"), "");
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	GapKPIService gapKPIService = (GapKPIService) ctx.getBean("gapKPIService");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	
	StringBuffer sb = new StringBuffer("{'rows':[");
	if(StringUtils.isEmpty(kpi_date)||StringUtils.isEmpty(dept_name)||StringUtils.isEmpty(kpi_type)){
	}else{
		GapKPI pk = gapKPIService.queryByType(sdf.parse(kpi_date), kpi_type, dept_name);
		if(pk!=null){
			String v = "";
			sb.append("{");
			List<String> attrList = new ArrayList<String>();
			ReflectPOJO.getAttrList(pk, attrList);
			for(String attr:attrList){
				sb.append("'"+attr+"':").append("\""+(Util.convertToString(ReflectPOJO.invokGetMethod(pk, attr)))+"\",");
			}
			if(attrList.size()>0)sb.deleteCharAt(sb.length()-1);
			attrList = null;
			sb.append("}");
		}
	}
	sb.append("]}");
	out.print(JSONObject.fromObject(sb.toString()).toString());
%>