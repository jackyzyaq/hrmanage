<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML>
    <html>  
    <head>  
        <title></title>  
        <jsp:include page="/common/shareJsp/cartHead.jsp" />
        <script type="text/javascript">  
            
    $(function () {  
        var d1 = [   
                    { label: "Bar", data: [ [1, 13], [2, 11], [3, 7] ] }  
                ];  
        
        var stack = 0, bars = true, lines = false, steps = false;  
      
        $.plot($("#bar1"), d1, {  
            series: {         
                color: '#333',  
                abel: 'morris',  
                stack: 0,  
                lines: {   
                    //show: true,   
                    fill: true,   
                    steps: false   
                },  
                point: {  
                    show: true,  
                },  
                bars: {   
                    show: true,   
                    barWidth: 0.6  
                }  
            }  
        });   
    });  
      
      
    $(function(){  
        var d1 = [   
                    { label: "Bar1", data: [ [0, 0], [0, 0], [2, 11], [3, 7] ] ,color: '#abcdef',bars: {
			            show: true, 
			            align: "center",
			            barWidth: 0.6,
			            lineWidth:1
			        } },  
                    { label: "Bar2", data: [ [0, 0], [1, 13], [0, 0], [0, 0] ] , color: '#fedcba',bars: {
			            show: true, 
			            align: "center",
			            barWidth: 0.6,
			            lineWidth:1
			        }},  
			        { label: "line", data: [ [0, 0], [1, 13], [0, 0], [0, 0] ] , color: '#fedcba',
				        points: {fillColor: "#0062FF", show: true },
		        		lines: {show:true,fill: false, steps: false}
			        },  
                ];  
        $.plot($("#bar2"), d1, {  
			xaxis: {
                    show: true,
                    //position: 'left',
                    //color: '#ccc',
                    //tickColor: '#fff',
                    ticks: [[0,'a'],[1,'b'],[2,'c'],[3,'d']],
                    tickSize: 2,
                    axisLabelUseCanvas: true,
                    axisLabelFontSizePixels: 12,
                    axisLabelFontFamily: 'Verdana, Arial',  
                    axisLabelPadding: 10  
      
			},  
 		});  
          
    });  
      
      
    $(function(){  
      
        var d1 = [   
                    { label: "Bar1", data: [ [10, 0], [11, 1], [12, 2], [13, 3] ] ,color: '#abcdef' },  
                    { label: "Bar2", data: [ [13,0], [12, 1], [11, 2], [10, 3] ] , color: '#fedcba'}  
                ];  
        $.plot($("#bar3"), d1, {  
               series: {  
                    bars: {  
                        show: true  
                    }  
                },  
                bars: {  
                    align: "center",  
                    barWidth: 0.5,  
                    horizontal: true,  
                },  
                xaxis: {  
                    show: true,  
                    tickSize: 2,  
                    axisLabelUseCanvas: true,  
                    axisLabelFontSizePixels: 12,  
                    axisLabelFontFamily: 'Verdana, Arial',  
                    axisLabelPadding: 10  
      
                },  
                yaxis: {  
                    show: true,  
                    ticks: [[0,'a'],[1,'b'],[2,'c'],[3,'d']],  
                    tickSize: 2,  
                    axisLabelUseCanvas: true,  
                    axisLabelFontSizePixels: 12,  
                    axisLabelFontFamily: 'Verdana, Arial',  
                    axisLabelPadding: 10  
      
                },  
            });  
          
    });  
      
        </script>  
    </head>  
    <body>  
      
        <div style="width:300px;height:300px;text-align:center;margin:10px">          
            <div id="bar1" style="width:100%;height:100%;"></div>          
        </div>  
          
        <div style="width:300px;height:300px;text-align:center;margin:10px">          
            <div id="bar2" style="width:100%;height:100%;"></div>          
        </div>  
          
        <div style="width:300px;height:300px;text-align:center;margin:10px">          
            <div id="bar3" style="width:100%;height:100%;"></div>          
        </div>  
    </body>  
    </html>  