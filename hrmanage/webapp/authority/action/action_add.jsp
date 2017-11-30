<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/authority/action/js/action.js"></script>
</head>
<body>
		<div id="contentwrapper" class="contentwrapper">
                    <form class="yqstdform" onSubmit="return false;">
                        <div>
                        	<label>所属菜单</label>
                            <span class="field">
                            	<jsp:include page="/share/jsp/menu_ztree.jsp" />
                            </span>
                        </div>
                        <div>
                        	<label>动作代码</label>
                            <span class="field">
                            <input type="text" name="action_code" id="action_code"  class="mediuminput" value=""/>
                            </span>
                        </div>
                        <div>
                        	<label>动作名称</label>
                            <span class="field">
                            <input type="text" name="action_name" id="action_name" class="mediuminput" value=""/>
                            </span>
                        </div>
                        <div>
                        	<label>可见</label>
                            <span class="field">
                            <select name="viewmode" id="viewmode" class="uniformselect">
                            	<option value="1">是</option>
                                <option value="0">否</option>
                            </select>
                            </span>
                        </div>
                        <br clear="all" />
                        <div class="stdformbutton">
                        	<button id="actionSubmit" class="submit radius2">提交</button>
                            <input type="reset" class="reset radius2" value="Reset" />
                            <input type="hidden" name="action_menu_id" id="action_menu_id" value=""/>
                        </div>
                    </form>
        	</div>
</body>
</html>


        
