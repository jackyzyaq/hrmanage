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
		$("#kpiactual #dept_name").change(function(){
			if($(this).val().length>0){
				loadKpiType($(this).val());
			}
		});
		$("#kpiactual #kpi_date").focus(function(){
			if($(this).val().length>0){
				loadKpi($("#kpiactual #dept_name").val(),
					$("#kpiactual #kpi_date").val(),
					$("#kpiactual #kpi_type").val()
					);
			}
		});
		$("#kpiactual #kpi_type").change(function(){
			if($(this).val().length>0){
					loadKpi($("#kpiactual #dept_name").val(),
					$("#kpiactual #kpi_date").val(),
					$("#kpiactual #kpi_type").val()
					);
			}
		});
		$("#kpiactual #kpi_type").trigger("change");
		$("#kpiactual #dept_name").trigger("change");
		$("#kpiactual #kpi_date").trigger("focus");
	});
	function loadKpiType(dept_name,kpi_type){
		var _url = ctx+"/faurecia/ETOP5/plant_kpi/data/load_kpi_type.jsp";
		var param = {};
		param['dept_name']=dept_name;
		ajaxUrl(_url,param,function(json){
			$("#kpiactual #kpi_type").empty();
			$("#kpiactual #kpi_type").append("<option value=\"\" selected=\"selected\">---请选择---</option>");
			$.each(json.rows, function (n, value) {
				$("#kpiactual #kpi_type").append("<option value=\""+value.kpi_type+"\">"+value.kpi_type+"</option>");
	        });
	        if(typeof(kpi_type) == "undefined"){
	        }else{
	        	$("#kpiactual #kpi_type").val(kpi_type);
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
			$("#kpiactual #target").val('');
			$.each(json.rows, function (n, value) {
				$("#kpiactual #target").val(value.target);
				$("#kpiactual #ext_3").val(value.ext_3);
				$("#kpiactual #ext_2").val(value.ext_2);
				$("#kpiactual #ext_1").val(value.ext_1);
	        });
		});
	}	
</script>
<form id="plant_kpi_form" class="stdform" onSubmit="return false;">
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
				<td style="font-weight:bold" align="center">日期</td>
				<td>
					<input class="mediuminput" type="text" readonly="readonly" id="kpi_date" title="日期" name="kpi_date" value=""  onfocus="wdateInstance();"/>
					<input type="hidden" name="title" id="title" class="mediuminput" title="标题" value="无"/>
				</td>
				<td style="font-weight:bold" align="center">部门</td>
				<td>
					<select id="dept_name" name="dept_name">
						<option value="" selected="selected">---请选择---</option>
						<%for(PlantKPI pk:listDept){ %>
						<option value="<%=pk.getDept_name()%>"><%=pk.getDept_name()%></option>
						<%} %>
					</select>
				</td>
				<td style="font-weight:bold" align="center">类型</td>
				<td>
					<select id="kpi_type" name="kpi_type">
						<option value="" selected="selected">---请选择---</option>
					</select>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold" align="center">INPUT/OUTPUT</td>
				<td>
					<select id="ext_1" name="ext_1" title="INPUT、OUTPUT" disabled="disabled" >
						<option value="" selected>---请选择---</option>
						<option value="<%=Global.plant_kpi_io[0]%>"><%=Global.plant_kpi_io[0]%></option>
						<option value="<%=Global.plant_kpi_io[1]%>"><%=Global.plant_kpi_io[1]%></option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">正反向</td>
				<td>
					<select id="ext_3" name="ext_3" title="正反向"  disabled="disabled" >
						<option value="" selected>---请选择---</option>
						<option value="正向">正向</option>
						<option value="反向">反向</option>
					</select>
				</td>
				<td style="font-weight:bold" align="center">QCDP</td>
				<td>
					<select id="ext_2" name="ext_2" title="QCDP" disabled="disabled" >
						<option value="" selected>---请选择---</option>
						<%for(String t:Global.plant_kpi_qcdp){ %>
						<option value="<%=t%>"><%=t%></option>
						<%} %>
					</select>
				</td>
			</tr>			
			<tr>
				<td style="font-weight:bold" align="center">TARGET</td>
				<td>
					<input type="text" name="target" id="target" disabled="disabled"  class="mediuminput" title="TARGET" value=""/>
				</td>
				<td style="font-weight:bold" align="center">ACTUAL</td>
				<td>
					<input type="text" name="actual" id="actual"  class="mediuminput" title="ACTUAL" value="0"/>
				</td>
				<td style="font-weight:bold" align="center"></td>
				<td>
				</td>				
			</tr>
            <tr>
            	<td style="font-weight:bold" align="center">备注</td>
				<td colspan="5">
					<textarea rows="4" class="mediuminput" name="remark" id="remark" title="备注"></textarea>
				</td>
            </tr>
            <tr>
				<td colspan="6">
					<input type="hidden" name="cum" id="cum" value="0"/>
					<input type="hidden" name="health_png" id="health_png" value="-"/>
	            	<div class="stdformbutton">
					<button id="plantKPISubmit" class="submit radius2">提交</button>
					</div>
				</td>
            </tr>
        </tbody>
    </table>
</div><!--widgetcontent-->
</form>