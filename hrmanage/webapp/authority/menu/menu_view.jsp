<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int id = StringUtils.isEmpty(request.getParameter("id"))?-1:Integer.parseInt(request.getParameter("id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	MenuInfoService menuInfoService = (MenuInfoService) ctx.getBean("menuInfoService");
	
	MenuInfo mi = menuInfoService.queryById(id,null);
	String parent_menu_name = StringUtils.isEmpty(mi.getParent_menu_name())?"":mi.getParent_menu_name();
	int parent_menu_id = mi.getParent_id()==null?0:mi.getParent_id();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	var param = {};
	param['root_div_id'] = 'contentwrapper';
	param['id'] = '<%=mi.getId()%>';
	param['pojo_object'] = '<%=mi.getClass().getName()%>';
	createRigthMenu(param);
});
</script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
                    <form class="yqstdform" onSubmit="return false;">
                        <div>
                        	<label>上级菜单</label>
                            <span class="field">
                            	<jsp:include page="/share/jsp/menu_ztree.jsp" >
                            		<jsp:param value="<%=parent_menu_id %>" name="parent_menu_id"/>
                            		<jsp:param value="<%=parent_menu_name %>" name="parent_menu_name"/>
                            	</jsp:include>
                            </span>
                        </div>
                        <div>
                        	<label>菜单代码</label>
                            <span class="field">
                            <input type="text" name="menu_code" id="menu_code"  class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getMenu_code(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>菜单名称</label>
                            <span class="field">
                            <input type="text" name="menu_name" id="menu_name" class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getMenu_name(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>URL</label>
                            <span class="field">
                            <input type="text" name="url" id="url" class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getUrl(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>URL参数</label>
                            <span class="field">
                            <input type="text" name="url_param" id="url_param" class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getUrl_param(), "")%>"/>
                            </span>
                        </div>                        
                        <div>
                        	<label>描述</label>
                            <span class="field">
                            <textarea rows="4" class="mediuminput" name="description" id="description"><%=StringUtils.defaultIfEmpty(mi.getDescription(), "")%></textarea>
                            </span> 
                        </div>
                        <div>
                        	<label>是否菜单</label>
                            <span class="field">
                            <select name="is_menu" id="is_menu" class="uniformselect">
                            	<option value="1" <%=mi.getIs_menu().intValue()==1?"selected":"" %>>是</option>
                                <option value="2" <%=mi.getIs_menu().intValue()==2?"selected":"" %>>否</option>
                            </select>
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
                            <input type="hidden" name="id" value="<%=mi.getId()%>"/>
                        </div>
                    </form>
        	</div>
</body>
</html>


        
