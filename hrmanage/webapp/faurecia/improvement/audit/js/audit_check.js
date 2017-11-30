
	var formData = "";
	function initFormData(data) {
		formData = data;
		$("#id").val(data.id);
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
				 $(this).attr("disabled","disabled");
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
				 $(this).prop("disabled","disabled");
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
	