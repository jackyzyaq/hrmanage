		$(function(){
			$('#searchUser #searchBtn').click(function(){
				queryResult();
			});
			$('#searchUser #searchExportBtn').click(function(){
				var param = getParams("searchUser");
				var u = ctx+"/common/employeeInfo/exportCsv.do"; //请求链接
				parent.downFile(u,param);
			});
			$('#searchUser #searchExportLeaveBtn').click(function(){
				var param = getParams("searchUser");
				var u = ctx+"/common/employeeInfo/exportLeaveCsv.do"; //请求链接
				parent.downFile(u,param);
			});
			$('#searchUser #searchExportOverBtn').click(function(){
				var param = getParams("searchUser");
				var u = ctx+"/common/employeeInfo/exportOverCsv.do"; //请求链接
				parent.downFile(u,param);
			});
			$('#searchUser #searchImportBtn').click(function(){
				parent.showHtml(ctx+'/faurecia/common/employee/emp_import.jsp','导入员工信息',500,400);
			});
			$('#contentwrapper #tabs-1 #editSubmit').click(function(){
				objBlur('tabs-1 #dept_td','emp21',$("#requestParam_parent_id").val(),_emp_dept_id);
				objBlur('tabs-1 #position_td','emp16',$("#position_id").val(),_emp_position_id);
				if(validateForm('contentwrapper #tabs-1')){
					$("#dept_id").val($("#requestParam_parent_id").val());
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper #tabs-1");
						ajaxUrl(ctx+'/common/employeeInfo/empEdit.do',param,'_emp_');
					}
				}
			});	
			$('#contentwrapper #tabs-2 #editSubmit').click(function(){
				if(validateForm('contentwrapper #tabs-2')){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper #tabs-2");
						ajaxUrl(ctx+'/common/employeeInfo/empEdit.do',param,'_emp_');
					}
				}
			});
			$('#contentwrapper #tabs-3 #editSubmit').click(function(){
				objBlur('tabs-3 #begin_end_td','emp22',$("#begin_date").val()+"|"+$("#end_date").val(),_emp_begin_end);
				objBlur('tabs-3 #emp01_td','emp18',$("#emp01").val(),_emp_emp01);
				objBlur('tabs-3 #hr_status_td','emp17',$("#hr_status_id").val(),_emp_hr_status_id);
				objBlur('tabs-3 #labor_type_td','emp19',$("#labor_type").val(),_emp_labor_type);
				objBlur('tabs-3 #contract_type_td','emp20',$("#contract_type").val(),_emp_contract_type);
				if(validateForm('contentwrapper #tabs-3')){
					if(dateJudge()){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper #tabs-3");
							ajaxUrl(ctx+'/common/employeeInfo/empEdit.do',param,'_emp_');
						}
					}
				}
			});
			$('#contentwrapper #tabs-4 #editSubmit').click(function(){
				if(validateForm('contentwrapper #tabs-4')){
					if (confirm('IC卡号替换前请抓取今天和昨天的考勤，是否提交？')) {
						var param = getParamsJson("contentwrapper #tabs-4");
						ajaxUrl(ctx+'/common/employeeInfo/editCard.do',param,'_emp_');
					}
				}
			});
			$('#contentwrapper #tabs-5 #editSubmit').click(function(){
				if($("#contentwrapper #tabs-5 #state").val()==1){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper #tabs-5");
						param['fromType']='updateOver';
						ajaxUrl(ctx+'/common/employeeInfo/empEdit.do',param,'_emp_');
					}
				}else{
					if(validateForm('contentwrapper #tabs-5')){
						if (confirm('是否提交？')) {
							var param = getParamsJson("contentwrapper #tabs-5");
							param['fromType']='updateOver';
							ajaxUrl(ctx+'/common/employeeInfo/empEdit.do',param,'_emp_');
						}
					}
				}
			});
		});
		function queryResult(){
			if($('#requestParam_dept_ids').val()==''){
				$('#requestParam_dept_ids').val('0');
			}
			var param = getParams("searchUser");
			_dataGridFn("emp_datagrid",ctx+'/common/employeeInfo/queryResult.do?'+param,emp_columns,emp_toolbar);
		}
		function _emp_(json){
		    if(json.msg!=''){
		    	if(json.id!=''){
		    		$("#NO").text(json.id);
		    	}
		    	showMsgInfo(json.msg);
			}else{
			}
		    //document.location.reload(true);
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function editFile(upload_uuid){
			$("#photo_upload_uuid").val(upload_uuid);
			$("#emp_photo").attr("src",ctx+"/share/jsp/showImage.jsp?file="+upload_uuid);
		}
		function _callback_photo_(json){
			showMsgInfo(json.msg);
			if(json.upload_uuid!='0'){
				document.getElementById('emp_photo').src=ctx+'/share/jsp/showImage.jsp?file='+json.upload_uuid;
			}
		}
		function editLeave(hr_status_id,text){
			$("#hr_status_id").val(hr_status_id);
			$("#leave_text").text(text);
			jClose();
		}
		function validateSteps(step) {
			var isStepValid = true;
			switch (parseInt(step)) {
			case 1:
				isStepValid = validateForm('wiz1step2_1');
				break;
			case 2:
				isStepValid = validateForm('wiz1step2_2');
				break;
			case 3:
				isStepValid = validateForm('wiz1step2_3');
				break;		
			default:
				if(isStepValid){
					isStepValid = validateForm('wiz1step2_1');
				}
				if(isStepValid){
					isStepValid = validateForm('wiz1step2_2');
				}
				if(isStepValid){
					isStepValid = validateForm('wiz1step2_3');
				}
				break;
			}
			return isStepValid;
		}
		
		function dateJudge(){
			var isTrue = true;
			if(isTrue){
				if(getDate($("#begin_date").val())<=getDate($("#end_date").val())){
				}else{
					showMsgInfo('必须 '+$("#begin_date").attr('title')+' <= '+$("#end_date").attr('title'));
					isTrue = false;
				}
			}
			
			if(isTrue){
				if(getDate($("#emp06").val())<=getDate($("#emp07").val())&&getDate($("#emp07").val())<=getDate($("#emp08").val())){
				}else{
					showMsgInfo('必须 '+$("#emp06").attr('title')+' <= '+$("#emp07").attr('title') +' <= '+$("#emp08").attr('title'));
					isTrue = false;
				}
			}
			return isTrue;
		}
		function loadTab6(emp_id,year){
			var params = {};
			params['emp_id'] = emp_id;
			params['year'] = year;
			$("#tabs-6").empty();
	 		inner_html(ctx+"/faurecia/common/employee/emp_leave.jsp",params,"tabs-6",null);
		}
		function objBlur(objId,dateObjId,newObjV,oldObjV){
			if(oldObjV!=newObjV){
				if($('#'+objId+" #"+dateObjId).length==0){
					$('#'+objId).append("<input class='Wdate' style='width:80px;' type='text' title='有效日期'  value='' id='"+dateObjId+"' name='"+dateObjId+"' value=''  onfocus='wdateInstance2();'/>");
				}
			}else{
				if($('#'+objId+" #"+dateObjId).length>0){
					$('#'+objId+" #"+dateObjId).remove();
				}
			}
		}