<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	int gap_id = StringUtils.isEmpty(request.getParameter("gap_id"))?-1:Integer.parseInt(request.getParameter("gap_id"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	GapInfoService gapInfoService = (GapInfoService) ctx.getBean("gapInfoService");
	
	GapInfo mi = gapInfoService.queryById(gap_id,null);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/gap/js/gap.js"></script>
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
                        	<label>编码</label>
                            <span class="field">
                            <input type="text" name="gap_code" id="gap_code"  class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getGap_code(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>名称</label>
                            <span class="field">
                            <input type="text" name="gap_name" id="gap_name" class="mediuminput" value="<%=StringUtils.defaultIfEmpty(mi.getGap_name(), "")%>"/>
                            </span>
                        </div>
                        <div>
                        	<label>描述</label>
                            <span class="field">
                            <textarea rows="4" class="mediuminput" name="remark" id="remark"><%=StringUtils.defaultIfEmpty(mi.getRemark(), "")%></textarea>
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