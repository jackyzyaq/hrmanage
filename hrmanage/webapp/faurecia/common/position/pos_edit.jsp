<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	int pos_id = StringUtils.isEmpty(request.getParameter("pos_id"))?-1:Integer.parseInt(request.getParameter("pos_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	PositionInfoService positionInfoService = (PositionInfoService) ctx.getBean("positionInfoService");
	
	PositionInfo mi = positionInfoService.queryById(pos_id,null);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/position/js/pos.js"></script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
                    <form class="yqstdform" onSubmit="return false;">
                        <div>
                        	<label>职位代码</label>
                            <span class="field">
                            <input type="text" name="pos_code" id="pos_code"  class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getPos_code(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>职位名称</label>
                            <span class="field">
                            <input type="text" name="pos_name" id="pos_name" class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getPos_name(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>有效</label>
                            <span class="field">
                            <select name="state" id="state" class="uniformselect">
                            	<option value="1" <%=mi.getState().intValue()==1?"selected":"" %>>是</option>
                                <option value="0" <%=mi.getState().intValue()==0?"selected":"" %>>否</option>
                            </select>
                            </span>
                        </div>
                        <br clear="all" />
                        <div class="stdformbutton">
                        	<button id="editSubmit" class="submit radius2">提交</button>
                            <input type="reset" class="reset radius2" value="Reset" />
                            <input type="hidden" name="id" value="<%=mi.getId()%>"/>
                        </div>
                    </form>
        	</div>
</body>
</html>