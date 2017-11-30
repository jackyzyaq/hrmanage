<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script src='${ctx }/js/echarts/doc/slide/js/dist/echarts.js'></script>
<script type="text/javascript">
	$(function(){
		require.config({
            paths: {
                echarts: '${ctx }/js/echarts/doc/slide/js/dist'
            }
        });
        
        // 使用
        require(
            [
                'echarts',
                'echarts/chart/bar',
                'echarts/chart/line'
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('handle_chart')); 
                var ecConfig = require('echarts/config'); 
				option = {
				    tooltip : {
				        trigger: 'axis'
				    },
				    toolbox: {
				        show : true,
				        feature : {
				            mark : {show: true},
				            dataView : {show: true, readOnly: false},
				            magicType: {show: true, type: ['line', 'bar']},
				            restore : {show: true},
				            saveAsImage : {show: true}
				        }
				    },
				    calculable : true,
				    //legend: {
				    //    data:['蒸发量','降水量','平均温度']
				    //},
				    xAxis : [
				        {
				        	boundaryGap : false,
			            	splitLine : {
				                show:false,
				                lineStyle: {
				                    color: '#483d8b',
				                    type: 'dashed',
				                    width: 1
				                }
			            	},
				        	//splitArea : {show : false},//保留网格区域
				            type : 'category',
				            data : ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
				        }
				    ],
				    yAxis : [
				        {
				        	//splitArea : {show : false},//保留网格区域
				            type : 'value',
				            name : '水量',
				            splitLine : {//去除网格线
				                show:false,
				                lineStyle: {
				                    color: '#483d8b',
				                    type: 'dashed',
				                    width: 1
				                }
				            },
				            axisLabel : {
				                formatter: '{value} ml'
				            }
				        },
				        {
				            type : 'value',
				            name : '温度',
				            splitLine : {//去除网格线
				                show:false,
				                lineStyle: {
				                    color: '#483d8b',
				                    type: 'dashed',
				                    width: 1
				                }
				            },
				            axisLabel : {
				                formatter: '{value} °C'
				            }
				        }
				    ],
				    grid:{
				   	 	borderWidth:1,
				    	borderColor:'#000'
				    },
				    series : [
				        {
				            name:'降水量',
				            type:'bar',
				            itemStyle:{ normal: {label : {show: true}}},
				            data:[2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3]
				        },
				        {
				            name:'平均温度',
				            type:'line',
				            yAxisIndex: 1,
				            itemStyle:{ normal: {label : {show: true}}},
				            data:[2.0, 2.2, 3.3, 4.5, 6.3, 10.2, 20.3, 23.4, 23.0, 16.5, 12.0, 6.2]
				        }
				    ]
				};
                // 为echarts对象加载数据 
                myChart.setOption(option); 
            }
        );	
	});

</script>
</head>
<body>
    <div id="handle_chart" style="height:350px">
    	<div style="text-align:center;padding-top:100px;">
			<img src="${ctx }/img/load.gif"/>
		</div>
    </div>
</body>
</html>
