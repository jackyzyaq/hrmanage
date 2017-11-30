function getEndMonthFn(){
	if($("#begin_month").val().Trim().length>0){
		var newDate = DateAdd("m ", 1, parseDate($("#begin_month").val()+"-01"));
		$("#end_month").val(newDate.format("yyyy-MM"));
	}
}

function getEndMonthFn1(){
	if($("#begin_month").val().Trim().length>0){
		var newDate = DateAdd("m ", 2, parseDate($("#begin_month").val()+"-01"));
		$("#end_month").val(newDate.format("yyyy-MM"));
	}
}