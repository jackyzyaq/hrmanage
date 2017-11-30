<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantScheduleService plantScheduleService = (PlantScheduleService) ctx.getBean("plantScheduleService");
	
	List<PlantSchedule> list = plantScheduleService.findByCondition(new PlantSchedule(),null);
%>
		<div class="widgetbox">
			<div>
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <colgroup>
			                <col class="con0" />
			                <col class="con1" />
			                <col class="con0" />
			            </colgroup>
			            <thead>
			                <tr>
			                    <th class="head0">标题</th>
			                    <th class="head0">开始时间</th>
			                    <th class="head0">结束时间</th>
			                    <th class="head0">状态</th>
								<th class="head0">操作者</th>
			                    <th class="head0">录入时间</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<%
			            	if(list!=null&&list.size()>0){ 
			            		for(int i=0;i<list.size();i++){
			            			PlantSchedule pd = list.get(i);
			            	%>
			            	<tr id="plantSchedule_<%=pd.getId() %>" onclick="plantSchedule_click_select(this);">
			            		<td id="id" style="display: none"><%=pd.getId() %></td>
			                    <td id="begin_date"><%=sdf.format(pd.getBegin_date()) %></td>
			                    <td id="end_date"><%=sdf.format(pd.getEnd_date()) %></td>
			                    <td id="title"><%=StringUtils.defaultIfEmpty(pd.getTitle(), "") %></td>
			                    <td id="state"><%=(pd.getState().intValue()==0?"无效":"有效") %></td>
			                    <td><%=pd.getOperater() %></td>
			                    <td><%=sdf.format(pd.getUpdate_date()) %></td>
			                </tr>
			            	<%} 
			            	}else{%>
			            	<tr>
			                    <td colspan="7">无数据</td>
			                </tr>
			            	<%} %>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->			
			</div>
		</div>
		<!--widgetbox-->
		<script>
		function plantSchedule_click_select(obj){
			var valForm = $("#"+obj.id).find("*");
			$.each(valForm,function(i,v){
				if(v.id.length>0){
					if(v.id=='state'){
						$("#plantSchedule_form #"+v.id).val($(this).text()=='无效'?"0":"1");
					}else{
						$("#plantSchedule_form #"+v.id).val($(this).text());
					}
				}
			});
		}
		</script>