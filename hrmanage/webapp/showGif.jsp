<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'showGif.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>

	<link rel="stylesheet" type="text/css" href="styles.css">

<script type="text/javascript">


var t1 = window.setInterval(Show_Hidden,6000); 
function Show_Hidden(){
//alert("123");
	var trid = document.getElementById("tr1");
    if(trid.style.display=="block"){
        trid.style.display='none';
    }else{
        trid.style.display='block';
    }
    window.clearInterval(t1);
    
}
var sh;
$(document).ready(function(){
	sh=setInterval(show1,30);
// $("div").animate({marginTop:500,marginLeft:500, opacity:'show'},{ duration: 5000 });
 });
 function show1(){
	var odiv=document.getElementById('div1');
	if(odiv.offsetLeft == 500){
		clearInterval(sh);
	}else if(odiv.offsetLeft != 500){
		odiv.style.left=odiv.offsetLeft-10+'px';
	}
}
</script>
<style type="text/css">

#div1{ background:#0080FF;  width:500px; height:50px; padding:20px; color:#fff;position: absolute;left:1500px;top:200px;}
</style>


  </head>
  
  <body background="12.gif" style="background-size:cover">
<table>


<div id="div1">
	账号:<input type="text" value="" id="btn"/>
	密码:<input type="text" value="" id="btn"/>
</div>
</table>
  </body>
</html>
