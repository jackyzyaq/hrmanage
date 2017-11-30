<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/authority/user/js/user.js"></script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
                    <form class="yqstdform" onSubmit="return false;">
                        <div>
                        	<label>用户名</label>
                            <span class="field">
                            <input type="text" name="name" id="name"  class="mediuminput" value="" onchange="this.value=this.value.replace(/[^a-zA-Z_@.]/g,'');" onkeyup="this.value=this.value.replace(/[^a-zA-Z_@.]/g,'');" onafterpaste="this.value=this.value.replace(/[^a-zA-Z_@.]/g,'');"/>
                            </span>
                        </div>
                        <div>
                        	<label>名称</label>
                            <span class="field">
                            <input type="text" name="zh_name" id="zh_name" class="mediuminput" value=""/>
                            </span>
                        </div>
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
                        <div>
                        	<label>邮箱</label>
                            <span class="field">
                            <input type="text" name="email" id="email" class="mediuminput" value=""/>
                            </span>
                        </div>                        
                        <div>
                        	<label>有效</label>
                            <span class="field">
                            <select name="state" id="state" class="uniformselect">
                            	<option value="1">是</option>
                                <option value="0">否</option>
                            </select>
                            </span>
                        </div>
                        <div>
                        	<label>角色</label>
                            <span class="field">
								<jsp:include page="/share/jsp/role_ztree_checkbod.jsp">
                            		<jsp:param value="" name="parent_role_id"/>
                            		<jsp:param value="" name="parent_role_name"/>
                            	</jsp:include>
                            </span>
                        </div>                        
                        
                        <br clear="all" />
                        <div class="stdformbutton">
                        	<button id="userSubmit" class="submit radius2">提交</button>
                            <input type="reset" class="reset radius2" value="Reset" />
                            <input type="hidden" name="role_ids" id="role_ids" value=""/>
                        </div>
                    </form>
        	</div>
</body>
</html>


        
