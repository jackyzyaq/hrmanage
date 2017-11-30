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
	//得到第三层菜单
	List<MenuInfo> mi3List = new ArrayList<MenuInfo>();
	for(Integer key3:menuInfoMap.keySet()){ 
		MenuInfo mi3 = menuInfoMap.get(key3);
		if(mi.getId().intValue()!=mi3.getParent_id().intValue()||mi3.getIs_menu().intValue()==2)continue;
		mi3List.add(mi3);		
	}
%>
	<li id="left_li_<%=mi.getId()%>">
		<%if(mi3List!=null&&!mi3List.isEmpty()){%>
		<a id="left_ul_<%=mi.getId()%>" href="#sub_left_ul_<%=mi.getId()%>" style="cursor:pointer;"><%=mi.getMenu_name() %></a>
		<span class="arrow"></span>
        <ul id="sub_left_ul_<%=mi.getId()%>">
        	<%for(MenuInfo mi3:mi3List){
        		if(i==0)i=mi3.getId();
        	%>
        	<li><a id="sub_left_ul_<%=mi.getId()%>_<%=mi3.getId() %>_" onclick="left_click('sub_left_ul_<%=mi.getId()%>_<%=mi3.getId() %>_','<%=mi3.getUrl() %>','<%=mi3.getId() %>');" style="cursor:pointer;"><%=mi3.getMenu_name() %></a></li>
            <%} %>
        </ul>
		<%}else{ 
		if(i==0)i=mi.getId();
		%>
		<a id="left_ul_<%=mi.getId()%>_0_" onclick="left_click('left_ul_<%=mi.getId()%>_0_','<%=mi.getUrl() %>','<%=mi.getId() %>');" style="cursor:pointer;"><%=mi.getMenu_name() %></a>
		<%} %>
	</li>
<%} %>
</ul>
<a class="togglemenu"></a>
<br /><br />
<script type="text/javascript">
$(function(){
	if(<%=(i==0?"false":"true")%>){
		first_current($("#left_ul li:first-child").find("a:first-child").attr("id"));
		var defaultUrl = '<%=(i==0?"":StringUtils.defaultIfEmpty(menuInfoMap.get(i).getUrl(),""))%>';
		var defaultParams = '<%=(i==0?"0":menuInfoMap.get(i).getId())%>';
		$("#left_ul li a").each(function(){
			//如果是其它页面跳转过来的，i的值变为sub_menu_id
			if($(this).attr("id").indexOf("_"+<%=(sub_menu_id>0?i=sub_menu_id:i)%>+"_")>-1){
				<%if(sub_menu_id>0){%>
					defaultUrl='<%=Global.menuInfoMap.get(sub_menu_id).getUrl()%>';
					defaultParams='<%=Global.menuInfoMap.get(sub_menu_id).getId()%>';
				<%}%>
				left_click($(this).attr("id"),defaultUrl,defaultParams,'<%=sub_menu_id%>','<%=params %>');
				return ;
			}else{
			}
		});
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
	
	///// SHOW/HIDE VERTICAL SUB MENU /////	
	$('.vernav > ul li a, .vernav2 > ul li a').each(function(){
		var url = $(this).attr('href');
		$(this).click(function(){
			if($(url).length > 0) {
				if($(url).is(':visible')) {
					if(!$(this).parents('div').hasClass('menucoll') &&
					   !$(this).parents('div').hasClass('menucoll2'))
							$(url).slideUp();
				} else {
					$('.vernav ul ul, .vernav2 ul ul').each(function(){
							$(this).slideUp();
					});
					if(!$(this).parents('div').hasClass('menucoll') &&
					   !$(this).parents('div').hasClass('menucoll2'))
							$(url).slideDown();
				}
				return false;	
			}
		});
	});
});
function left_click(obj,menu_url,menu_id,sub_menu_id,params){
	li_sub_current(obj);
	right_inner(menu_url,menu_id,sub_menu_id,params);
}

function right_inner(menu_url,menu_id,sub_menu_id,params){
	if (typeof(sub_menu_id) == "undefined"||sub_menu_id==null||sub_menu_id=='') {
		sub_menu_id = 0;
	}
	if (typeof(params) == "undefined"||params==null||params=='') {
		params = 0;
	}
	if(menu_url=='-'){
		showInfo('还在处于开发阶段...');
		return ;
	}else{
		inner_html('${ctx }/portal/portal_right.jsp','menu_id='+menu_id+'&sub_menu_id='+sub_menu_id+'&params='+params,'portal_right',function(data){
			$("#portal_right").html(data);
		});
	}
}

function first_current(obj){
	if(typeof($("#"+obj).attr('href'))=="undefined"){
		$("#"+obj).parent().attr("class","current");
		return obj;
	}else{
		$("#"+obj).parent().attr("class","current");
		$("#"+obj).parent().find("ul li:first-child").attr("class","current");
		return $("#"+obj).parent().find("ul li a:first-child").attr("id");
	}
}

function li_sub_current(obj){
	$("#left_ul li").each(function(){
		$(this).attr("class","");
	});
	$("#"+obj).parent().attr("class","current");
	if($("#"+obj).parent().parent().parent().is("li")){
		$("#"+obj).parent().parent().parent().attr("class","current");
	}
}
</script>  