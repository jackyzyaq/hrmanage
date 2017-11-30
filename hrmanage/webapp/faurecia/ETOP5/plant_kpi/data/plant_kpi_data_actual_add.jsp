<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	int menu_id = Integer.valueOf(StringUtils.defaultIfEmpty(request.getParameter("menu_id"), "0"));
	Calendar cal = Calendar.getInstance();
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	PlantKPIService plantKPIService = (PlantKPIService) ctx.getBean("plantKPIService");
	
	List<PlantKPI> listDept = plantKPIService.queryKPIDept();
%>
<script type="text/javascript">
	$(function(){
		$("#plant_kpi_actual_form #dept_name").change(function(){
			if($(this).val().length>0){
				loadKpiType('plant_kpi_actual_form #kpi_type',$(this).val());
			}
		});
		$("#plant_kpi_actual_form #kpi_date").focus(function(){
			if($(this).val().length>0){
				loadKpi($("#plant_kpi_actual_form #dept_name").val(),
					$("#plant_kpi_actual_form #kpi_date").val(),
					$("#plant_kpi_actual_form #kpi_type").val()
					);
			}
		});
		$("#plant_kpi_actual_form #kpi_type").change(function(){
			if($(this).val().length>0){
					loadKpi($("#plant_kpi_actual_form #dept_name").val(),
					$("#plant_kpi_actual_form #kpi_date").val(),
					$("#plant_kpi_actual_form #kpi_type").val()
					);
			}
		});
		$("#plant_kpi_actual_form #kpi_type").trigger("change");
		$("#plant_kpi_actual_form #dept_name").trigger("change");
		$("#plant_kpi_actual_form #kpi_date").trigger("focus");
	});
	function loadKpiType(obj,dept_name,kpi_type){
		var _url = ctx+"/faurecia/ETOP5/plant_kpi/data/load_kpi_type.jsp";
		var param = {};
		param['dept_name']=dept_name;
		ajaxUrl(_url,param,function(json){
			$("#"+obj).empty();
			$("#"+obj).append("<option value=\"\" selected=\"selected\">---请选择---</option>");
			$.each(json.rows, function (n, value) {
				$("#"+obj).append("<option value=\""+value.kpi_type+"\">"+value.kpi_type+"</option>");
	        });
	        if(typeof(kpi_type) == "undefined"){
	        }else{
	        	$("#"+obj).val(kpi_type);
	        }
		});
	}
	function loadKpi(dept_name,kpi_date,kpi_type){
		var _url = ctx+"/faurecia/ETOP5/plant_kpi/data/load_kpi_object.jsp";
		var param = {};
		param['dept_name']=dept_name;
		param['kpi_date']=kpi_date;
		param['kpi_type']=kpi_type;
		ajaxUrl(_url,param,function(json){
			$("#plant_kpi_actual_form #target").val('');
			$.each(json.rows, function (n, value) {
				$("#plant_kpi_actual_form #target").val(value.target);
				$("#plant_kpi_actual_form #ext_3").val(value.ext_3);
				$("#plant_kpi_actual_form #ext_2").val(value.ext_2);
				$("#plant_kpi_actual_form #ext_1").val(value.ext_1);
				$("#plant_kpi_actual_form #ext_8").val(value.ext_8);
				$("#plant_kpi_actual_form #target_flag").val(value.target_flag);
	        });
		});
		$("#bigTypeInner").empty();
		var params = {};
		params["bigType"]=kpi_type;
		inner_html(ctx+'/share/jsp/kpi_type_ztree.jsp',params,'bigTypeInner');		
	}	
</script>
<form id="plant_kpi_actual_form" class="stdform" onSubmit="return false;">
<div class="widgetcontent padding0 statement">
   <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
        <thead>
            <tr>
                <th class="head1" style="width: 10%"></th>
                <th class="head1" style="width: 25%"></th>
                <th class="head1" style="width: 10%"></th>
                <th class="head1" style="width: 25%"></th>
                <th class="head1" style="width: 10%"></th>
                <th class="head1" style="width: 20%"></th>
            </tr>
        </thead>
        <tbody>
			<tr>
				<td style="font-weight:bold" align="center">Date</td>
				<td>
					<input class="mediuminput" type="text" readonly="readonly" id="kpi_date" title="Date" name="kpi_date" value=""  onfocus="wdateInstance2();"/>
					<input type="hidden" name="title" id="title" class="mediuminput" value="无"/>
				</td>
				<td style="font-weight:bold" align="center">Department</td>
				<td>
					<select id="dept_name" name="dept_name">
						<option value="" selected="selected">---Select---</option>
						<%for(PlantKPI pk:listDept){ %>
						<option value="<%=pk.getDept_name()%>"><%=pk.getDept_name()%></option>
						<%} %>
					</select>
				</td>
				<td style="font-weight:bold" align="center">KPI</td>
				<td>
					<select id="kpi_type" name="kpi_type" style="width:150px;">
						<option value="" selected="selected">---Select---</option>
					</select>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">INPUT/OUTPUT</td>
				<td>
					<select id="ext_1" name="ext_1" title="INPUT、OUTPUT" disabled="disabled" >
