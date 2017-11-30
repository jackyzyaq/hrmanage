		$(function(){
				$('#contentwrapper #submit').click(function(){
					if (confirm('是否提交？')) {
						var param = getHolidayParams();
						ajaxUrl(ctx+'/common/nationalHoliday/nationalHolidayAdd.do',param,'_national_holiday_');
					}
				});
				
				$('#searchUser #searchBtn').click(function(){
					queryResult();
				});			
		});
		function _national_holiday_(json){
		    if(json.msg!=''){
		    	showInfo(json.msg);
			}else{
			}
		    showDays();
		}
		function getHolidayParams(){
			var date = "",date_name="";
			$("#dates-table td").each(function(){
     			if($(this).find("input").attr("checked")){
     				date_name +=$(this).find("select").val()+' ,';
     				date += $(this).find("input").val()+',';
   				} else {
   				}
			});
			var param = {};
			param["holiday_names"]=date_name;
			param["holidays"]=date.Trim();
			return param;
		}
		
