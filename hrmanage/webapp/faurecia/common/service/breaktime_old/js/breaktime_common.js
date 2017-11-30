		$(function(){
			checkTime();
		});
		function classIn(class_id,class_date){
			if(typeof(class_id) == "undefined"||class_id==null||class_id=='')class_id=0;
			var _url = ctx+'/common/classInfo/queryResult.do';
			var param = {};
			param['pageIndex']=1;
			param['pageSize']=1000;	
			param['state']='1';
			ajaxUrl(_url,param,function(json){
				var select_type= "标准班次<br /><select id=\"class_select\">";
				var flag = 0;
				$.each(json.rows, function (n, value) {  
		        	select_type +="<option value=\""+value.id+"\" "+((class_id>0&&class_id==value.id?"selected":(flag==0?"selected":"")))+">"+value.class_name+"</option>";
		        	flag++;
		        });
		        select_type+="</select>";
				$("#class_div").append(select_type);
				select_type="";
				$("#class_select").change(function(){
					if($(this).val().Trim()!=''){
						classInSub($(this),class_date);
					}
				});
				$("#class_select").trigger("change");
			});
		}		
		
		function classInSub(obj,class_date){
			var _url = ctx+'/common/classInfo/queryResult.do';
			var param = {};
			param['pageIndex']=1;
			param['pageSize']=1000;
			param['state']='1';
			param['id']=obj.val();
			ajaxUrl(_url,param,function(json){
				$.each(json.rows, function (n, value) {
		        	$("#class_info_div").html("<Strong>班次日期：</Strong><input style=\"width:80px;height:6px !important;;\" type=\"text\" title=\"班次日期\" readonly=\"readonly\" id=\"class_date\" name=\"class_date\" value=\""+class_date+"\"  onclick=\"wdateInstance2(function(){checkTime();});\"/><br/>&nbsp;&nbsp;&nbsp;"+"<Strong>（运算时系统已扣除用餐时间）</Strong>"+"<br/>"+
		        							  "<Strong>上班时间："+value.begin_time+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
		        							  "<Strong>下班时间："+(addDays(class_date+" "+value.begin_time,(parseFloat(value.hours)+parseFloat(parseInt(value.have_meals)/60))).split(' ')[1])+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
		        							  "<Strong>时长Hour："+value.hours+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
		        							  "<Strong>用餐Hour："+parseFloat(parseInt(value.have_meals)/60)+"</Strong>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;"+
		        							  "<Strong>加班时长："+value.over_hour+"</Strong>");
		        	$("#class_id").val(value.id);
					$("#begin_time").val(value.begin_time);
					$("#end_time").val(addDays(class_date+" "+value.begin_time,(parseFloat(value.hours)+parseFloat(parseInt(value.have_meals)/60))).split(' ')[1]);
					$("#have_meals").val(value.have_meals);
					$("#hours").val(value.hours);
					$("#over_hour").val(value.over_hour);
					$("#begin_date").val($("#class_date").val()+" "+$("#begin_time").val());
					checkTime();
		        });
			});
		}
		
		function checkTime(){
			var t = $('#class_date').val();//班次日期
			var t1 = $('#begin_date').val();//休假开始时间
			var t2 = $('#break_hour').val();//休假小时数
			var t3 = $('#begin_time').val();//上班时间
			var t4 = $('#end_time').val();//下班时间
			var t5 = $('#have_meals').val();//用餐时间 分钟
			var t6 = $('#hours').val();//标准上班时长
			var t8 = $('#over_hour').val();//标准上班时长
			var t7 = $("#type").find("option:selected").attr("lowest_hour");
			if(t!=''&&t1!=''&&t2!=''&&t3!=''&&t4!=''&&t5!=''&&t6!=''&&t8!=''&&t2!='0'){
				var begin_date = parseDate(t1);
				var break_hour = parseFloat(t2);
				var b_hour = parseFloat(t6)+parseFloat(parseInt(t5)/60);//标准时长
				var b_begin_date = parseDate(t+" "+t3);//标准上班时间
				var b_end_date = new Date(b_begin_date.getTime()+getTimeInMillis(b_hour,'h'));//标准下班时间
				
				var lowest_hour = parseFloat(t7);
				
				if(begin_date.getTime()%getTimeInMillis(0.5,'h')!=0){
					showMsgInfo('开始时间格式不符！<br/>必须“hh:00:00”或“hh:30:00”');
					$("#end_date").val('');
				}else if(getTimeInMillis(break_hour,'h')%getTimeInMillis(lowest_hour,'h')!=0){
					showMsgInfo('休假时长最小单位'+lowest_hour+'小时');
					$("#end_date").val('');
				}else{
					break_hour += parseFloat(parseInt(t5)/60);
					if(b_begin_date.getTime()<=begin_date.getTime()&&begin_date.getTime()<b_end_date.getTime()){
						addBreakTimeList();
					}else{
						showMsgInfo('不符合标准班次时间');
						$("#end_date").val('');
					}
				}
			}else{
				$("#end_date").val('');
			}
		
		}

		function addBreakTimeList(){
			var breaktime_list = "breaktime_list";
			if($('#'+breaktime_list).length>0){
				$('#'+breaktime_list).remove();
			}
			$('form').append("<div id='"+breaktime_list+"'><br/><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"stdtable\"><colgroup><col class=\"con0\" /><col class=\"con1\" /><col class=\"con0\" /></colgroup><thead><tr><th class=\"head0\">开始时间</th><th class=\"head1\">结束时间</th><th class=\"head0\">时长</th><th class=\"head1\">班次日期</th></tr></thead><tbody id='breaktime_table_tbody'></tbody></table></div>");
			var begin_date = parseDate($('#begin_date').val());//请假开始时间
			var b_hour = parseFloat($('#hours').val())+parseFloat(parseInt($('#have_meals').val())/60);//标准时长
			var b_begin_time = $("#begin_time").val();
			var b_end_time = $("#end_time").val();
			var break_hour = parseFloat($('#break_hour').val())+parseFloat(parseInt($('#have_meals').val())/60);//请假时数
			var class_date = parseDate($('#class_date').val()+" "+b_begin_time);
			var b_begin_date = class_date;//标准上班时间
			var b_end_date = new Date(b_begin_date.getTime()+getTimeInMillis(b_hour, 'h'));//标准下班时间
			
			b_begin_date = begin_date;//进入运算，把请假起始时间赋值给标准开始时间
			var tmpHour = 0.5;
			var maxEndDate = begin_date;//取每天比标准结束时间内最大的时间/
			var index = 1;var maxVal = {};
			for(var i=0.5;i<=break_hour;i=i+0.5){
				var end_date = new Date(b_begin_date.getTime()+getTimeInMillis(tmpHour, 'h'));
				if(end_date.getTime()<=b_end_date.getTime()){
					if(maxEndDate.getTime()<end_date.getTime()){
						maxEndDate = end_date;
						maxVal[''+index] = "<tr>"+
						"<td>"+b_begin_date.format("yyyy-MM-dd hh:mm:ss")+"</td>"+
						"<td>"+end_date.format("yyyy-MM-dd hh:mm:ss")+"</td>"+
						"<td>"+(tmpHour-parseFloat(parseInt($('#have_meals').val())/60))+"</td>"+//实际显示要减去用餐时长
						"<td>"+(class_date.format("yyyy-MM-dd")+" 00:00:00")+"</td>"+//实际显示要减去用餐时长
						"</tr>";
					}else{
					}
				}else{
					index ++;
					//如果第二天开始要加上用餐时间
					break_hour +=0.5;
					class_date = new Date(class_date.getTime()+getTimeInMillis(1, 'd'));//重置标准class_date
					b_begin_date = class_date;//重置标准开始时间
					b_end_date =  new Date(b_begin_date.getTime()+getTimeInMillis(b_hour, 'h'));//重置标准结束时间
					maxEndDate = class_date;//重置标准结束时间内最大的时间
					
					tmpHour = 0.5;//重置计时器
					//alert(class_date.format("yyyy-MM-dd hh:mm:ss"));
					//alert(b_begin_date.format("yyyy-MM-dd hh:mm:ss"));
					//alert(b_end_date.format("yyyy-MM-dd hh:mm:ss"));
				}
				tmpHour = tmpHour+0.5;
			}
			for(var i=1;i<=index;i++){
				$('form #'+breaktime_list+' #breaktime_table_tbody').append(maxVal[''+i]);
			}
			$("#end_date").val(maxEndDate.format("yyyy-MM-dd hh:mm:ss"));
			
		}
		
		function checkTime_old(){
			var t = $('#class_date').val();//班次日期
			var t1 = $('#begin_date').val();//休假开始时间
			var t2 = $('#break_hour').val();//休假小时数
			var t3 = $('#begin_time').val();//上班时间
			var t4 = $('#end_time').val();//下班时间
			var t5 = $('#have_meals').val();//用餐时间 分钟
			var t6 = $('#hours').val();//标准上班时长
			var t8 = $('#over_hour').val();//标准上班时长
			var t7 = $("#type").find("option:selected").attr("lowest_hour");
			if(t!=''&&t1!=''&&t2!=''&&t3!=''&&t4!=''&&t5!=''&&t6!=''&&t8!=''&&t2!='0'){
				var begin_date = parseDate(t1);
				var break_hour = parseFloat(t2);
				var b_hour = parseFloat(t6)+parseFloat(parseInt(t5)/60);//标准时长
				var b_begin_date = parseDate(t+" "+t3);//标准上班时间
				var b_end_date = new Date(b_begin_date.getTime()+getTimeInMillis(b_hour,'h'));//标准下班时间
				
				var lowest_hour = parseFloat(t7);
				
				if(begin_date.getTime()%getTimeInMillis(0.5,'h')!=0){
					showMsgInfo('开始时间格式不符！<br/>必须“hh:00:00”或“hh:30:00”');
					$("#end_date").val('');
				}else if(getTimeInMillis(break_hour,'h')%getTimeInMillis(lowest_hour,'h')!=0){
					showMsgInfo('休假时长最小单位'+lowest_hour+'小时');
					$("#end_date").val('');
				}else{
					break_hour += parseFloat(parseInt(t5)/60);
					if(b_begin_date.getTime()<=begin_date.getTime()&&begin_date.getTime()<b_end_date.getTime()){
						if(break_hour>0){
							var mod = break_hour%b_hour;
							var days = parseInt(break_hour/b_hour);
							var end_date;
							if(begin_date.getTime()+getTimeInMillis(mod,'h')<=b_end_date.getTime()){
								end_date = new Date(begin_date.getTime()+getTimeInMillis(days,'d')+getTimeInMillis(mod,'h'));
							}else{
								var diff_hour = mod-parseFloat((b_end_date.getTime()-begin_date.getTime())/60/60/1000);
								end_date = new Date(b_begin_date.getTime()+getTimeInMillis(days+1,'d')+getTimeInMillis(diff_hour,'h'));
							}
							$("#end_date").val(end_date.format("yyyy-MM-dd hh:mm:ss"));
							if($("#end_date").val()!=''&&$("#end_date").val().split(" ")[1]==t3){
								$("#end_date").val($("#end_date").val().split(" ")[0]+' '+t4);
							}
							//如果请多天，把用餐时间加上 (n-1)*30,默认30分钟
							var meals = (Math.ceil(parseFloat(t2)/8))*parseInt($('#have_meals').val());
							if(meals>30){
								meals = meals-30;
								$("#end_date").val(new Date(parseDate($("#end_date").val()).getTime()+getTimeInMillis(meals,'m')).format("yyyy-MM-dd hh:mm:ss"));
							}
						}
					}else{
						showMsgInfo('不符合标准班次时间');
						$("#end_date").val('');
					}
				}
			}else{
				$("#end_date").val('');
			}
		}		