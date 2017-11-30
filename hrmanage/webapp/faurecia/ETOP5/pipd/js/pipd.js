	/**
	 * 
	 * @param pipd_div_id 对象id
	 * @param begin_month 2016-01
	 * @param end_month 2016-07
	 */
	function load_pipd_data(pipd_div_id,type,sub_type,begin_month,end_month){
		var d1 = [],d2 = [];
		var param = {};
		param['start_date'] = begin_month+"-01 00:00:00";
		param['over_date'] = end_month+"-01 00:00:00";
		param['type'] = type;
		param['sub_type'] = sub_type;
		param['state'] = 1;
		param['pageIndex']=1;
		param['pageSize']=1000;
		param['sidx']='report_date';
		param['sord']='asc';
		ajaxUrlFalse(ctx+'/common/pipd/queryResult.do',param,function(json){
			$.each(json.rows, function (n, value) {
					//var title = $("#"+img_id).attr("title");//
					d1.push([parseInt(value.report_date.split("-")[1]), parseFloat(value.must_pipd_data)]);//达标值
					d2.push([parseInt(value.report_date.split("-")[1]), parseFloat(value.reality_pipd_data)]);//实际值
			   });
		});	
	
		var dataset = [{
			//label: "实际值",
	        data: d2,         
	        color: "#756600",
	        bars: {
	            show: true, 
	            align: "center",
	            barWidth: 0.6,
	            lineWidth:1
	        }
	    }, {
	    	//label: "达标值",
	        data: d1,
	        color: "#0062FF",
	        points: {fillColor: "#0062FF", show: true },
	        lines: {show:true,fill: false, steps: false}
	    }];

		var isShow = (parseInt($("#"+pipd_div_id).css('height').replace("px",""))>100?true:false);
		$.plot($("#"+pipd_div_id), dataset, {
			xaxis: { show: isShow,ticks: d1.length,
                tickFormatter: function(axis) {
                    return axis.toString().replace('.0','');
                }	
			},
			yaxis: { show: true,ticks: 4},
			grid: { hoverable: true, clickable: true, borderColor: '#ccc', borderWidth: 1, labelMargin: 10 },
			colors: ["#069"]
		});
		
		$("#"+pipd_div_id).bind("plothover", function (event, pos, item) {
			$("#x").text(pos.x.toFixed(2));
			$("#y").text(pos.y.toFixed(2));
			
			if(item) {
				if (previousPoint != item.dataIndex) {
					previousPoint = item.dataIndex;
						
					$("#tooltip").remove();
					var x = item.datapoint[0].toFixed(2),
						y = item.datapoint[1].toFixed(2);
					showTooltip(item.pageX, item.pageY,
								(item.series.color=='#0062FF'?"达标值":"实际值") + " : " + x.replace('.00','') + "月： " + y);
				}
			
			} else {
			   $("#tooltip").remove();
			   previousPoint = null;            
			}
		
		});
	}

	function showTooltip(x, y, contents) {
		$('<div id="tooltip" class="tooltipflot">' + contents + '</div>').css( {
			position: 'absolute',
			display: 'none',
			top: y + 5,
			left: x + 5
		}).appendTo("body").fadeIn(200);
	}
	
	function load_pipd_report(img_id,ppid_down_id,type,sub_type,begin_month,end_month){
		var param = {};
		param['begin_month'] = begin_month+"-01 00:00:00";
		param['end_month'] = end_month+"-01 00:00:00";
		param['type'] = type;
		param['sub_type'] = sub_type;
		param['state'] = 1;
		ajaxUrlFalse(ctx+'/common/pipdReport/queryResult.do',param,function(json){
			$.each(json.rows, function (n, value) {
					//var title = $("#"+img_id).attr("title");//
					$("#"+img_id).attr("src",ctx+"/share/jsp/showImage.jsp?file="+value.upload_uuid_pic);
					$("#"+img_id).attr("ppid_down_file",value.upload_uuid);
			   });
		});
	}
	
	function down_pipd_report(obj){
		var img_id = "img_"+(obj.id.split("_")[2]);
		var upload_uuid = $("#"+img_id).attr("ppid_down_file");
		if(upload_uuid.Trim().length==0){
		}else{
			click_href(ctx+'/share/jsp/showUploadFile.jsp?upload_uuid='+upload_uuid);
		}
	}	