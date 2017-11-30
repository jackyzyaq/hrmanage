<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
    <%
    Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
    String menu_id = StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0");
    int sub_menu_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("sub_menu_id"), "0"));
    String params = StringUtils.defaultIfEmpty(request.getParameter("params"), "");
    
    String ids = Util.getMenuAllIdsById(sub_menu_id,menuInfoMap);
    MenuInfo menu2Level = null;
    if(ids.split(",").length>1){
    	menu2Level = menuInfoMap.get(Integer.parseInt(ids.split(",")[1]));
    }
    %>
    
    	<ul id="left_ul">
    		<%
    		int i=(menu2Level == null?0:menu2Level.getId());
    		for(Integer key:menuInfoMap.keySet()){ 
    			MenuInfo mi = menuInfoMap.get(key);
    			if(mi.getParent_id().intValue()==0||mi.getParent_id().intValue()!=Integer.parseInt(menu_id)||mi.getIs_menu().intValue()==2)continue;
    			if(i==0)i=key.intValue();
    		%>
        	<li id="left_li_<%=mi.getId()%>"><a style="cursor:pointer;" onclick="left_click('<%=mi.getUrl() %>','<%=mi.getId() %>');" class="editor"><%=mi.getMenu_name() %></a></li>
        	<%} %>
        </ul>
        <a class="togglemenu"></a>
        <br /><br />
<script type="text/javascript">
$(function(){
	if(<%=(i==0?"false":"true")%>){
		alert('<%=menuInfoMap.get(i).getMenu_name()%>');
		var defaultUrl = '<%=(i==0?"":StringUtils.defaultIfEmpty(menuInfoMap.get(i).getUrl(),""))%>';
		var defaultParams = '<%=(i==0?"0":menuInfoMap.get(i).getId())%>';
		left_click(defaultUrl,defaultParams,'<%=sub_menu_id%>','<%=params %>');
	}else{
		$('#portal_right').empty();
	}
	
	///// COLLAPSED/EXPAND LEFT MENU /////
	$('.togglemenu').click(function(){
		if(!$(this).hasClass('togglemenu_collapsed')) {
			//if($('.iconmenu').hasClass('vernav')) {
			if($('.vernav').length > 0) {
				if($('.vernav').hasClass('iconmenu')) {
					$('body').addClass('withmenucoll');
					$('.iconmenu').addClass('menucoll');
				} else {
					$('body').addClass('withmenucoll');
					$('.vernav').addClass('menucoll').find('ul').hide();
				}
			} else if($('.vernav2').length > 0) {
			//} else {
				$('body').addClass('withmenucoll2');
				$('.iconmenu').addClass('menucoll2');
			}
			
			$(this).addClass('togglemenu_collapsed');
			
			$('.iconmenu > ul > li > a').each(function(){
				var label = $(this).text();
				$('<li><span>'+label+'</span></li>')
					.insertBefore($(this).parent().find('ul li:first-child'));
			});
		} else {
			
			//if($('.iconmenu').hasClass('vernav')) {
			if($('.vernav').length > 0) {
				if($('.vernav').hasClass('iconmenu')) {
					$('body').removeClass('withmenucoll');
					$('.iconmenu').removeClass('menucoll');
				} else {
					$('body').removeClass('withmenucoll');
					$('.vernav').removeClass('menucoll').find('ul').show();
				}
			} else if($('.vernav2').length > 0) {	
			//} else {
				$('body').removeClass('withmenucoll2');
				$('.iconmenu').removeClass('menucoll2');
			}
			$(this).removeClass('togglemenu_collapsed');	
			
			$('.iconmenu ul ul li:first-child').remove();
		}
	});
	
	
});
function left_click(menu_url,menu_id,sub_menu_id,params){
	if (typeof(sub_menu_id) == "undefined"||sub_menu_id==null||sub_menu_id=='') {
		sub_menu_id = 0;
	}
	if (typeof(params) == "undefined"||params==null||params=='') {
		params = 0;
	}
	$("#left_ul li").each(function(){
		if($(this).attr("id")=="left_li_"+menu_id){
			$(this).attr("class","current");
		}else{
			$(this).attr("class","");
		}
	});
	inner_html('${ctx }'+menu_url,'menu_id='+menu_id+'&sub_menu_id='+sub_menu_id+'&params='+params,'portal_right');
}
</script>