<!-- 						<option value="<%=Global.plant_kpi_io[0]%>"><%=Global.plant_kpi_io[0]%></option> -->
						<option value="<%=Global.plant_kpi_io[1]%>" selected><%=Global.plant_kpi_io[1]%></option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">Correct/Opposite</td>
				<td>
					<select id="ext_3" name="ext_3" title="Correct、Opposite"  disabled="disabled" >
						<option value="" selected>---Select---</option>
						<option value="正向">Correct</option>
						<option value="反向">Opposite</option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">QCDPN</td>
				<td>
					<select id="ext_2" name="ext_2" title="QCDP" disabled="disabled" >
						<option value="" selected>---Select---</option>
						<%for(String t:Global.plant_kpi_qcdp){ %>
						<option value="<%=t%>"><%=t%></option>
						<%} %>
					</select>
				</td>
			</tr>			
			<tr>
				<td style="font-weight:bold" align="center">Target</td>
				<td>
					<input type="text" name="target" id="target" disabled="disabled"  class="mediuminput" title="Target" value=""/>
				</td>
				<td style="font-weight:bold" align="center">Actual-Daily</td>
				<td>
					<input type="text" name="actual" id="actual"  class="mediuminput" title="Actual-Daily" value="0"/>
				</td>
				<td style="font-weight:bold" align="center">Actual-Cumulate</td>
				<td>
					<input type="radio" id="is_auto_cum_1"  name="is_auto_cum" value="1" onclick="if($('input:radio[name=is_auto_cum]:checked').val()=='1'){$('#cum').hide();};">Auto
					<input type="radio" id="is_auto_cum_1"  name="is_auto_cum" value="0" checked onclick="if($('input:radio[name=is_auto_cum]:checked').val()=='0'){$('#cum').show();};">Manual
					<input type="text" name="cum" id="cum"  class="smallinput" title="Actual-Cumulate" value="0"/>
				</td>				
			</tr>
			<tr>
            	<td style="font-weight:bold" align="center">Resp</td>
				<td>
					<input class="mediuminput" type="text" id="ext_6" title="Resp" name="ext_6" value="" norequired/>
				</td>
				<td style="font-weight:bold" align="center">Deadline</td>
				<td>
					<input class="mediuminput" type="text" readonly="readonly" id="ext_7" title="Deadline" name="ext_7" value=""  onfocus="wdateInstance2();" norequired/>
				</td>
				<td style="font-weight:bold" align="center">StationNO.</td>
				<td>
					<select id="subtitle" name="subtitle">
						<option value="" selected>---请选择---</option>
						<%for(String s:Global.stationNumberSet){ %>
						<option value="<%=s%>"><%=s%></option>
						<%} %>
					</select>
				</td>
            </tr>
			<tr>
            	<td style="font-weight:bold" align="center">分类原因</td>
				<td colspan="5" id="bigTypeInner"></td>
            </tr>            
            <tr>
            	<td style="font-weight:bold" align="center">Issue Description</td>
				<td>
					<textarea rows="6" class="mediuminput" name="ext_4" id="ext_4" title="Issue Description" norequired></textarea>
				</td>
				<td style="font-weight:bold" align="center">Action Plan</td>
				<td>
					<textarea rows="6" class="mediuminput" name="ext_5" id="ext_5" title="Action Plan" norequired></textarea>
				</td>
				<td></td>
				<td></td>
            </tr>
            <tr>
				<td colspan="6">
					<input type="hidden" name="health_png" id="health_png" value="-"/>
					<input type="hidden" name="ext_8" id="ext_8" value=""/>
					<input type="hidden" name="target_flag" id="target_flag" value=""/>
					<input type="hidden" name="remark" id="remark" value="-"/>
	            	<div class="stdformbutton">
					<button id="plantKPISubmit" class="submit radius2">Submit</button>
					</div>
				</td>
            </tr>
        </tbody>
    </table>
</div><!--widgetcontent-->
</form>