		$(function(){
			$('#contentwrapper #userSubmit').click(function(){
				if(validateMenu('contentwrapper')){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper");
						ajaxUrl(ctx+'/authority/userInfo/userAdd.do',param,'_user_');
					}
				}
			});
			
			$('#contentwrapper #tabs-2 #editSubmit').click(function(){
				if(validateMenu('contentwrapper #tabs-2')){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper #tabs-2");
						ajaxUrl(ctx+'/authority/userInfo/userEdit.do',param,'_user_');
					}
				}
			});
			$('#contentwrapper #tabs-3 #editSubmit').click(function(){
				if(validateMenu('contentwrapper #tabs-3')){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper #tabs-3");
						ajaxUrl(ctx+'/authority/userInfo/userPwdEdid.do',param,'_user_');
					}
				}
			});				
			$('#contentwrapper #tabs-4 #editSubmit').click(function(){
				if(validateMenu('contentwrapper #tabs-4')){
					if (confirm('是否提交？')) {
						var param = getParamsJson("contentwrapper #tabs-4");
						ajaxUrl(ctx+'/authority/userInfo/userRoleEdid.do',param,'_user_');
					}
				}
			});			
			
			$('#searchUser #searchBtn').click(function(){
				queryResult();
			});			
		});
		
		function queryResult(){
			var param = getParams("searchUser");
			_dataGridFn("user_datagrid",ctx+'/authority/userInfo/queryResult.do?'+param,user_columns,user_toolbar);
		}
		function _callback_photo_(json){
			showMsgInfo(json.msg);
			if(json.upload_uuid!='0'){
				document.getElementById('user_photo').src=ctx+'/share/jsp/showImage.jsp?file='+json.upload_uuid;
			}
		}		
		function _user_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    parent.document.getElementById('iframe_menu_'+_parent_menu_id).contentWindow.location.reload(true);
		}
		function validateMenu(obj){
			var isTrue = true;
			$("#"+obj+" #role_ids").val($("#"+obj+" #requestParam_parent_id").val());
			if($("#"+obj+" #role_ids").length>0&&$("#"+obj+" #role_ids").val().Trim()==""){
				alert("请选择角色！");
				isTrue =  false;
			}else
			if($("#"+obj+" #name").length>0&&$("#"+obj+" #name").val().Trim()==""){
				alert("请输入用户名！");
				isTrue =  false;
			}else
			if($("#"+obj+" #zh_name").length>0&&$("#"+obj+" #zh_name").val().Trim()==""){
				alert("请输入名称！");
				isTrue =  false;
			}else
			if($("#"+obj+" #pwd").length>0&&$("#"+obj+" #pwd").val().Trim()==""){
					alert("请输入密码！");
					isTrue =  false;
			}else
			if($("#"+obj+" #repwd").length>0&&$("#"+obj+" #repwd").val().Trim()==""){
					alert("请再次输入密码！");
					isTrue =  false;
			}else
			if($("#"+obj+" #repwd").length>0&&$("#"+obj+" #repwd").val().Trim()!=$("#"+obj+" #pwd").val().Trim()){
					alert("二次输入密码不同！");
					isTrue =  false;
			}else if($("#"+obj+" #email").length>0&&!IsEmail($("#"+obj+" #email").val().Trim())){
				alert("邮箱格式不正确！");
				isTrue =  false;
			}
			return isTrue;
		}
