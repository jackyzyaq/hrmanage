	function load_kpi_data(kpi_div_id,day_or_month,d1,d2,d3,content,colors,unit){
		var stack = 0, bars = true, lines = true, steps = false;
		$.plot($("#"+kpi_div_id+""), [ 
			{data:d2,color: colors[0],bars:  {show: true,   align: "center", barWidth: 0.6,  lineWidth:1,numbers: {show:true,numberFormatter: function(v, bar) {return '<div class="pimp-my-number-class">'+ v +'</div>';}}}},//"达标"
			{data:d3,color: colors[1],bars:  {show: true,   align: "center", barWidth: 0.6,  lineWidth:1,numbers: {show:true,numberFormatter: function(v, bar) {return '<div class="pimp-my-number-class">'+ v +'</div>';}}}},//"未达标"
			{data:d1,color: colors[2],//bars:  {show: true,   align: "center", barWidth: 0.6,  lineWidth:1}}
				lines: {show:true,fill: false, steps: false},points: {fillColor: colors[2], show: true }} 
			],//"Target" 
		{
			yaxis: { show: true,ticks: 4,tickColor:'#fff',min: 0},
			xaxis: {
              show: true,
              //position: 'left',
              //color: '#ccc',
              //tickColor: '#fff',
              ticks: d1.length,
              tickSize: 1,
              tickLength: 1,
              tickColor:'#fff',
              axisLabelUseCanvas: true,
              axisLabelFontSizePixels: 12,
              axisLabelFontFamily: 'Verdana, Arial',  
              axisLabelPadding: 10,
              tickFormatter: function(axis) {
                  return axis.toString().replace('.0','');
              }	
			},  
			series: {
				stack: true
				//lines: { show: lines, fill: false, steps: steps },
				//bars: { show: bars, barWidth: 0.6 }
			},
			grid: { show:true,hoverable: true, clickable: true, borderColor: '#ccc', borderWidth: 1, labelMargin: 10 }
			//colors: ["#069"]
		});
		
		$("#"+kpi_div_id).bind("plothover", function (event, pos, item) {
			$("#x").text(pos.x.toFixed(1));
			$("#y").text(pos.y.toFixed(1));
			if(item) {
				$("#tooltip").remove();
				var x = item.datapoint[0].toFixed(1),
				y = item.datapoint[1].toFixed(1);
				showTooltip(item.pageX, item.pageY,
								//item.series.label + " of " + x + " = " + y+"---"
						(item.datapoint[1].toFixed(1)+unit)
				);
			} else {
			   $("#tooltip").remove();
			}
		});
	}
	
	function showTooltip(x, y, contents) {
		$('<div id="tooltip">' + contents + '</div>').css( {
			position: 'absolute',
			display: 'none',
			top: y + 15,
			left: x + 15
		}).appendTo("body").fadeIn(200);
	}
