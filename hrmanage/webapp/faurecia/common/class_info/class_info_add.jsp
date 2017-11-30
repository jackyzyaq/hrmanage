<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/class_info/js/class_info.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/common/class_info/js/class_info_ext.js"></script>
<script type="text/javascript">
$(function(){
	var params = {};
	params['class_name']='';
	params['parent_div']='#class_info_inner';
	inner_html(ctx+'/share/jsp/auto_class.jsp',params,'class_info_inner #auto_class',null);
});
</script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<div id="class_info_inner">
				<div class="widgetbox">
					<jsp:include page="/faurecia/common/class_info/class_info_add_inner.jsp" />
			   </div>				
			</div>
            <div>
	            <button id="submit" class="submit radius2">提交</button>
	            <input type="reset" class="reset radius2" value="Reset" />
			</div>
		</form>
	</div>
</body>
</html>