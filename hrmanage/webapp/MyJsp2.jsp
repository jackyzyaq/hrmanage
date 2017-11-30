<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">    
<html>    
<head>    
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">    
    <title>Flot Examples: Basic Usage</title>  
    <jsp:include page="/common/shareJsp/cartHead.jsp" />  
    
    <!-- 需要引用下面的两个 js 库文件用来显示提示和弹出框 -->    
    
    <script type="text/javascript">    
        var options = {    
            lines: {    
                show: true    
            },    
            points: {    
                show: true    
            },    
            xaxis: {    
                tickDecimals: 0,    
                tickSize: 1    
            },    
            grid: { hoverable: true}// 开启 hoverable 事件    
        };    
    
    $(function() {    
    
        var d1 = [];    
        for (var i = 0; i < 14; i += 0.5) {    
            d1.push([i, Math.sin(i)]);    
        }    
    
        var d2 = { "label": "Europe (EU27)","data":[[0, 3], [4, 8], [8, 5], [9, 13]]};    
    
        // A null signifies separate line segments    
        var d3 = [[0, 12], [7, 12], [7, 2.5], [12, 2.5]];    
    
        // 为图添加数据    
        $.plot("#placeholder", [ d1,d2, d3 ],options);    
    
        // 节点提示    
        function showTooltip(x, y, contents) {    
            $('<div id="tooltip">' + contents + '</div>').css( {    
                position: 'absolute',    
                display: 'none',    
                top: y + 10,    
                left: x + 10,    
                border: '1px solid #fdd',    
                padding: '2px',    
                'background-color': '#dfeffc',    
                opacity: 0.80    
            }).appendTo("body").fadeIn(200);    
        }    
    
        var previousPoint = null;    
        // 绑定提示事件    
        $("#placeholder").bind("plothover", function (event, pos, item) {    
            if (item) {    
                if (previousPoint != item.dataIndex) {    
                    previousPoint = item.dataIndex;    
                    $("#tooltip").remove();    
                    var y = item.datapoint[1].toFixed(0);    
    
                    var tip = "展现量：";    
                    showTooltip(item.pageX, item.pageY,tip+y);    
                }    
            }    
            else {    
                $("#tooltip").remove();    
                previousPoint = null;    
            }    
        });    
    });    
    
    
    
    </script>    
</head>    
<body>    
    
    <div id="header">    
        <h2>Basic Usage</h2>    
    </div>    
    
    <div id="content">    
    
        <div class="demo-container">    
            <div id="placeholder" class="demo-placeholder"></div>    
        </div>    
    
        <p>You don't have to do much to get an attractive plot.  Create a placeholder, make sure it has dimensions (so Flot knows at what size to draw the plot), then call the plot function with your data.</p>    
    
        <p>The axes are automatically scaled.</p>    
    
    </div>    
    
    <div id="footer">    
        Copyright &copy; 2007 - 2014 IOLA and Ole Laursen    
    </div>    
    
</body>    
</html>    