<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.service.*"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	int flow_id = Integer.parseInt(StringUtils.defaultIfEmpty(request.getParameter("flow_id"),"0"));
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(st);
	DepartmentInfoService deptInfoService = (DepartmentInfoService) ctx.getBean("departmentInfoService");
	FlowInfoService flowInfoService = (FlowInfoService) ctx.getBean("flowInfoService");
	
	FlowInfo flowInfo = flowInfoService.queryById(flow_id);
	String empids = "";
	List<DepartmentInfo> result2 = null;
	if(flowInfo!=null){
		for(String step:StringUtils.defaultIfEmpty(flowInfo.getStep_info(), "").split("]")){
			empids +=step.split(",")[1].split("\\|")[0]+",";
		}
		empids = empids.substring(0,empids.length()-1);
		result2 = deptInfoService.findDeptAndEmp(empids);
	}
	List<DepartmentInfo> result = deptInfoService.findDeptAndEmp(null);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<jsp:include page="/common/shareJsp/cartZTreeHead.jsp" />

<script type="text/javascript" src="${ctx }/share/js/tow_tree_drag.js"></script>

<script type="text/javascript">
	var zDeptNodes =[
		<%
		if(result!=null&&result.size()>0){
		for(int i=0;i<result.size();i++){
			DepartmentInfo a=result.get(i);
			if(StringUtils.isEmpty(a.getDept_name())||a.getDept_name().indexOf("|")>-1&&(","+empids+",").indexOf(","+Math.abs(a.getId())+",")>-1)continue;
		%>
		{id:<%=a.getId()%>, pId:<%=a.getParent_id()%>,pName:"", name:"<%=a.getDept_name()%>",open:false,chkDisabled:true,node_count:<%=a.getNode_count().intValue()%>}
		<%
		if((i+1)!=result.size())out.print(",");
		}
		} %>
	];
	var zDeptNodes2 =[
		<%
		if(result2!=null&&result2.size()>0){
		for(int i=0;i<result2.size();i++){
			DepartmentInfo a=result2.get(i);
		%>
		{id:<%=a.getId()%>, pId:<%=a.getParent_id()%>,pName:"", name:"<%=a.getDept_name()%>",open:<%=a.getNode_count()==1?"true":"false"%>,node_count:<%=a.getNode_count().intValue()%>}
		<%
		if((i+1)!=result2.size())out.print(",");
		}
		} %>
	];
	/**
	 * 获取id:orderNum排列的json
	 * @param objTreeDemo
	 * @param tree_zNodes
	 */
	function getDragNodesJson() {
		var _str_='';
		var zTree = $.fn.zTree.getZTreeObj("treeDemo2");
		var nodes = zTree.transformToArray(zTree.getNodes());
		for(var i=0;i<nodes.length;i++){
			_str_ += '['+(i+1)+','+Math.abs(nodes[i].id)+'\|'+nodes[i].name+','+(i+1)+']';
		}
		return _str_;
	}

	$(function(){
		type_show(zDeptNodes,zDeptNodes2,'treeDemo','treeDemo2');
		$('#contentwrapper #submit').click(function(){
			var str_=getDragNodesJson();
			if(str_.Trim().length>0){
				var step = str_.split('][');
				if(step.length<3){
					alert('至少选择3个！');
					return ;
				}
				var _html = ""+
				"<div class=\"widgetbox\">"+
				"	<div class=\"widgetcontent padding0 statement\">"+
				"	   <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"stdtable\">"+
				"	        <colgroup>"+
				"	            <col class=\"con0\" />"+
				"	            <col class=\"con1\" />"+
				"	            <col class=\"con0\" />"+
				"	        </colgroup>"+
				"	        <thead>"+
				"	            <tr>"+
				"	                <th class=\"head0\">序号</th>"+
				"	                <th class=\"head1\">步骤</th>"+
				"	                <th class=\"head0\">部门</th>"+
				"	                <th class=\"head0\">姓名</th>"+
				"	                <th class=\"head0\">预期时间</th>"+
				"	            </tr>"+
				"	        </thead>"+
				"	        <tbody>";
				for(var i=0;i<step.length;i++){
					_html+=" <tr><td>"+(i+1)+"</td><td>第"+(step[i].split(",")[2].replace(']',''))+"步</td><td><input type='hidden' name='dept_id_"+(i+1)+"' id='dept_id_"+(i+1)+"' value='"+(step[i].split(",")[1].split('|')[4])+"'/>"+(step[i].split(",")[1].split('|')[1])+"</td><td><input type='hidden' name='emp_id_"+(i+1)+"' id='emp_id_"+(i+1)+"' value='"+(step[i].split(",")[1].split('|')[5])+"'/>"+(step[i].split(",")[1].split('|')[2])+"</td><td><input class='longinput' style='width:60px;' type='text' readonly='readonly' id='expect_time_"+(i+1)+"' title='Time' name='expect_time_"+(i+1)+"' value=''/></td></tr>";
				}
				_html+="	        </tbody>"+
				"	    </table>"+
				"	</div><!--widgetcontent-->"+
				"</div><!--widgetbox-->";	
				parent.document.getElementById('step_t').innerHTML=	_html;
				for(var i=0;i<step.length;i++){
					parent.timeDrop('expect_time_'+(i+1));
				}
				parent.jClose();
			}
		});
	});
</script>

</head>
<body>
	<div id="contentwrapper" class="contentwrapper" style="width:90%;">
		<form class="stdform stdform2" onSubmit="return false;">
			<div>
	         	<div class="one_half">
	                <ul id="treeDemo" class="ztree" style="width:100%"></ul>
	                </div>
	            <div class="one_half last">
	               	<ul id="treeDemo2" class="ztree" style="width:100%"></ul>
	            </div>				
			</div>
            <div>
			<button id="submit" class="submit radius2">提交</button>
			</div>
		</form>
	</div>
</body>
</html>