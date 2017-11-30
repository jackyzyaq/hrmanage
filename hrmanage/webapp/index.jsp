<%@ include file="/share/jsp/cartTag.jsp"%>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<%@ page import="com.yq.authority.pojo.UserInfo" %>
<%
	UserInfo user = (UserInfo)session.getAttribute("user");
    if(user==null||user.getId()==null||user.getId() == 0) {
%>
		<script type="text/javascript">
			click_href('${ctx}/login/login.jsp');
		</script>
<%	
	}else{
%>
		<script type="text/javascript">
			click_href('${ctx}/portal/portal_index.jsp');
		</script>
<%	
	}
%>