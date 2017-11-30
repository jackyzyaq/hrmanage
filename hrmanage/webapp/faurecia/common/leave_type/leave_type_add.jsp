<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/faurecia/common/leave_type/js/leave_type.js"></script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
                    <form class="yqstdform" onSubmit="return false;">
                        <div>
                        	<label>编码</label>
                            <span class="field">
                            <input type="text" name="type_code" id="type_code"  class="mediuminput" value=""/>
                            </span>
                        </div>
                        <div>
                        	<label>名称</label>
                            <span class="field">
                            <input type="text" name="type_name" id="type_name" class="mediuminput" value=""/>
                            </span>
                        </div>
                        <div>
                        	<label>描述</label>
                            <span class="field">
                            <textarea rows="4" class="mediuminput" name="remark" id="remark"></textarea>
                            </span> 
                        </div>                        
                        <div>
                        	<label>有效</label>
                            <span class="field">
                            <select name="state" id="state" class="uniformselect">
                            	<option value="1">是</option>
                                <option value="0">否</option>
                            </select>
                            </span>
                        </div>
                        <br clear="all" />
                        <div class="stdformbutton">
                        	<button id="submit" class="submit radius2">提交</button>
                            <input type="reset" class="reset radius2" value="Reset" />
                        </div>
                    </form>
        	</div>
</body>
</html>