<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.common.service.*"%>
<%
	int meals_id = StringUtils.isEmpty(request.getParameter("meals_id"))?-1:Integer.parseInt(request.getParameter("meals_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	CommonService commonService = (CommonService) ctx.getBean("commonService");
	
	List<Map<String,Object>> list = commonService.queryMeals(null);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
$(function(){
	$('#editSubmit').click(function(){
		var param = {};
		var msg='';
		if(validateForm("contentwrapper")){
			var valForm = $("#meals_id").find("*");
			$.each(valForm,function(i,v){
				if($(this).is('span')){
					var m_id = $(this).attr("id");
					var meals_name = $("#"+m_id+" #meals_name_"+m_id).val();
					var begin_time = $("#"+m_id+" #begin_time_"+m_id).val();
					var end_time = $("#"+m_id+" #end_time_"+m_id).val();
					param['meals_name']=meals_name;
					param['begin_time']=begin_time;
					param['end_time']=end_time;
					ajaxUrlFalse(ctx+'/common/commonWeb/mealsEdit.do',param,function(json){
						if(json.flag=='0'){
					    	msg = json.msg;
						}else{
						}
					});
				}
			});
			if(msg.Trim().length>0){
				parent.showMsgInfo(msg.Trim());
			}
			document.location.reload(true);
		}
	});
});
</script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
                    <form id="meals_id" class="yqstdform" onSubmit="return false;">
                    	<%if(list!=null&&!list.isEmpty()){ 
                    		for(Map<String,Object> m:list){
                    	%>
                        <div>
                        	<label><%=m.get("name").toString() %></label>
                            <span class="field" id="<%=m.get("id")%>">
                            <input type="hidden" name="meals_name" id="meals_name_<%=m.get("id")%>" value="<%=m.get("name")%>"/>
                            <input type="text" name="begin_time" id="begin_time_<%=m.get("id")%>" readonly="readonly"  style="width:120px;" value="<%=m.get("begin_time")%>" onclick="wTimeInstance();"/>
                            &nbsp;~&nbsp;
                            <input type="text" name="end_time" id="end_time_<%=m.get("id")%>" readonly="readonly"  style="width:120px;" value="<%=m.get("end_time")%>"  onclick="wTimeInstance();"/>
                            </span>
                        </div>
                        <%}} %>
                        <br clear="all" />
                        <div class="stdformbutton">
                        	<button id="editSubmit" class="submit radius2">提交</button>
                            <input type="reset" class="reset radius2" value="Reset" />
                        </div>
                    </form>
        	</div>
</body>
</html>