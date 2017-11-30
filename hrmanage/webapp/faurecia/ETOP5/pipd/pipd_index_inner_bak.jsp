<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	String begin_month = StringUtils.defaultIfEmpty(request.getParameter("begin_month"), "");
	String end_month = StringUtils.defaultIfEmpty(request.getParameter("end_month"), "");
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_D);
	Calendar cal = Calendar.getInstance();
	if(StringUtils.isEmpty(begin_month)||StringUtils.isEmpty(end_month)){
		end_month = sdf1.format(cal.getTime())+"";
		begin_month = sdf1.format(Util.addDate(cal.getTime(),"m", -6))+"";
	}
%>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/pipd/js/pipd.js"></script>
	<div id="contentwrapper">
		<div class="widgetbox">
			<div class="title">
				<h4>
				Plant Improvement Plan Deployment 
				&nbsp;|&nbsp;
				<%=(begin_month+"~"+end_month)%>&nbsp;月&nbsp;&nbsp;&nbsp;[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="parent.showHtml('${ctx}/faurecia/ETOP5/pipd/data/pipd_data_add.jsp?menu_id=<%=menu_id %>','PlantImprovementPlanDeployment',1024);">&nbsp;+&nbsp;</a>]
				</h4>
			</div>
				
			<div id="pipd_table" class="widgetcontent padding0 statement">
				<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
					<colgroup>
						<col class="con1" />
						<col class="con0" />
						<col class="con1" />
						<col class="con0" />
						<col class="con1" />
						<col class="con0" />
						<col class="con1" />
						<col class="con0" />
						<col class="con1" />
						<col class="con0" />
						<col class="con1" />
					</colgroup>
					<thead>
						<tr>
							<th class="head1" width="6%">
								Item<br/>
<!-- 								<jsp:include page="/share/jsp/screen_full.jsp" /> -->
							</th>
							<th class="head0" width="10%"><%=Global.pip_head[0] %></th>
							<th class="head1" width="10%"><%=Global.pip_head[1] %></th>
							<th class="head0" width="10%"><%=Global.pip_head[2] %></th>
							<th class="head1" width="10%"><%=Global.pip_head[3] %></th>
							<th class="head0" width="9%"><%=Global.pip_head[4] %></th>
							<th class="head1" width="9%"><%=Global.pip_head[5] %></th>
							<th class="head0" width="9%"><%=Global.pip_head[6] %></th>
							<th class="head1" width="9%"><%=Global.pip_head[7] %></th>
							<th class="head0" width="9%"><%=Global.pip_head[8] %></th>
							<th class="head1" width="9%"><%=Global.pip_head[9] %></th>
						</tr>
					</thead>
					<tbody id="tbody_tr_td"></tbody>
				</table>
			</div>
			<!--widgetcontent-->
		</div>
		<!--widgetbox-->
	</div>
	<script src="${ctx }/js/sliphover/jquery.sliphover.min.js"></script>
	<script>
	$(function(){
		load();
	});
	function load(){
		var pip_item = [
			<%for(String v:Global.pip_item){
				out.print("\""+v+"\",");
			}%>
			];
		var pip_column = [
			<%for(String v:Global.pip_head){
				out.print("\""+v+"\",");
			}%>
		];
		$("#contentwrapper table tbody").empty();
		var valForm = $("#contentwrapper table tbody");
		for(var i=0;i<pip_item.length;i++){
			var _td = "<td>"+pip_item[i]+"</td>";
			for(var j=0;j<pip_column.length;j++){
				_td += "<td style=\"padding:1px;margin:1px;\"></td>";
			}
			valForm.append("<tr>"+_td+"</tr>");
		}
		valForm = $("#contentwrapper table tbody tr td");
		$.each(valForm,function(i,v){
			if(i==0||i%(pip_column.length+1)==0){
			}else{
				var type = (pip_item[parseInt(i/(pip_column.length+1))]).replace("<br/>","");
				var sub_type = 	(pip_column[parseInt((i-1)%(pip_column.length+1))]).replace("<br/>","");
				var td_width = $(this).css("width").replace("px","");
				var td_hight = document.body.scrollHeight/9;
				var _title =	(sub_type=='<%=Global.pip_head[0].replace("<br/>","")%>'?
									""
									:
									"<a id='pipdad_"+i+"' type1='"+type+"' type2='"+sub_type+"' onclick='pipd_report_add(this);' style='cursor:pointer;color:white;'>上传</a>&nbsp;"+
									"<a id='pipd_down_"+i+"' onclick='down_pipd_report(this);' style='cursor:pointer;color:white;'>下载</a>&nbsp;<br/>"
									);
								//"<a style='cursor:pointer;color:white;font-size:12px !important;'>选择</a>&nbsp;";
				$(this).append("<div id=\"pipd_div_"+i+"\" style=\"width:"+td_width+"px;height:"+(td_hight)+"px;\">"+
								"<img id=\"img_"+i+"\" ppid_down_file=\"\" src='${ctx }/upload/0cfa9bc2-2793-4300-acca-bc089d332708,0cfa9bc227934300accabc089d332708.gif' width='"+td_width+"' height='"+td_hight+"' title=\""+_title+"\"/>"+
								"</div>");
				
				if(sub_type=='<%=Global.pip_head[0].replace("<br/>","")%>'){
					load_pipd_data("pipd_div_"+i,type,sub_type,'<%=begin_month%>','<%=end_month%>');
				}else{
					load_pipd_report("img_"+i,"pipd_down_"+i,type,sub_type,'<%=begin_month%>','<%=end_month%>');
				}
			
			}
		});
		$('#tbody_tr_td').sliphover({
            height:'100%'
        });	
	}
	function pipd_data_add(obj){
		var type1 = $("#"+obj.id).attr("type1");
		var type2 = $("#"+obj.id).attr("type2");
		parent.showHtml(ctx+"/faurecia/ETOP5/pipd/data/pipd_data_add.jsp?menu_id=<%=menu_id%>&type="+type1+"&sub_type="+type2,"添加",600);
	}
	function pipd_report_add(obj){
		var img_id = "img_"+(obj.id.split("_")[2]);
		var pipd_down_id = "pipd_down_"+(obj.id.split("_")[2]);
		var begin_month = "<%=begin_month%>";
		var end_month = "<%=end_month%>";
		var type1 = $("#"+obj.id).attr("type1");
		var type2 = $("#"+obj.id).attr("type2");
		parent.showHtml(ctx+"/faurecia/ETOP5/pipd/data/pipd_report_add.jsp?"+
						"menu_id=<%=menu_id%>&type="+type1+"&sub_type="+type2+"&img_id="+img_id+"&pipd_down_id="+pipd_down_id+"&begin_month="+begin_month+"&end_month="+end_month,
						"添加",1024);
	}
	</script>
