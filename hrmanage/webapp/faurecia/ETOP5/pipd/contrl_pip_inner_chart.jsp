<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"), "");
	String end_month = StringUtils.defaultIfEmpty(request.getParameter("end_month"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(begin_month)||StringUtils.isEmpty(end_month)){
		end_month = sdf1.format(cal.getTime())+"";
		begin_month = sdf1.format(Util.addDate(cal.getTime(),"m", -1))+"";
	}
%>
<div class="widgetbox">
	<div class="title">
		<h4>
		Explanations to support selection of Top Priorities
		&nbsp;|&nbsp;
		<%=(begin_month+"~"+end_month)%>&nbsp;月
		</h4>
	</div>
	<div class="widgetcontent">
		<div class="one_third left">
		<div id="<%=Global.pip_item[0].replace("<br/>", "") %>" style="height:150px;"></div>
		</div>
		<div class="one_third left">
		<div id="<%=Global.pip_item[1].replace("<br/>", "") %>" style="height:150px;"></div>
		</div>
		<div class="one_third last">
		<div id="<%=Global.pip_item[2].replace("<br/>", "") %>" style="height:150px;"></div>
		</div>
	</div><!--widgetcontent-->
	<div class="widgetcontent">
		<div class="one_half left">
		<div id="<%=Global.pip_item[3].replace("<br/>", "") %>" style="height:150px;"></div>
		</div>
		<div class="one_half last">
		<div id="<%=Global.pip_item[4].replace("<br/>", "") %>" style="height:150px;"></div>
		</div>
	</div><!--widgetcontent-->
	<div class="widgetcontent">
		<div class="one_half left">
		<div id="<%=Global.pip_item[5].replace("<br/>", "") %>" style="height:150px;"></div>
		</div>
		<div class="one_half last">
		<div id="<%=Global.pip_item[6].replace("<br/>", "") %>" style="height:150px;"></div>
		</div>
	</div><!--widgetcontent-->	
</div><!--widgetbox-->
<script type="text/javascript">
$(function(){
	<%for(String item:Global.pip_item){%>
	$("#<%=item.replace("<br/>", "")%>").html("<img src='${ctx}/images/loader6.gif'/>");
	load_pipd_data('<%=item.replace("<br/>", "")%>','<%=item.replace("<br/>", "")%>','<%=Global.pip_head[0].replace("<br/>", "")%>','<%=begin_month%>','<%=end_month%>');
	<%}%>
});
</script>