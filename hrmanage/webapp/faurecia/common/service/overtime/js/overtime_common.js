		$(function(){
			checkTime();
		});
		function checkTime(){
			var t1 = $('#begin_date').val();//开始时间
			var t2 = $('#over_hour').val();//小时数
			var t3 = $("#day_or_hour").val();
			if(t1!=''&&t2!=''&&t3!=''){
				var begin_date = parseDate(t1);
				var over_hour = parseFloat(t2);
				var b_hour = 8;//标准时长
				var lowest_hour = 0.0;
				if(t3.indexOf('day')>-1){
					lowest_hour = 8.0;
				}else{
					lowest_hour = 0.5;
				}
				if(over_hour<0){
					showMsgInfo('加班时长应大于零');
					$("#end_date").val('');
				}else if(begin_date.getTime()%getTimeInMillis(lowest_hour,'h')!=0){
					showMsgInfo('开始时间格式不符！<br/>必须“hh:00:00”或“hh:30:00”');
					$("#end_date").val('');
				}else if(getTimeInMillis(over_hour,'h')%getTimeInMillis(lowest_hour,'h')!=0){
					showMsgInfo('加班时长最小单位'+lowest_hour+'小时');
					$("#end_date").val('');
				}else{
					var days = parseInt(over_hour/b_hour);
					if(t3.indexOf('day')>-1){
						end_date = new Date(begin_date.getTime()+getTimeInMillis(days-1,'d'));
						$("#end_date").val(end_date.format("yyyy-MM-dd")+" 16:30:00");
						$("#begin_date").val(begin_date.format("yyyy-MM-dd")+" 08:00:00");
						addOverTimeDayList();
					}else{
						end_date = new Date(begin_date.getTime()+getTimeInMillis(over_hour,'h'));
						$("#end_date").val(end_date.format("yyyy-MM-dd hh:mm:ss"));
						addOverTimeHourList();
					}
				}
			}
		}		
		function addOverTimeHourList(){
			var overtime_list = "overtime_list";
			if($('#'+overtime_list).length>0){
				$('#'+overtime_list).remove();
			}
			$('form').append("<div id='"+overtime_list+"'><br/><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"stdtable\"><colgroup><col class=\"con0\" /><col class=\"con1\" /><col class=\"con0\" /></colgroup><thead><tr><th class=\"head0\">开始时间</th><th class=\"head1\">结束时间</th><th class=\"head0\">加班时长</th></tr></thead><tbody id='overtime_table_tbody'></tbody></table></div>");
			var begin_date = parseDate($('#begin_date').val());//加班开始时间
			var over_hour = parseFloat($('#over_hour').val());//加班时数
			
			var b_end_date = new Date(parseDate(begin_date.format("yyyy-MM-dd hh:mm:ss").split(' ')[0]+' 00:00:00').getTime()+getTimeInMillis(1, 'd'));//每天23：59：59
			
			var tmpHour = 0.5;
			var maxEndDate = begin_date;//取每天比标准结束时间内最大的时间/
			var index = 1;var maxVal = {};
			for(var i=0.5;i<=over_hour;i=i+0.5){
				var end_date = new Date(begin_date.getTime()+getTimeInMillis(tmpHour, 'h'));
				if(end_date.getTime()<=b_end_date.getTime()){
					if(maxEndDate.getTime()<end_date.getTime()){
						maxEndDate = end_date;
						maxVal[''+index] = "<tr>"+
						"<td>"+begin_date.format("yyyy-MM-dd hh:mm:ss")+"</td>"+
						"<td>"+end_date.format("yyyy-MM-dd hh:mm:ss")+"</td>"+
						"<td>"+(tmpHour)+"</td>"+
						"</tr>";
					}else{
					}
					tmpHour = tmpHour+0.5;
				}else{
					index ++;
					over_hour = over_hour+0.5;//当
					begin_date = b_end_date;//重置
					b_end_date =  new Date(b_end_date.getTime()+getTimeInMillis(1, 'd'));
					maxEndDate = begin_date;//重置标准结束时间内最大的时间
					tmpHour = 0.5;//重置计时器
				}
			}
			for(var i=1;i<=index;i++){
				$('form #'+overtime_list+' #overtime_table_tbody').append(maxVal[''+i]);
			}
			//$("#end_date").val(maxEndDate.format("yyyy-MM-dd hh:mm:ss"));
		
		}
		function addOverTimeDayList(){
			var overtime_list = "overtime_list";
			if($('#'+overtime_list).length>0){
				$('#'+overtime_list).remove();
			}
			$('form').append("<div id='"+overtime_list+"'><br/><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"stdtable\"><colgroup><col class=\"con0\" /><col class=\"con1\" /><col class=\"con0\" /></colgroup><thead><tr><th class=\"head0\">开始时间</th><th class=\"head1\">结束时间</th><th class=\"head0\">加班时长</th></tr></thead><tbody id='overtime_table_tbody'></tbody></table></div>");
			var begin_date = parseDate($('#begin_date').val());//加班开始时间
			var over_hour = parseFloat($('#over_hour').val())+parseFloat($('#over_hour').val())*0.5;//加班时数
			var b_hour = 8.5;
			
			var index = 1;var maxVal = {};
			for(var i=b_hour;i<=over_hour;i=i+b_hour){
				var end_date = new Date(begin_date.getTime()+getTimeInMillis(b_hour, 'h'));
				maxVal[''+index] = 
					"<tr>"+
					"<td>"+begin_date.format("yyyy-MM-dd hh:mm:ss")+"</td>"+
					"<td>"+end_date.format("yyyy-MM-dd hh:mm:ss")+"</td>"+
					"<td>"+(b_hour-0.5)+"</td>"+
					"</tr>";
				index ++;
				begin_date = new Date(begin_date.getTime()+getTimeInMillis(1, 'd'));
			}
			for(var i=1;i<=index;i++){
				$('form #'+overtime_list+' #overtime_table_tbody').append(maxVal[''+i]);
			}
			//$("#end_date").val(maxEndDate.format("yyyy-MM-dd hh:mm:ss"));
		
		}