	function load_kpi_data(kpi_div_id,day_or_month,d1,d2,d3,content){
		var count = (day_or_month=='m'?12:31);
		var dataset = [{
	    	label: "目标",
	        data: d1,
	        color: "#2828FF",
	        points: {fillColor: "#2828FF", show: true },
	        lines: {show:true,fill: false, steps: false}
	    }, {
			label: "达标",
	        data: d2,         
	        color: "#9ACD32",
	        points: {fillColor: "#9ACD32", show: true },
	        lines: {show:true,fill: false, steps: false}
	    }
	    , {
	    	label: "未达标",
	        data: d3,
	        color: "#CD4F39",
	        points: {fillColor: "#CD4F39", show: true },
	        lines: {show:true,fill: false, steps: false}
	    }
	    ];

		var isShow = (parseInt($("#"+kpi_div_id).css('height').replace("px",""))>100?true:false);
		$.plot($("#"+kpi_div_id), dataset, {
			xaxis: { show: isShow,ticks: d1.length,
                tickFormatter: function(axis) {
                    return axis.toString().replace('.0','');
                }	
			},
			yaxis: { show: true,ticks: 4},
			grid: { hoverable: true, clickable: true, borderColor: '#ccc', borderWidth: 1, labelMargin: 10 },
			colors: ["#069"]
		});
		if(day_or_month=='m'){
		}else{
			var previousPoint = null;
			$("#"+kpi_div_id).bind("plothover", function (event, pos, item) {
				$("#x").text(pos.x.toFixed(2));
				$("#y").text(pos.y.toFixed(2));
				if(item) {
					if (previousPoint != item.dataIndex) {
						previousPoint = item.dataIndex;
						$("#tooltip").remove();
						var x = item.datapoint[0].toFixed(2),
						y = item.datapoint[1].toFixed(2);
						showTooltip(item.pageX, item.pageY,
										//item.series.label + " of " + x + " = " + y+"---"
								((typeof(content) == "undefined")?"":content[pos.x.toFixed(0)+''])
						);
					}
				} else {
				   $("#tooltip").remove();
				   previousPoint = null;            
				}
			});
		}
	}
	
	function showTooltip(x, y, contents) {
		$('<div id="tooltip">' + contents + '</div>').css( {
			position: 'absolute',
			display: 'none',
			top: y + 5,
			left: x + 5
		}).appendTo("body").fadeIn(200);
	}
	
	
	function load_kpi_data_1(kpi_div_id,day_or_month){
		var count = (day_or_month=='m'?12:31);
		var d1 = [];
		for (var i = 1; i <= count; i += 1)
			d1.push([i, Math.random()]);
			
		
		var d2 = [];
		for (var i = 1; i <= count; i += 1)
			d2.push([i, Math.random()]);
		
		var d3 = [];
		for (var i = 1; i <= count; i += 1)
			d3.push([i, Math.random()]);
			
		var dataset = [{
	    	//label: "达标值",
	        data: d1,
	        color: "#228B22",
	        points: {fillColor: "#228B22", show: true },
	        lines: {show:true,fill: false, steps: false}
	    }, {
			//label: "实际值",
	        data: d2,         
	        color: "#FF6347",
	        points: {fillColor: "#FF6347", show: true },
	        lines: {show:true,fill: false, steps: false}
	    }, {
	    	//label: "CUM.",
	        data: d3,
	        color: "#CD4F39",
	        points: {fillColor: "#CD4F39", show: true },
	        lines: {show:true,fill: false, steps: false}
	    }];

		var isShow = (parseInt($("#"+kpi_div_id).css('height').replace("px",""))>100?true:false);
		$.plot($("#"+kpi_div_id), dataset, {
			xaxis: { show: isShow,ticks: d1.length,
                tickFormatter: function(axis) {
                    return axis.toString().replace('.0','');
                }	
			},
			yaxis: { show: true,ticks: 4},
			grid: { hoverable: true, clickable: true, borderColor: '#ccc', borderWidth: 1, labelMargin: 10 },
			colors: ["#069"]
		});	
	}