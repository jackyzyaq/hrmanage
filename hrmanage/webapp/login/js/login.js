$(function(){
	///// cookie /////	
	var yq_name = $.cookie('yq_name'); // 读取 cookie 
	var yq_pwd = $.cookie('yq_pwd'); // 读取 cookie 
	if(yq_name!=null&&yq_name!=''&&yq_pwd!=''&&yq_pwd!=null){
		$('#username').val(yq_name);
		$('#password').val(yq_pwd);
		$(".keep [name = flag]").attr("checked","checked");
	}
	
	
	
	///// TRANSFORM CHECKBOX /////							
	$('input:checkbox').uniform();
	///// ADD PLACEHOLDER HTML5/////
	$('#username').attr('placeholder','Username');
	$('#password').attr('placeholder','Password');
	$(document).keyup(function(event){
		  if(event.keyCode ==13){
		    $("#login").trigger("click");
		  }
	});
	///// LOGIN FORM SUBMIT /////
	$('#login').click(function(){
		if($('#username').val() == '' && $('#password').val() == '') {
			$('.nousername').fadeIn();
			$('.nopassword').hide();
			return false;	
		}
		if($(".keep [name = flag]:checkbox").attr("checked")){
			$.cookie('yq_name',$('#username').val(), { expires: 7 }); // 读取 cookie 
			$.cookie('yq_pwd',$('#password').val(), { expires: 7 }); // 读取 cookie 
		}else{
			$.cookie('yq_name', '', { expires: -1 }); // 删除 cookie
			$.cookie('yq_name', '', { expires: -1 }); // 删除 cookie
		}
		//if($('#username').val() != '' && $('#password').val() == '') {
		//	$('.nopassword').fadeIn().find('.userlogged h4, .userlogged a span').text($('#username').val());
		//	$('.nousername,.username').hide();
		//	return false;
		//}
		
		
        var param = {
                name:$('#username').val(),
                pwd:$('#password').val()
            };
        ajaxUrl(ctx+"/main/login.do",param,'login');
	});
});
function login(json){
    if(json.msg!=''){
		$('.nousername .loginmsg').text(json.msg);
		$('.nousername').fadeIn();
		$('.nopassword').hide();
	}else{
		ajaxUrl(ctx+"/main/updateLoginDate.do",'',function(){
			$('.nopassword').hide();
			$('.nousername').hide();
			click_href(ctx+"/index.jsp");
		});
		
	}
}
