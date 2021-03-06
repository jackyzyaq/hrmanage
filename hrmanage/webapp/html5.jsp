<%@ include file="/share/jsp/cartTag.jsp"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
 <html>
     <head>
        <jsp:include page="/common/shareJsp/cartHead.jsp" />
        <script type="text/javascript">
		//判断浏览器是否支持HTML5 Canvas           
		window.onload = function () {         
			try {                  
				//动态创建一个canvas元 ，并获取他2Dcontext。如果出现异常则表示不支持                   
				document.createElement("canvas").getContext("2d");        
				showMsgInfo("浏览器支持HTML5 CANVAS");         
			} catch (e) {
				showMsgInfo("浏览器不支持HTML5 CANVAS");
			}               
		};               
		//这段代 主要是获取摄像头的视频流并显示在Video 签中           
	    window.addEventListener("DOMContentLoaded", function () {            
			var canvas = document.getElementById("canvas"),              
				context = canvas.getContext("2d"),               
				video = document.getElementById("video"),
				videoObj = { "video": true },            
				errBack = function (error) {           
					console.log("Video capture error: ", error.code);   
				};               
				//navigator.getUserMedia这个写法在Opera中好像是navigator.getUserMedianow      
				if (navigator.getUserMedia) {
					navigator.getUserMedia(videoObj, function (stream) {
						video.src = stream;               
						video.play();      
					}, errBack);           
				} else if (navigator.webkitGetUserMedia) {        
					navigator.webkitGetUserMedia(videoObj, function (stream) {         
						video.src = window.webkitURL.createObjectURL(stream);           
						video.play();           
					}, errBack);           
				}         
			//这个是拍照按钮的事件，         
			$("#snap").click(function () {
				context.drawImage(video, 0, 0, 320, 320);
				CatchCode();           
			});           
		}, false);           
		//定时器         
		//var interval = setInterval(CatchCode, "30000");      
		//这个是 刷新上 图像的        
		function CatchCode() {        
			//实际运用可不写，测试代 ， 为单击拍照按钮就获取了当前图像，有其他用途   
			var canvans = document.getElementById("canvas");
			//获取浏览器页面的画布对象                       
			//以下开始编 数据   
			var imgData = canvans.toDataURL();
			//将图像转换为base64数据
			var base64Data = imgData.substr(22);
			//在前端截取22位之后的字符串作为图像数据      
			//开始异步上            
			$.post(ctx+"/main/ProcessRequest.do", { "img": base64Data }, function (data, status) {      
				if (status == "success") {
					if (data == "OK") {               
		               alert("二维 已经解析");                  
					} else {              
						alert(data);         
					}         
				}  else {
					alert("数据上 失败");
				}                 
			}, "text");           
		}      
	    </script>
     </head>
     <body>
    <div id="contentHolder">      
    <video id="video" width="320" height="320" autoplay>
    </video>      
    <button id="snap" style="display:"> 拍照</button>        
    <canvas id="canvas" width="320" height="320"></canvas>
       </div>
     </body>
 </html>