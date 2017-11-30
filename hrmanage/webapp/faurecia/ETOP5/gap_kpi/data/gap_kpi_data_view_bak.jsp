<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.company.etop5.pojo.*"%>
<%@ page import="com.yq.company.etop5.service.*"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat(Global.DATE_FORMAT_STR_B);
	SimpleDateFormat sdf1 = new SimpleDateFormat(Global.DATE_FORMAT_STR_A);
	
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	GapKPIService gapKPIService = (GapKPIService) ctx.getBean("gapKPIService");
%>
		<div class="widgetbox">
			<div>
			    <div class="widgetcontent padding0 statement">
			       <table cellpadding="0" cellspacing="0" border="0" class="stdtable">
			            <colgroup>
			                <col class="con0" />
			                <col class="con1" />
			                <col class="con0" />
			            </colgroup>
			            <thead>
			                <tr>
			                    <th class="head0" style="width:10%">类型&nbsp;&nbsp;&nbsp;<span title="更多" style="cursor:pointer;" onclick="loadKPIList();">>></span>&nbsp;&nbsp;&nbsp;</th>
			                    <th class="head0" style="width:10%">日期&nbsp;&nbsp;&nbsp;<span title="导出" style="cursor:pointer;" onclick="exportKPIList();">>></span>&nbsp;&nbsp;&nbsp;</th>
			                    <th class="head0" style="width:10%">部门</th>
			                    <th class="head0" style="width:6%">Input Or<br/>Output</th>
			                    <th class="head0" style="width:6%">Target</th>
			                    <th class="head0" style="width:6%">Actual</th>
			                    <th class="head0" style="width:6%">Cum</th>
			                    <th class="head0" style="width:8%">正向<br/>反向</th>
			                    <th class="head0" style="width:6%">是否<br/>达标</th>
			                    <th class="head0" style="width:4%">QC<br/>DP</th>
			                    <th class="head0" style="width:10%">备注</th>
			                    <th class="head0" style="width:8%">操作者</th>
			                    <th class="head0" style="width:10%">更新<br/>时间</th>
			                </tr>
			            </thead>
			            <tbody>
			            	
			            </tbody>
			        </table>
			    </div><!--widgetcontent-->			
			</div>
		</div>
		<!--widgetbox-->
		<script>
		var _p_index=1;
		function loadKPIList(){
			var _url = ctx+"/common/gapKPI/queryResult.do";
			var param = {};
			param['pageIndex']=_p_index;
			param['pageSize']=10;
			ajaxUrl(_url,param,function(json){
				var _tr_td = '', _td = '';
				$.each(json.rows, function (n, value) { 
					_tr_td += "<tr id='gap_kpi_"+value.id+"' onclick='gap_kpi_click_select(this);' title='点击可修改'>"+
								"<td id='id' style='display: none'>"+value.id+"</td>"+
								"<td id='target_flag' style='display: none'>"+value.target_flag+"</td>"+
								"<td id='kpi_type'>"+value.kpi_type+"</td>"+
								"<td id='kpi_date'>"+value.kpi_date.replace(" 00:00:00","")+"</td>"+
								"<td id='dept_name'>"+value.dept_name+"</td>"+
								"<td id='ext_1'>"+value.ext_1+"</td>"+
								"<td id='target'>"+value.target+"</td>"+
								"<td id='actual'>"+value.actual+"</td>"+
								"<td id='ext_3'>"+value.ext_3+"</td>"+
								"<td id='cum'>"+value.cum+"</td>"+
								"<td id='health_png'><img src='"+value.health_png+"'/></td>"+
								"<td id='ext_2'>"+value.ext_2+"</td>"+
								"<td id='remark'>"+value.remark+"</td>"+
								"<td>"+value.operater+"</td>"+
								"<td>"+value.update_date+"</td>";
					_tr_td +="</tr>";
		        });
		        $("#gap_kpi_view table tbody").append(_tr_td);
		        _p_index++;
			});
		}
		loadKPIList();
		
		function exportKPIList(){
			var _url = ctx+"/common/gapKPI/exportCsv.do";
			var param = {};
			downFile(_url,param);
		}
		
		function gap_kpi_click_select(obj){
			var valForm = $("#"+obj.id).find("*");
			$.each(valForm,function(i,v){
				if(v.id.length>0){
					if(v.id=='health_png'){
						$("#kpiactual #"+v.id).val($("#"+obj.id+" #"+v.id+" img").attr("src"));
					}else{
						$("#kpiactual #"+v.id).val($(this).text().Trim());
					}
				}
			});
			loadKpiType($("#"+obj.id+" #dept_name").text().Trim(),$("#"+obj.id+" #kpi_type").text().Trim());
		}
		</script>		