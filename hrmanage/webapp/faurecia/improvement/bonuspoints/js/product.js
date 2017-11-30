		var formData = "";		

		/**
		 * 建议列表
		 * @returns
		 */
		function queryResult(){
			if($('#requestParam_dept_ids').val()==''){
				$('#requestParam_dept_ids').val('0');
			}
			
			var param = getParams("search");
			_dataGridFn("audit_datagrid",'/fhr/fhrapi/audit/index?'+param,breaktime_columns,breaktime_toolbar);
			
		}
		
		/**
		 * 审核列表
		 * @param empid
		 * @returns
		 */
		function queryResultForAudit(empid){
			if($('#requestParam_dept_ids').val()==''){
				$('#requestParam_dept_ids').val('0');
			}
			var param = getParams("search");
			param = param +'&nextEMPId=' + empid;
			_dataGridFn("audit_datagrid",'/fhr/fhrapi/audit/index?'+param,breaktime_columns,breaktime_toolbar);
		}
		
		/**
		 * 合理化建议表单提交
		 * @returns
		 */
		function validateForm() {
			var ispass = false;
			$("input[name='improveSourcesList']").each(function(){
				 if ($(this).attr('checked')) {
					 ispass = true;
		           }
			  });
			if(!ispass){
				showMsgInfo("请勾选建议【状况来源】！");
				return false;
			}
			ispass = false;
			$("input[name='improveTargetList']").each(function(){
				 //alert($(this).attr('checked'));
				 if ($(this).attr('checked')) {
					 ispass = true;
		           }
			  });
			if(!ispass){
				showMsgInfo("请勾选建议【改进方向】！");
				return false;
			}
			
			if($("#proposedSolution").val() == '' || $("#proposedSolution").val() == 'undefined' || $("#proposedSolution").val().lenght < 10){
				showMsgInfo("请填写【建议方案】！");
				return false;
			}
			
			if($("#currentSituation").val() == '' || $("#currentSituation").val() == 'undefined' || $("#currentSituation").val().lenght < 10){
				showMsgInfo("请填写【目前状况】！");
				return false;
			}
			
			return true;
		}
		
		/**
		 * 附件查看
		 * @param data
		 * @returns
		 */
		function fileView(data) {
			if(data.files != '' && 'null' != data.files && 'undifinde' != data.files) {
				var link = "<a style=\" padding: 2px 5px;\" href=\"javascript:click_href('"+ctx+"/share/jsp/showUploadFile.jsp?upload_uuid="+data.files+"');\">&nbsp;&nbsp;下载附件&nbsp;&nbsp;";
					link = link + "<img id=\"breaktime_upload_id\" src=\""+ ctx +"/images/download.png\" alt=\"\" width=\"18\" height=\"18\" /></a>";
				$("#file_view").html(link);
			}
		}
		
		function initFormData(data) {
			formData = data;
			$("#id").val(data.id);
			$("#empname").html(data.EMName);
			$("#dept_name").html(data.submitterDept);
			$("#emp_code").html(data.EMPNmber);
			$("#emp_gap").html(data.GAPGroup);
			$("#formCreatetime").html(new Date(data.createdTime.time).toLocaleString());
			
			$("#currentSituation").val(data.currentSituation);
			$("#proposedSolution").val(data.proposedSolution);
			
			var sList = data.improveSourcesList.split(",");
			for(var i=0;i<sList.length;i++){
				$("input[name='improveSourcesList']").each(function(){
					 if ($(this).val() == sList[i]) {
						 	$(this).parent().removeClass();
						 	$(this).parent().addClass('checked');
			                $(this).prop('checked',true);
			           }
					 //$(this).attr("disabled","disabled");
				  });
			}
			
			var sList = data.improveTargetList.split(",");
			for(var i=0;i<sList.length;i++){
				$("input[name='improveTargetList']").each(function(){
					 if ($(this).val() == sList[i]) {
						 	$(this).parent().removeClass();
						 	$(this).parent().addClass('checked');
			                $(this).prop('checked',true);
			           }
					 //$(this).prop("disabled","disabled");
				  });
				 
			}
		}
		
		/**
		 * 初始化各节点显示项目
		 * @param data
		 */
		function initAuditTable(data) {
			
		  $("#s1_linmgr_dept").hide(); 
		  $("#s1_linmgr_exer").hide();
		  $("#s2_exe_emp").hide(); 
		  $("#specifyExe_span").html(data.submitUserName);
		  $("#status").val(data.status);
		  $("#currentSituation").attr("disabled","disabled");
		  $("#proposedSolution").attr("disabled","disabled");
		  
		  
		  var step = data.auditStep;
		  //alert(data.auditStep);
		  switch (data.auditStep) {
		   case 2: //部门领导
		     	 $("#s1_linmgr").show();
		     	 $("#s2_exemgr").hide();
		     	 $("#s3_exer").hide();
		     	 $("#s4_sub_conf").hide();
		     	 $("#s5_genera").hide();
		         break;
		    case 3: //执行部门
		    	 $("#s1_linmgr").hide();
		     	 $("#s2_exemgr").show();
		     	 $("#s3_exer").hide();
		     	 $("#s4_sub_conf").hide();
		     	 $("#s5_genera").hide();
		         break;
		    case 4: //执行人
		    	 $("#s1_linmgr").hide();
		     	 $("#s2_exemgr").hide();
		     	 $("#s3_exer").show();
		     	 $("#s4_sub_conf").hide();
		     	 $("#s5_genera").hide();
		          break;
			case 5: //建议人确认
				 $("#s1_linmgr").hide();
		     	 $("#s2_exemgr").hide();
		     	 $("#s3_exer").hide();
		     	 $("#s4_sub_conf").show();
		     	 $("#s5_genera").hide();
		         break;
			case 6: //是否推广
				 $("#s1_linmgr").hide();
		     	 $("#s2_exemgr").hide();
		     	 $("#s3_exer").hide();
		     	 $("#s4_sub_conf").hide();
		     	 $("#s5_genera").show();
		     	 
		         break;
	        default:
	         
	      	break;
			}
		}
