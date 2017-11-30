<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="improve" value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}/fhr" />
<%@ page import="com.util.*,java.text.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="java.util.*"%>
<%request.setCharacterEncoding("utf-8"); %>
