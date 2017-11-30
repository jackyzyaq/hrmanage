<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	Map<Integer,MenuInfo> menuInfoMap = (Map<Integer,MenuInfo>)session.getAttribute("menuRole");
	boolean isEdit = false;
	for(Integer key:menuInfoMap.keySet()){ 
    	MenuInfo mi = menuInfoMap.get(key);
    	if(mi.getParent_id().intValue()!=menu_id||!mi.getMenu_code().equals("_etop5_qrci_edit_"))continue;
    	isEdit = true;
    }
%>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/qrci/js/qrci.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/js/etop5.js"></script>
	<div id="contentwrapper">
		<div class="widgetbox">
			<div class="title">
				<h4>
				Plant QRCI Daily Review 
				&nbsp;|&nbsp;
				<%if(isEdit){ %>[<a id="add_data" style="cursor:pointer;font-size:20px;" onclick="add_qrci_task();">&nbsp;+&nbsp;</a>]<%} %>
				</h4>
			</div>
			<jsp:include page="/faurecia/ETOP5/qrci/qrci_search.jsp" />
			<div id="qrci_table" class="widgetcontent padding0 statement">
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
						<col class="con0" />
						<col class="con1" />
						<col class="con0" />
						<col class="con1" />
						<col class="con0" />
					</colgroup>
					<thead>
						<tr>
							<th class="head0" width="6%"><%=Global.qrci_head[0] %></th>
							<th class="head1" width="6%"><%=Global.qrci_head[1] %></th>
							<th class="head0" width="6%"><%=Global.qrci_head[2] %></th>
							<th class="head1" width="6%"><%=Global.qrci_head[3] %></th>
							<th class="head0" width="6%"><%=Global.qrci_head[4] %></th>
							<th class="head1" width="6%"><%=Global.qrci_head[5] %></th>
							<th class="head0" width="6%"><%=Global.qrci_head[6] %></th>
							<th class="head1" width="6%"><%=Global.qrci_head[7] %></th>
							<th class="head0" width="6%"><%=Global.qrci_head[8] %></th>
							<th class="head1" width="6%"><%=Global.qrci_head[9] %></th>
							<th class="head1" width="4%"><%=Global.qrci_head[10] %></th>
							<th class="head1" width="4%"><%=Global.qrci_head[11] %></th>
							<th class="head1" width="5%"><%=Global.qrci_head[12] %></th>
							<th class="head1" width="9%"><%=Global.qrci_head[13] %></th>
							<th class="head1" width="9%"><%=Global.qrci_head[14] %></th>
							<th class="head1" width="9%"><%=Global.qrci_head[15] %></th>
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
		var param = {};
		param['state'] = $("#search #state").val();
		param['pageIndex']=1;
		param['pageSize']=5;
		param['sidx']='open_date';
		param['sord']='desc';
		$("#search #searchBtn").click(function(){
			param['qrci_type'] = $("#search #qrci_type").val();
			param['operater'] = $("#search #operater").val();
			param['state'] = $("#search #state").val();
			load(param);
		});
		load(param);
	});
	function load(param){
		var td_width = 100;
		var td_hight = document.body.scrollHeight/9;
		$("#contentwrapper #qrci_table table tbody").empty();
		var valForm = $("#contentwrapper #qrci_table table tbody");
		
		ajaxUrlFalse(ctx+'/common/qrci/queryResult.do',param,function(json){
			$.each(json.rows, function (n, value) {
				var _td =
						 "<td><a style=\"text-decoration:underline;cursor:pointer;\" onclick=\"edit_qrci_task('"+value.qrci_type.Trim()+"');\">"+value.qrci_type +"</a></td>"+
						 "<td>"+value.open_date +"</td>"+
						 "<td>"+value.problem_descripion +"</td>"+
						 "<td>"+value.respensible +"</td>"+
						 "<td>"+value.yesterday_task_to_be_checked.replaceAll("\\|","<br/>") +"&nbsp;<br/><a style=\"cursor:pointer;\" onclick=\"view_qrci_task('"+value.qrci_type.Trim()+"');\">【查看】</a></td>"+
						 "<td>"+value.task_for_next_day_future.replaceAll("\\|","<br/>") +"</td>"+
						 "<td>"+value.d3_24_hour.replaceAll("\\|","<br/>") +"</td>"+
						 "<td>"+value.d6_10_day.replaceAll("\\|","<br/>") +"</td>"+
						 "<td>"+value.d8_60_day.replaceAll("\\|","<br/>") +"</td>"+
						 "<td>"+value.pfmea +"</td>"+
						 "<td>"+value.cp +"</td>"+
						 "<td>"+value.lls +"</td>"+
						 "<td>"+value.plant_manager +"</td>"+
						 "<td>"+value.lls1_pic +(value.lls1.Trim().length>0?"&nbsp;<br/><a style=\"cursor:pointer;\" onclick=\"down_qrci_report('"+value.lls1.Trim()+"');\">【下载】</a>":"")+"</td>"+
						 "<td>"+value.lls_transversalization_pic +(value.lls_transversalization.Trim().length>0?"&nbsp;<br/><a style=\"cursor:pointer;\" onclick=\"down_qrci_report('"+value.lls_transversalization.Trim()+"');\">【下载】</a>":"")+"</td>"+
						 "<td>"+value.lls_daily_tracking_30_days_pic +(value.lls_daily_tracking_30_days.Trim().length>0?"&nbsp;<br/><a style=\"cursor:pointer;\" onclick=\"down_qrci_report('"+value.lls_daily_tracking_30_days.Trim()+"');\">【下载】</a>":"")+"</td>";
				valForm.append("<tr>"+_td+"</tr>");
			});
		});		

		$('#tbody_tr_td').sliphover({
            height:'100%'
        });	
	}
	function down_qrci_report(obj){
		var upload_uuid = obj;
		if(upload_uuid.Trim().length==0){
		}else{
			click_href(ctx+'/share/jsp/showUploadFile.jsp?upload_uuid='+upload_uuid);
		}
	}
	function view_qrci_task(qrci_type){
		parent.showHtml('${ctx}/faurecia/ETOP5/qrci/data/qrci_task_history.jsp?qrci_type='+qrci_type+'&menu_id=<%=menu_id %>','Yesterday_Task',1024);
	}
	function edit_qrci_task(qrci_type){
		var paramUrl = '${ctx}/faurecia/ETOP5/qrci/data/qrci_data_edit.jsp?qrci_type='+qrci_type+'&menu_id=<%=menu_id %>';
		validateEtopPwd(paramUrl,'Yesterday_Task');
	}
	function add_qrci_task(){
		var paramUrl = '${ctx}/faurecia/ETOP5/qrci/data/qrci_data_add.jsp?menu_id=<%=menu_id %>';
		validateEtopPwd(paramUrl,'PlantImprovementPlanDeployment');
	}
	</script>
