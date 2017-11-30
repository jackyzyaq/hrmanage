<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/national_holiday/js/national_holiday.js"></script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
		<jsp:include page="/share/jsp/menuAll.jsp" />
    <br />
                    <form class="yqstdform" onSubmit="return false;">
                        <div>
                        	<label>日期</label>
                            <span class="field">
                           	<jsp:include page="/share/jsp/date.jsp" />
                            </span>
                        </div>
                    </form>
        	</div>
</body>
</html>