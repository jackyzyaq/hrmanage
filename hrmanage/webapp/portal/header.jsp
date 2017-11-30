<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
    <%
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
    com.yq.authority.pojo.UserInfo userInfo = (UserInfo)request.getSession().getAttribute("user"); 
    //out.print("++++++++++++++++++++"+userInfo.getName());
    %>
<div class="header">
    	<ul class="headermenu">
        	 <%
        	 int i=0;
    		for(Integer key:menuInfoMap.keySet()){ 
    			MenuInfo mi = menuInfoMap.get(key);
    			if(mi.getParent_id().intValue()!=0||mi.getIs_menu().intValue()==2)continue;
    			if(i==0)i=key.intValue();
    		%>
    		<li id="head_<%=key %>" <%=(i==key.intValue()||mi.getId().intValue()==Integer.parseInt(menu_id)?"class=\"current\"":"")%>><a style="cursor:pointer;" onclick="$('.headermenu li').each(function(){$(this).removeClass('current');});$(this).parent().addClass('current');head_click('<%=StringUtils.defaultIfEmpty(mi.getUrl(),"")%>','<%=mi.getId()%>');"><span class="<%=StringUtils.defaultIfEmpty(mi.getUrl_param(),"")%>"></span><%=mi.getMenu_name() %></a></li>
        	<%} %>
        </ul>
</div><!--header--> 
<script type="text/javascript">
$(function(){
	if(<%=(i==0?"false":"true")%>){
		var defaultUrl = '<%=(i==0?"":StringUtils.defaultIfEmpty(menuInfoMap.get(i).getUrl(),""))%>';
		var defaultParams = '<%=(i==0?"0":menuInfoMap.get(i).getId())%>';
		head_click(defaultUrl,defaultParams);
	}else{
		$('#portal_left').empty();
	}
});
//params k:v|k:v|k:v
function head_click(menu_url,menu_id,sub_menu_id,params){
	if (typeof(sub_menu_id) == "undefined"||sub_menu_id==null||sub_menu_id=='') {
		sub_menu_id = 0;
	}
	if (typeof(params) == "undefined"||params==null||params=='') {
		params = 0;
	}
	inner_html('${ctx }/portal/portal_left.jsp','menu_id='+menu_id+'&sub_menu_id='+sub_menu_id+'&params='+params,'portal_left');
}
</script>