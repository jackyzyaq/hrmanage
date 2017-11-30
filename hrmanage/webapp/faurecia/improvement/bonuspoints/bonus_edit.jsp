<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%
String formId=request.getParameter("id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript">
	function doSubmit() {
		if (validateForm()) {
			//alert($("#targetMonthly").val());
			if(confirm('是否提交？')){
				  $('#basic_validate').ajaxSubmit({
				success : function(data) {
					if (data) {
						if (data.code == 'S') {
						showMsgInfo("操作成功！");
						window.setTimeout(
							function() {
								parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
								parent.jClose();
							}, 1500);
						}
					} else {
					  window.setTimeout(
						function() {
									$.alerts._hide();
						}, 1500);
					}
				}
			});
		  }
	    }
		return false;
	}
	
	function validateForm() {
		var pname = $("#proname").val();
		if(proname == '' || proname == 'undefined'){
 			showMsgInfo("请填礼品名！");
 			return false;
 		}
		
		var RPDesc = $("#RPDesc").val();
		if(RPDesc == '' || RPDesc == 'undefined'){
 			showMsgInfo("请填礼品描述！");
 			return false;
 		}
		var BPValues = $("#BPValues").val();
		if(BPValues == '' || BPValues == 'undefined'){
 			showMsgInfo("请填写兑换积分值！");
 			return false;
 		}
		var prostock = $("#prostock").val();
		if(prostock == '' || prostock == 'undefined'){
 			showMsgInfo("请填写礼品库存");
 			return false;
 		}
		var upload_uuid = $("#upload_uuid").val();
		if(upload_uuid != '' && upload_uuid != 'undefined'){
			$("#proimg").val($("#upload_uuid").val());
 		}
		
		
		return true;
	}
	
	function wdateInstanceforImp(){
		WdatePicker({dateFmt:'yyyy-MM',alwaysUseStartDate:false});
	}
</script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="form-horizontal cascde-forms" method="post"
				action="${improve}/fhrapi/rp/save" name="basic_validate"
				id="basic_validate" >
			<div>
				<div class="widgetbox">
					<div class="widgetcontent padding0 statement">
				   		<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
					        <thead>
					            <tr>
					                <th class="head1" style="width:15%"></th>
					                <th class="head1" style="width:20%"></th>
					                <th class="head1" style="width:15%"></th>
					                <th class="head1" style="width:20%"></th>
					                <th class="head1" style="width:10%"></th>
					                <th class="head1" style="width:20%"></th>
					            </tr>
					        </thead>
					        <tbody>
					        <tr>
					        	<td style="font-weight:bold" align="center">礼品名</td>
					        	<td>
					        		<input type="text" class="smallinput" name="proname" id="proname" value="" />
					        	</td>
					        	<td style="font-weight:bold;" align="center">所需积分</td>
					        	<td>
					        		<input type="text" class="smallinput" name="BPValues" id="BPValues" value="" />
					        	</td>
					        	<td style="font-weight:bold;" align="center">库存</td>
					        	<td>
					        		<input type="text" class="smallinput" name="prostock" id="prostock" value="" />
					        	</td>
					        </tr>
					        <tr>
					        	<td style="font-weight:bold;" align="center">礼品描述</td>
					        	<td colspan="5">
					        		<textarea rows="4" class="longinput" name="RPDesc" id="RPDesc" title="礼品描述"></textarea>
					        	</td>
					        </tr>
					        <tr>
								<td style="font-weight:bold" colspan="6">
									<div align="center" id="file_view">
									
						    		</div>
								</td>
							</tr>	
					        <tr>
					        	<td style="font-weight:bold;" colspan="6">
									<div>
							        	<jsp:include page="/share/jsp/upload_file.jsp"></jsp:include>
							    	</div>
							    	<div>
						       			仅支持<%=Global.UPLOAD_ACCEPT_2 %>图片文件，且文件小于<%=Global.UPLOAD_SIZE_2/1024 %>KB
						    		</div>
								</td>
					        </tr>
			         		</tbody>
			       		</table>
			     	</div>
			   </div>				
			</div>
            <div>
			 <button type="button" onclick="javascript:doSubmit();">确认</button>
			</div>
			<input type="hidden" name="proimg" id="proimg" value="" />
			<input type="hidden" name="id" id="id" value="<%=formId%>" />
		</form>
	</div>
	<script type="text/javascript">
		$(function(){
			var params = {};
			params['id']='<%=formId%>';
			var url='${improve}'+'/fhrapi/rp/edit';
			var fn = "";
			$.ajax({
				url : url, // 请求链接
				data: params,
				type:"POST",     // 数据提交方式
				cache: false,
				timeout: 5000,
				async:false,
				dataType: 'json',
				success:function(data){
					initFormData(data);
					fileView(data);
				},
				error:function(data){
					showMsgInfo(data.msg);
				}
			});	
		});
		function initFormData(data) {
			//formData = data;
			$("#id").val(data.id);
			$("#proname").val(data.proname);
			$("#RPDesc").val(data.RPDesc);
			$("#BPValues").val(data.BPValues);
			$("#prostock").val(data.prostock);
			$("#proimg").val(data.proimg);
		}
		
		/**
		 * 附件查看
		 * @param data
		 * @returns
		 */
		function fileView(data) {
			if(data.proimg != '' && 'null' != data.proimg && 'undifinde' != data.proimg) {
				var link = "<img style id=\"breaktime_upload_id\" src=\""+ ctx +"/share/jsp/showUploadFile.jsp?upload_uuid="+data.proimg+"\" alt=\"\" width=\"200\" height=\"200\" />";
				$("#file_view").html(link);
			}
		}
	</script>
</body>
</html>