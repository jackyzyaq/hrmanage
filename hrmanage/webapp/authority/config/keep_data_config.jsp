<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.service.*,net.sf.json.JSONObject"%>
<%
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	ConfigInfoService configInfoService = (ConfigInfoService) ctx.getBean("configInfoService");
	
	String name = StringUtils.defaultIfEmpty(request.getParameter("name"), "");
	String value = StringUtils.defaultIfEmpty(request.getParameter("value"), "");
	StringBuffer sb = new StringBuffer();
	try{
		configInfoService.save(name, value);
		sb.append("{");
	    sb.append("'flag':'"+Global.FLAG[1]+"',");
	    sb.append("'name':'"+name+"'");
		sb.append("}");
	}catch(Exception e){
		sb.delete(0, sb.toString().length());
		sb.append("{");
		sb.append("'flag':'"+Global.FLAG[0]+"',");
	    sb.append("'name':'"+name+"'");
		sb.append("}");
	}finally{
		JSONObject json = JSONObject.fromObject(sb.toString());
		response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
		response.setHeader("Cache-Control", "no-cache");
		try {
			response.getWriter().println(json.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
%>
