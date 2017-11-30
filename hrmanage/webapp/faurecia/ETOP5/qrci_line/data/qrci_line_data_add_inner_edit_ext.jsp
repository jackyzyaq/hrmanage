<%@page import="com.yq.faurecia.service.DepartmentInfoService"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdfA = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	SimpleDateFormat sdfE = new SimpleDateFormat(Global.DATE_FORMAT_STR_E);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	int qrci_line_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("qrci_line_id"), "0"));
	QRCILineDataService qrciLineDataService = (QRCILineDataService) ctx.getBean("qrciLineDataService");
	List<QRCILineData> list = qrciLineDataService.queryExtByQrciLineId(qrci_line_id);
	int row = (list==null?0:list.size());
%>
<script type="text/javascript">
$(function(){
	<%
	if(row>0){
	for(int i=0;i<row;i++){
		QRCILineData qld = list.get(i);
		System.out.println(StringUtils.defaultIfEmpty(qld.getAction(), ""));
	%>
	add_qrci_ext_inner(<%=i%>);
	$("#qrci_ext_tr_index_<%=i%> #action").val('<%=StringUtils.defaultIfEmpty(qld.getAction(), "")%>');
	$("#qrci_ext_tr_index_<%=i%> #handler").val('<%=StringUtils.defaultIfEmpty(qld.getHandler(), "")%>');
	$("#qrci_ext_tr_index_<%=i%> #deadline").val('<%=Util.convertToString(qld.getDeadline()).replace(" 00:00:00","")%>');
	$("#qrci_ext_tr_index_<%=i%> #is_ok").val('<%=StringUtils.defaultIfEmpty(qld.getIs_ok(), "")%>');
	$("#qrci_ext_tr_index_<%=i%> #class_name").val('<%=StringUtils.defaultIfEmpty(qld.getClass_name(), "")%>');
	$("#qrci_ext_tr_index_<%=i%> #val_date").val('<%=Util.convertToString(qld.getVal_date()).replace(" 00:00:00","")%>');
	$("#qrci_ext_tr_index_<%=i%> #id").val('<%=Util.convertToString(qld.getId())%>');
	<%}}%>
});
function qrci_line_ext_in(qrci_line_ext_id){
	var _url = ctx+'/common/qrci_line/queryResult.do';
	var param = {};
	param['pageIndex']=1;
	param['pageSize']=10;
	param['id']=qrci_lineId;
	ajaxUrl(_url,param,function(json){
		inner_html(ctx+'/faurecia/ETOP5/qrci_line/data/qrci_line_data_add_inner_edit.jsp',null,null,function(data){
			$("#qrci_line_edit").html(data);
			inner_html(ctx+'/faurecia/ETOP5/qrci_line/data/qrci_line_data_add_inner_edit_ext.jsp?qrci_line_id='+qrci_lineId,null,null,function(data1){
				$("#qrci_line_edit_ext").html(data1);
				$.each(json.rows, function (n, value) {
					$.each(value, function(k, v){
						if(k=='dept_id'){
							$("#requestParam_dept_id").val(v);
						}else{
							$("#"+k).val(v);
						}
					});
		        });
		        $('#tabs-a-1').attr("onclick","loadTab('tabs-1')");
			});
		});
	});
}	


function add_qrci_ext(){
	var row=$("#qrci_line_ext_table table").length;
	add_qrci_ext_inner(row);
}

function add_qrci_ext_inner(currentRows){
	var _ext_id="qrci_ext_tr_index_"+currentRows+"";
	var _ext_tr="<tr id='"+_ext_id+"'><td><table cellpadding='0' cellspacing='0' border='0' class='stdtable' width='100%'><thead><tr><th class='head1' style='width: 16%'><a style='cursor:pointer;' tr_id='"+_ext_id+"' onclick='del_qrci_ext(this);'>【删除】</a></th><th class='head1' style='width: 16%'></th><th class='head1' style='width: 17%'></th><th class='head1' style='width: 17%'></th><th class='head1' style='width: 17%'></th><th class='head1' style='width: 17%'></th></tr></thead><tr><td style='font-weight:bold' align='center'>行动措施</td><td><input class='longinput' type='text' id='action' title='行动措施' name='action' value=''/></td><td style='font-weight:bold' align='center'>责任人</td><td><input class='longinput' type='text' id='handler' title='责任人' name='handler' value=''/></td><td style='font-weight:bold' align='center'>日期</td><td><input class='longinput' type='text' readonly='readonly' id='deadline' title='日期' name='deadline' value='<%=sdfA.format(cal.getTime()) %>' onclick='wdateInstance2()'/></td></tr><tr><td style='font-weight:bold' align='center'>OK、NOK</td><td><input class='longinput' type='text' id='is_ok' title='OK、NOK' name='is_ok' value=''/></td><td style='font-weight:bold' align='center'>班次</td><td><input class='longinput' type='text' id='class_name' title='班次' name='class_name' value=''/></td><td style='font-weight:bold' align='center'>验证日期</td><td><input class='longinput' type='text' readonly='readonly' id='val_date' title='验证日期' name='val_date' value='<%=sdfA.format(cal.getTime()) %>' onclick='wdateInstance2()'/><input type='hidden' id='qrci_line_id' name='qrci_line_id' value='<%=qrci_line_id%>'/><input type='hidden' id='id' name='id' value='0'/></td></tr><tr><td style='font-weight:bold' align='left' colspan='6'><div class='stdformbutton' style='padding: 5px'><button class='submit radius1' tr_id='"+_ext_id+"' onclick='qrciLineDataAddExt(this);'>保存</button></div></td></tr></table></td></tr>";
	if($("#qrci_line_ext_table").text().Trim().length==0){
		$("#qrci_line_ext_table").html(_ext_tr);
	}else{
		$("#qrci_line_ext_table tr:eq(0)").after(_ext_tr);
	}
}
function del_qrci_ext(obj){
	$("#"+$(obj).attr("tr_id")).remove();
}
function qrciLineDataAddExt(obj){
	var _ext_id=$(obj).attr("tr_id");
	if(validateForm(_ext_id)){
		if (confirm('是否提交？')) {
			var param = getParamsJson(_ext_id);
			param['deadline']=param['deadline']+' 00:00:00';
			param['val_date']=param['val_date']+' 00:00:00';
			ajaxUrl(ctx+'/common/qrci_line/qrciLineDataExtAdd.do',param,function(json){
				showMsgInfo(json.msg+'');
				parentQuery();
			});
		}
	}
}
</script>
<div class="widgetcontent padding0 statement">
   <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
        <thead>
            <tr>
                <th class="head1" style="width: 100%"><a style="cursor:pointer;" onclick="add_qrci_ext();">【增加行】</a></th>
            </tr>
        </thead>
        <tbody id="qrci_line_ext_table">
			
        </tbody>
    </table>
</div><!--widgetcontent-->
