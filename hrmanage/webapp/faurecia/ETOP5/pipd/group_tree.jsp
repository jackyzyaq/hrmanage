<%@page import="com.yq.faurecia.pojo.DepartmentInfo"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	DepartmentInfoService deptInfoService = (DepartmentInfoService) ctx.getBean("departmentInfoService");
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	
	DepartmentInfo di = deptInfoService.queryById(1);
	List<DepartmentInfo> dis = new ArrayList<DepartmentInfo>();
	dis.add(di);
	dis.addAll(deptInfoService.findByParentId(1));
	
%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/common/shareJsp/cartHead.jsp" />
<style class="csscreations">
/*Now the CSS*/
* {margin: 0; padding: 0;}

.tree ul {
 padding-top: 20px; position: relative;
 
 transition: all 0.5s;
 -webkit-transition: all 0.5s;
 -moz-transition: all 0.5s;
}

.tree li {
 float: left; text-align: center;
 list-style-type: none;
 position: relative;
 padding: 20px 5px 0 5px;
 
 transition: all 0.5s;
 -webkit-transition: all 0.5s;
 -moz-transition: all 0.5s;
}

/*We will use ::before and ::after to draw the connectors*/

.tree li::before, .tree li::after{
 content: '';
 position: absolute; top: 0; right: 50%;
 border-top: 1px solid #ccc;
 width:50%; height: 20px;
}
.tree li::after{
 right: auto; left: 50%;
 border-left: 1px solid #ccc;
}

/*We need to remove left-right connectors from elements without 
any siblings*/
.tree li:only-child::after, .tree li:only-child::before {
 display: none;
}

/*Remove space from the top of single children*/
.tree li:only-child{ padding-top: 0;}

/*Remove left connector from first child and 
right connector from last child*/
.tree li:first-child::before, .tree li:last-child::after{
 border: 0 none;
}
/*Adding back the vertical connector to the last nodes*/
.tree li:last-child::before{
 border-right: 1px solid #ccc;
 border-radius: 0 5px 0 0;
 -webkit-border-radius: 0 5px 0 0;
 -moz-border-radius: 0 5px 0 0;
}
.tree li:first-child::after{
 border-radius: 5px 0 0 0;
 -webkit-border-radius: 5px 0 0 0;
 -moz-border-radius: 5px 0 0 0;
}

/*Time to add downward connectors from parents*/
.tree ul ul::before{
 content: '';
 position: absolute; top: 0; left: 50%;
 border-left: 1px solid #ccc;
 width: 0; height: 20px;
}

.tree li a{
 border: 1px solid #ccc;
 padding: 5px 10px;
 text-decoration: none;
 color: #666;
 font-family: arial, verdana, tahoma;
 font-size: 11px;
 display: inline-block;
 
 border-radius: 5px;
 -webkit-border-radius: 5px;
 -moz-border-radius: 5px;
 
 transition: all 0.5s;
 -webkit-transition: all 0.5s;
 -moz-transition: all 0.5s;
}

/*Time for some hover effects*/
/*We will apply the hover effect the the lineage of the element also*/
.tree li a:hover, .tree li a:hover+ul li a {
 background: #c8e4f8; color: #000; border: 1px solid #94a0b4;
}
/*Connector styles on hover*/
.tree li a:hover+ul li::after, 
.tree li a:hover+ul li::before, 
.tree li a:hover+ul::before, 
.tree li a:hover+ul ul::before{
 border-color:  #94a0b4;
}

/*Thats all. I hope you enjoyed it.
Thanks :)*/
</style>
<script type="text/javascript">
$(function(){
<%
	String upload_pic = "0";
	for(DepartmentInfo dit:dis){
		if(dit.getState().intValue()==0)continue;
		if(dit.getDept_code().equals("GMO"))continue;
		int depId = dit.getId();
		int pId = dit.getParent_id();
		String dep_name = dit.getDept_name();
		String dep_code = dit.getDept_code();
		List<EmployeeInfo> eiList = employeeInfoService.findByDeptId(String.valueOf(depId));
		if(eiList!=null&&!eiList.isEmpty()){
			EmployeeInfo ei = eiList.get(0);
			if(!StringUtils.isEmpty(ei.getPhoto_upload_uuid())){
				upload_pic = ei.getPhoto_upload_uuid();
			}
		}
%>
	addNode(<%=depId%>,<%=pId%>,'<%=dep_name+"|"+dep_code%>','<%=(upload_pic)%>');
<%} %>
});
function addNode(id,pId,name,upload_pic){
	var node = "<li id='"+id+"' parentId='"+pId+"'><a href='#'><img src='${ctx }/share/jsp/showImage.jsp?file="+upload_pic+"' width='100' height='110' title=''/><br/>"+name.replace("|","<br/>")+"</a></li>";
	if(pId>0){
		if(checkUL($("#"+pId))){
			$("#"+pId).children('ul').append(node);
		}else{
			$("#"+pId).append("<ul>"+node+"</ul>");
		}
	}else{
		if(checkUL($(".tree"))){
			$(".tree").children('ul').append(node);
		}else{
			$(".tree").append("<ul>"+node+"</ul>");
		}
	}
}
function checkUL(obj){
	var isExist = (obj.children("ul").length>0?isExist = true:isExist = false);
	return isExist;
}
</script>
</head>
<body>
<jsp:include page="/share/jsp/screen_full.jsp" />
<div class="tree" style="width:100%;height:100%;"></div>
</body>
</html>