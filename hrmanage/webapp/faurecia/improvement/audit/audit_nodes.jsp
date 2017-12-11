<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%@ include file="/faurecia/improvement/connector.jsp"%>
<%
	/* //handle_id
	int handle_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("handle_id"), "0"));
	int flow_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("flow_id"), "0"));
	int next_check_emp_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("next_check_emp_id"), "0"));
	int status = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("status"), "-1"));
	String flow_type = StringUtils.defaultIfEmpty(request.getParameter("flow_type"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	FlowInfoService flowInfoService = (FlowInfoService) ctx.getBean("flowInfoService");
	FlowStepService flowStepService = (FlowStepService) ctx.getBean("flowStepService");
	
	FlowInfo flowInfo = flowInfoService.queryById(flow_id, null);
	Map<Integer,String> flowMap = Util.convertToMap(flowInfo);
	
	FlowStep fs = new FlowStep();
	fs.setFlow_id(flow_id);
	fs.setHandle_id(handle_id);
	List<FlowStep> fsList = flowStepService.findByCondition(fs, null); */
	
	String formId=request.getParameter("formId");
%>
<script type="text/javascript">
	$(function(){
		var params = {};
		params['form_id']='<%=formId%>';
		var url='${improve}' + '/fhrapi/audit/nodes';
		var fn = "";
		$.ajax({
			url : url, // 请求链接
			data: params,
			type:"POST",     // 数据提交方式
			cache: false,
			timeout: 5000,
			async:false,
			dataType: 'json',
	        //crossDomain: true,
			//jsonp: "callback",//传递给请求处理程序或页面的，用以获得jsonp回调函数名的参数名(一般默认为:callback)
	        //jsonpCallback:"handleCallBackData",//自定义的jsonp回调函数名称，默认为jQuery自动生成的随机函数名，也可以写"?"，jQuery会自动为你处理数据
			success:function(data){
				formData = data;
				initNodeData(data);
			},
			error:function(data){
				showMsgInfo(data.msg);
			}
		});	
	});
		function initNodeData(data) {
			$.each( data.nodes, function(index, content) {
				var info = "";
				var params = {};
				params['empid']= content.EMId ;
				$.ajax({
					url : ctx+"/faurecia/improvement/data.jsp", // 请求链接
					data: params,
					type:"POST",     // 数据提交方式
					cache: false,
					timeout: 5000,
					async:false,
					dataType: 'json',
					success:function(data){
						
						info = data;
					},
					error:function(data){
						showMsgInfo(data.msg);
					}
				});
				
				var node_td = '<td>'+content.name+'</td>'
									+'<td>'+info.empinfo.zh_name+'</td>'
									+'<td>'+info.deptinfo.dept_name+'</td>'
									+'<td>'+content.nodeDesc+'</td>'
									+'<td>'+new Date(content.createdTime.time).toLocaleString()+'</td>'
									+'<td>'+content.comments+'</td>'
				$("#nodes_tab tbody").append('<tr>'+node_td+'</tr>');
			});
		}

</script>
<div class="widgetbox">
    <div class="title"><h3>流程</h3></div>
    <div class="widgetcontent padding0 statement">
       <table cellpadding="0" cellspacing="0" border="0" class="stdtable" id="nodes_tab">
            <colgroup>
                <col class="con0" />
                <col class="con1" />
                <col class="con0" />
            </colgroup>
            <thead>
                <tr>
                    <th class="head0">审核环节</th>
                    <th class="head1">审核人</th>
                    <th class="head0">审核人部门</th>
                    <th class="head1">审核人动作</th>
                    <th class="head0">审核时间</th>
                    <th class="head0">审核人意见</th>
                </tr>
            </thead>
            <tbody>
            	
            </tbody>
        </table>
    </div><!--widgetcontent-->
</div><!--widgetbox-->