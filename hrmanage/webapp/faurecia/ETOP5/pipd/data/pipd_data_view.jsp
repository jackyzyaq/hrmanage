<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	String type = StringUtils.defaultIfEmpty(request.getParameter("type"), "");
	String sub_type = StringUtils.defaultIfEmpty(request.getParameter("sub_type"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PipdDataService pipdDataService = (PipdDataService) ctx.getBean("pipdDataService");
	
	PipdData pipdData = new PipdData();
	pipdData.setState(1);
	pipdData.setType(type);
	pipdData.setSub_type(sub_type);
	List<PipdData> list = pipdDataService.findByCondition(pipdData,null);
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
			                    <th class="head0">月份</th>
			                    <th class="head0">数据类型</th>
			                    <th class="head0">类型2</th>
			                    <th class="head0">达标值</th>
			                    <th class="head0">实际值</th>
			                    <th class="head1">操作者</th>
			                    <th class="head0">录入时间</th>
			                </tr>
			            </thead>
			            <tbody>
			            	<%
			            	if(list!=null&&list.size()>0){ 
			            		for(int i=0;i<list.size();i++){
			            			PipdData pd = list.get(i);
			            	%>
			            	<tr id="pipd_view_<%=pd.getId() %>_<%=pd.getType() %>">
			                    <td id="report_date" title="点击修改"><a style="cursor:pointer;" onclick="pipd_view_click_select('<%=sdf1.format(pd.getReport_date()) %>');"><%=sdf1.format(pd.getReport_date()) %></a></td>
			                    <td id="type"><%=pd.getType()%></td>
			                    <td id="sub_type"><%=pd.getSub_type()%></td>
			                    <td id="must_pipd_data"><%=pd.getMust_pipd_data()%></td>
			                    <td id="reality_pipd_data"><%=pd.getReality_pipd_data()%></td>
			                    <td><%=pd.getOperater() %></td>
			                    <td><%=sdf.format(pd.getUpdate_date()) %></td>
			                </tr>
			            	<%} 
			            	}else{%>
			            	<tr>
			                    <td colspan="6">无数据</td>
			                </tr>
			            	<%} %>
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->			
			</div>
		</div>
		<script>
		function pipd_view_click_select(report_date){
			var param = {};
			param['pageIndex']=1;
			param['pageSize']=1000;
			param['state']='1';
			param['report_date']=report_date+'-01 00:00:00';
			ajaxUrl("${ctx}/common/pipd/queryResult.do",param,function(json){
				$("#pipd_data_form #report_date").val(report_date);
				$("#pipd_data_form #sub_type").val("<%=Global.pip_head[0].replace("<br/>","")%>");
				$.each(json.rows, function (n, value) {
					$("#pipd_data_form #"+value.type+" #type").val(value.type);
					$("#pipd_data_form #"+value.type+" #must_pipd_data").val(value.must_pipd_data);
					$("#pipd_data_form #"+value.type+" #reality_pipd_data").val(value.reality_pipd_data);
			   });
            });
		}
		</script>		
		<!--widgetbox-->