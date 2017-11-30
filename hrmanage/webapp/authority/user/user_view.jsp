<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int user_id = StringUtils.isEmpty(request.getParameter("user_id"))?-1:Integer.parseInt(request.getParameter("user_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	UserInfoService userInfoService = (UserInfoService) ctx.getBean("userInfoService");
	
	UserInfo mi = userInfoService.queryById(user_id,null);
	
	
	RoleInfoService roleInfoService=(RoleInfoService)ctx.getBean("roleInfoService");
	
	List<RoleInfo> roleResult = roleInfoService.findRoleByUserId(user_id);
	String role_id = "";
	String role_name = "";
	if(roleResult!=null&&roleResult.size()>0){
		for(RoleInfo roleInfo:roleResult){
			role_id +=roleInfo.getId()+",";
			role_name +=roleInfo.getRole_name()+",";
		}
		role_id = role_id.substring(0,role_id.length()-1);
		role_name = role_name.substring(0,role_name.length()-1);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/authority/user/js/user.js"></script>
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
	<div class="bodywrapper">
        	<div id="contentwrapper" class="contentwrapper"  style="padding:0px">
						<div class="widgetbox">
							<div class="title"><h3><%=StringUtils.defaultIfEmpty(mi.getZh_name(),"") %></h3></div>
                            <div class="widgetcontent">
                                <div id="tabs">
                                    <ul>
                                        <li><a href="#tabs-1">头像</a></li>
                                        <li><a href="#tabs-2">用户信息</a></li>
                                        <li><a href="#tabs-4">角色</a></li>
                                    </ul>
                                    <div id="tabs-1">
										<div>
											<img id="user_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(mi.getUpload_uuid(),"0") %>" alt="" width="150" height="180"/>
								        </div>
                                    </div>
                                    <div id="tabs-2">
					                    <form id="tabs-2-form" class="yqstdform" onSubmit="return false;">
					                        <div>
					                        	<label>用户名</label>
					                            <span class="field">
					                            <input type="text" name="name" id="name"  class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getName(), "")%>" readonly="readonly"/>
					                            </span>
					                        </div>
					                        <div>
					                        	<label>名称</label>
					                            <span class="field">
					                            <input type="text" name="zh_name" id="zh_name"  class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getZh_name(), "")%>"/>
					                            </span>
					                        </div>
					                        <div>
					                        	<label>邮箱</label>
					                            <span class="field">
					                            <input type="text" name="email" id="email" class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getEmail(), "")%>"/>
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
					                    </form>
                                    </div>
                                    <div id="tabs-4">
					                    <form id="tabs-4-form" class="yqstdform" onSubmit="return false;">
					                        <div>
					                        	<label>角色</label>
					                            <span class="field">
													<jsp:include page="/share/jsp/role_ztree_checkbod.jsp">
					                            		<jsp:param value="<%=role_id %>" name="role_id"/>
					                            		<jsp:param value="<%=role_name %>" name="role_name"/>
					                            	</jsp:include>
					                            </span>
					                        </div>                         
					                        <br clear="all" />
					                    </form>                                    
                                    </div>                                    
                                </div><!--#tabs-->
                            </div><!--widgetcontent-->
                        </div><!--widgetbox-->
        	</div><!--contentwrapper-->
	</div>
</body>
</html>