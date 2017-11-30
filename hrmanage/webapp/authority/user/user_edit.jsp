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
                                        <li><a href="#tabs-3">密码</a></li>
                                        <li><a href="#tabs-4">角色</a></li>
                                    </ul>
                                    <div id="tabs-1">
										<script type="text/javascript">
											$(function(){
												$("#file").attr("accept","<%=Global.UPLOAD_ACCEPT_1%>");
											});
											function editFile(upload_uuid){
												var param = {};
												param['upload_uuid']=upload_uuid;
												param['id']='<%=mi.getId()%>';
												ajaxUrl(ctx+'/authority/userInfo/userPhotoEdid.do',param,'_callback_photo_');		
											}
										</script>
										<div>
											<img id="user_photo" src="${ctx }/share/jsp/showImage.jsp?file=<%=StringUtils.defaultIfEmpty(mi.getUpload_uuid(),"0") %>" alt="" width="150" height="180"/>
								        </div>
								        <div>
								        	<div>
								        	仅支持JPG、GIF、PNG图片文件，且文件小于<%=Global.UPLOAD_SIZE_1/1000 %>kb
								        	</div>
								        	<jsp:include page="/share/jsp/upload_file.jsp" />
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
					                        <div class="stdformbutton">
					                        	<button id="editSubmit" class="submit radius2">提交</button>
					                            <input type="reset" class="reset radius2" value="Reset" />
					                            <input type="hidden" name="id" value="<%=mi.getId()%>"/>
					                        </div>
					                    </form>
                                    </div>
                                    <div id="tabs-3">
					                    <form id="tabs-3-form" class="yqstdform" onSubmit="return false;">
					                        <div>
					                        	<label>密码</label>
					                            <span class="field">
					                            <input type="password" name="pwd" id="pwd" class="mediuminput" value=""/>
					                            </span>
					                        </div> 
					                        <div>
					                        	<label>再次输入密码</label>
					                            <span class="field">
					                            <input type="password" name="repwd" id="repwd" class="mediuminput" value=""/>
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
					                        <div class="stdformbutton">
					                        	<button id="editSubmit" class="submit radius2">提交</button>
					                            <input type="reset" class="reset radius2" value="Reset" />
					                            <input type="hidden" name="id" value="<%=mi.getId()%>"/>
					                            <input type="hidden" name="role_ids" id="role_ids" value=""/>
					                        </div>
					                    </form>                                    
                                    </div>                                    
                                </div><!--#tabs-->
                            </div><!--widgetcontent-->
                        </div><!--widgetbox-->
        	</div><!--contentwrapper-->
	</div>
</body>
</html>


        
