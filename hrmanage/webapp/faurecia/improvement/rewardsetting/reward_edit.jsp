<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%@ page import="com.yq.authority.pojo.UserInfo" %>
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
		<%-- var params = {};
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
				//formData = data;
				//initNodeData(data);
			},
			error:function(data){
				showMsgInfo(data.msg);
			}
		});	 --%>
	});
		function setRewardType(vstutas) {
			var obj =  $("#type"+vstutas);
			 if (vstutas == 1 &&  obj.attr('checked')) {
				 obj.prop('checked',true);
				 $("#fmt_type").val('yyyyMM');
				 //$("#ok").val('将此建议设置为月度最佳');
			 }
			 if (vstutas == 2 &&  obj.attr('checked')) {
				 $(this).prop('checked',true);
				 $("#fmt_type").val('yyyy');
			}
			 $("input[name='type']").each(function(){
				 //alert($(this).parent().attr('class'));
				 if($(this).val() != vstutas && $(this).parent().attr('class') == 'checked' ){
					 $(this).parent().removeClass();
		             $(this).prop('checked',false);
		             $("#reword_value").val('');
		             //$("#ok").val('将此建议设置为年度最佳');
				 }
			 });
			 $("#type_id").val(vstutas);
		}
		
		function wdateInstanceforImp(){
			var fmt = $("#fmt_type").val();
			WdatePicker({dateFmt:fmt,alwaysUseStartDate:false});
		}

</script>
<div class="widgetbox">
    <div class="title"><h3>设置</h3></div>
    <div class="widgetcontent padding0 statement">
       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
            <thead>
            		<tr>
                 <th class="head0"></th>
                 <th class="head1"></th>
            		<tr>
            </thead>
            <tbody><tr title="请先勾选【月度】或【年度】后再点击输入框选择具体值">
            		<td>设置类型</td>
		        	<td>
		        		<input onclick="setRewardType(1)" id="type1" type="checkbox" name="type" value="1" />月度&nbsp;
		        		<input onclick="setRewardType(2)" id="type2" type="checkbox" name="type" value="2" />年度&nbsp;
		        		<input class="Wdate" style="width: 80px;" title="请先勾选【月度】或【年度】后再点击输入框选择具体值" placeholder="点击选择" onclick="wdateInstanceforImp();" type="text" readonly="readonly" id="reword_value" name="reword_value" value=""/>
		        	</td></tr>
		        <tr>
            </tbody>
        </table>
    </div><!--widgetcontent-->
    <input type="hidden" id="type_id" name="type_id" value="">
    <input type="hidden" id="fmt_type" value="">
</div><!--widgetbox-->
