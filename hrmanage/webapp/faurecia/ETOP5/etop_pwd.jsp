<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String jumpUrl = StringUtils.defaultIfEmpty(request.getParameter("jumpUrl"), "").replace("|","&");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	$('#contentwrapper #tabs-3 #editSubmit').click(function(){
		if(validateForm('contentwrapper #tabs-3')){
			var param = getParamsJson("contentwrapper #tabs-3");
				ajaxUrl(ctx+'/common/etop5/valPwd.do',param,function(json){
					if(json.flag=='1'){
						<%if(!StringUtils.isEmpty(jumpUrl)){%>
							click_href('<%=jumpUrl%>');
						<%}%>
					}else{
						showInfo('密码错误！');
					}
				});
		}
	});				
});
</script>
</head>
<body>
	<div class="bodywrapper">
        	<div id="contentwrapper" class="contentwrapper"  style="padding:0px">
						<div class="widgetbox">
                            <div class="widgetcontent">
                                <div id="tabs">
                                    <div id="tabs-3">
					                    <form id="tabs-3-form" class="yqstdform" onSubmit="return false;">
					                        <div>
					                        	<label>密码</label>
					                            <span class="field">
					                            <input type="password" name="etop5_pwd" id="etop5_pwd" class="mediuminput" value=""/>
					                            </span>
					                        </div> 
					                        <br clear="all" />
					                        <div class="stdformbutton">
					                        	<button id="editSubmit" class="submit radius2">提交</button>
					                            <input type="reset" class="reset radius2" value="Reset" />
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