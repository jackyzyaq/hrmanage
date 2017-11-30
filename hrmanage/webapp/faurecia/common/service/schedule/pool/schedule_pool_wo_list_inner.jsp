<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);

	String params = "";
	if (request.getQueryString() != null) {
		params = request.getQueryString();
	}
%>
<script type="text/javascript">
		$(function(){
			var _url = ctx+'/common/scheduleInfoPool/queryWOResult.do?<%=params%>';
			var param = {};
			param['pageIndex']=1;
			param['pageSize']=1000;	
			ajaxUrlFalse(_url,param,function(json){
				$.each(json.rows, function (n, value) {
		        	$("#schedule_pool_wo_table_tbody").append(
		        		"<tr><td><input type='checkbox' value='"+value.wo_number+"'>&nbsp;&nbsp;&nbsp;<a style='cursor:pointer;' onclick='schedule_pool_wo_table_tbody_fn(\""+value.wo_number+"\");'>"+value.wo_number+"</a></td>"+
		        		"<td>"+value.count+"</td>"+
		        		"<td>"+value.flow_type+"</td>"+
		        		"<td>"+value.begin_date+"</td>"+
		        		"<td>"+value.end_date+"</td>"+
		        		"<td>"+value.dept_names+"</td></tr>"
		        	);
		        });
			});
		});
		function schedule_pool_wo_table_tbody_fn(wo_number){
			click_(ctx+"/faurecia/common/service/schedule/pool/schedule_pool_list_view.jsp?wo_number="+wo_number);
		}
</script>

			<div class="widgetbox">
			    <div class="title"><h3>进入审批流表</h3></div>
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <colgroup>
			                <col class="con0" />
			                <col class="con1" />
			                <col class="con0" />
			            </colgroup>
			            <thead>
			                <tr>
			                    <th class="head0">单号</th>
			                    <th class="head0">数量</th>
			                    <th class="head0">类型</th>
			                    <th class="head1">起始时间</th>
			                    <th class="head0">结束时间</th>
			                    <th class="head1">GAP</th>
			                </tr>
			                <tr>
			            		<th colspan="6">
			            			<jsp:include page="/share/jsp/checkbox_selectall.jsp">
			            				<jsp:param value="schedule_pool_wo_table_tbody" name="div_id"/>
			            			</jsp:include>
			            			&nbsp;&nbsp;&nbsp;
			            			<button id="batch_submit" class="submit radius2">提交</button>
			            		</th>
			            	</tr>
			            </thead>
			            <tbody id="schedule_pool_wo_table_tbody">
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->
			</div>