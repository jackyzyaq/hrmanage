$(function(){
	$("#begin_month").click(function(){
		wdateYearMonthInstance('begin_month',function(){
			if($("#begin_month").val().Trim().length>0){
				supplier_ranking_view_inner($("#begin_month").val()+"-01 00:00:00");
			}
		});
	});
});
function ranking_inner(url,params,obj_id){
	inner_html(url,params,obj_id,null);
}

