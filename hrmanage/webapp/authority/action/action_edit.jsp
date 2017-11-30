<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int action_id = StringUtils.isEmpty(request.getParameter("action_id"))?-1:Integer.parseInt(request.getParameter("action_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	ActionInfoService actionInfoService = (ActionInfoService) ctx.getBean("actionInfoService");
	
	ActionInfo mi = actionInfoService.findById(action_id);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/authority/action/js/action.js"></script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
                    <form class="yqstdform" onSubmit="return false;">
                        <div>
                        	<label>所属菜单</label>
                            <span class="field">
                            	<jsp:include page="/share/jsp/menu_ztree.jsp" >
                            		<jsp:param value="<%=mi.getAction_menu_id() %>" name="parent_menu_id"/>
                            		<jsp:param value="<%=mi.getAction_menu_name() %>" name="parent_menu_name"/>
                            	</jsp:include>
                            </span>
                        </div>
                        <div>
                        	<label>动作代码</label>
                            <span class="field">
                            <input type="text" name="action_code" id="action_code"  class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getAction_code(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>动作名称</label>
                            <span class="field">
                            <input type="text" name="action_name" id="action_name" class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getAction_name(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>可见</label>
                            <span class="field">
                            <select name="viewmode" id="viewmode" class="uniformselect">
                            	<option value="1" <%=mi.getViewmode().intValue()==1?"selected":"" %>>是</option>
                                <option value="0" <%=mi.getViewmode().intValue()==0?"selected":"" %>>否</option>
                            </select>
                            </span>
                        </div>
                        <br clear="all" />
                        <div class="stdformbutton">
                        	<button id="editSubmit" class="submit radius2">提交</button>
                            <input type="reset" class="reset radius2" value="Reset" />
                            <input type="hidden" name="id" value="<%=mi.getId()%>"/>
                            <input type="hidden" name="action_menu_id" id="action_menu_id" value=""/>
                        </div>
                    </form>
        	</div>
</body>
</html>


        
