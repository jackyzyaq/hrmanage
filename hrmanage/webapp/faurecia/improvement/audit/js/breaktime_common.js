		$(function(){
			$("#upload_uuid").attr("norequired","norequired");
			$("#day_or_hour").change(function(){
				if($(this).val()=='day'){
					$("#day_hour_span_id").html("天");
				}else{
					$("#day_hour_span_id").html("小时");
				}
				$("#start_date").val('');
				$("#break_hour").val('');
			});
			$("#start_date").click(function(){
				if($("#day_or_hour").val().indexOf('day')>-1){
					WdatePicker({startDate:'%y-%M-%d',dateFmt:'yyyy-MM-dd',alwaysUseStartDate:true});
					$("#break_hour").val('1');
				}else{
					WdatePicker({startDate:'%y-%M-%d 16:30:00',dateFmt:'yyyy-MM-dd HH:mm:00',alwaysUseStartDate:true});
					$("#break_hour").val('0.5');
				}
			});
		});
			
		
		function checkTime(){
			var t1 = $('#start_date').val();//休假开始时间
			var t2 = $('#break_hour').val();//休假小时数
			if(t1!=''&&t2!=''){
				var start_date = parseDate(t1);
				var break_hour = parseFloat(t2);
				if(break_hour==0){
					showMsgInfo('时长不能为0！<br/>');
				}else if(start_date.getTime()%getTimeInMillis(0.5,'h')!=0){
					showMsgInfo('开始时间格式不符！<br/>必须“hh:00:00”或“hh:30:00”');
				}else{
					var t7='0';
					if($("#day_or_hour").find("option:selected").val()=='day'){
						t7='1';
						var lowest_hour = parseFloat(t7);
						if(getTimeInMillis(break_hour,'d')%getTimeInMillis(lowest_hour,'d')!=0){
							showMsgInfo('休假时长最小单位'+lowest_hour+'天');
							return false;
						}
					}else{
						t7=$("#type").find("option:selected").attr("lowest_hour");
						var lowest_hour = parseFloat(t7);
						if(getTimeInMillis(break_hour,'h')%getTimeInMillis(lowest_hour,'h')!=0){
							showMsgInfo('休假时长最小单位'+lowest_hour+'小时');
							return false;
						}
					}
					//提交前验证
					var param = getParamsJson("contentwrapper");
					param['emp_ids'] = param['emp_id'];
					param['emp_id']=0;
					ajaxUrl(ctx+'/common/serviceWeb/breakTimeBefareAdd.do',param,function(json){
						if(json.flag=='1'){
							addBreakTimeList(json);
						}else{
							showMsgInfo(json.msg+'');
						}
					});
				}
			}else{
				showMsgInfo('栏位不能为空！');
			}
		}

		function addBreakTimeList(json){
			var breaktime_list = "breaktime_list";
			if($('#'+breaktime_list).length>0){
				$('#'+breaktime_list).remove();
			}
			$('form').append("<div id='"+breaktime_list+"'><br/><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"stdtable\"><colgroup><col class=\"con0\" /><col class=\"con1\" /><col class=\"con0\" /></colgroup><thead><tr><th class=\"head0\">员工</th><th class=\"head0\">开始时间</th><th class=\"head1\">结束时间</th><th class=\"head0\">时长</th><th class=\"head1\">归属日期</th><th class=\"head1\">标准下班时间</th><th class=\"head1\">排班结束时间</th></tr></thead><tbody id='breaktime_table_tbody'></tbody></table></div>");
			$.each(json.emp_rows, function (n, value) {
				$.each(value.breaktime_rows, function (n1, value1) {
					var tr_td = '';
					if(value1.msg==''){
						tr_td = 
								"<tr>"+
								"<td style='display:none'>"+value1.class_id+"</td>"+
								"<td style='display:none'>"+value1.schedule_id+"</td>"+
								"<td style='display:none'>"+value.emp_id+"</td>"+
								"<td>"+value.emp_name+"</td>"+
								"<td>"+value1.start_date+"</td>"+
								"<td>"+value1.over_date+"</td>"+
								"<td>"+(value1.break_hour)+"</td>"+
								"<td>"+(value1.class_date)+"</td>"+
								"<td>"+(value1.b_end_date)+"</td>"+
								"<td>"+(value1.end_date)+"</td>"+
								"<td style='display:none'>"+value1.b_begin_date+"</td>"+
								"</tr>";
					}else{
						tr_td = "<tr><td colspan='11'>"+value.emp_name+"---"+value1.msg+"</td></td>";
					}
					if(typeof($("#id").val()) == "undefined"){
						$('form #'+breaktime_list+' #breaktime_table_tbody').append(tr_td);
					}else if(parseInt($("#id").val().Trim())>0){
						if(n1==0)$('form #'+breaktime_list+' #breaktime_table_tbody').append(tr_td);
					}
				});
			}); 
			if(typeof($("#id").val()) == "undefined"){
				$('form #'+breaktime_list+' #breaktime_table_tbody').append("<tr><td colspan='10'><button id=\"submit\" class=\"submit radius2\" onclick=\"submitClick();\">提交</button></td></td>");
			}else if(parseInt($("#id").val().Trim())>0){
				$('form #'+breaktime_list+' #breaktime_table_tbody').append("<tr><td colspan='10'><button id=\"submit\" class=\"submit radius2\" onclick=\"editSubmitClick();\">提交</button></td></td>");
			}
		}