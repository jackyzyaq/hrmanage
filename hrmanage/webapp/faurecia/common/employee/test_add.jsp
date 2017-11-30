<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.faurecia.pojo.*"%>
<%@ page import="com.yq.faurecia.service.*"%>
<%
	ServletContext st = this.getServletConfig().getServletContext();
	ApplicationContext ctx = WebApplicationContextUtils
			.getRequiredWebApplicationContext(st);
	PositionInfoService positionInfoService = (PositionInfoService) ctx.getBean("positionInfoService");
	EmployeeInfoService employeeInfoService = (EmployeeInfoService) ctx.getBean("employeeInfoService");
	ProjectInfoService projectInfoService = (ProjectInfoService) ctx.getBean("projectInfoService");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%-- <jsp:include page="/common/shareJsp/cartHead.jsp" /> --%>
<style type="">
.clear{clear:both}
input {
    vertical-align: middle;
    margin: 0;
    padding: 0
}
.file-box {
    position: relative;
    width: 340px
}
.txt {
    height: 22px;
    border: 1px solid #cdcdcd;
    width: 180px;
}
.btn {
    background-color: #FFF;
    border: 1px solid #CDCDCD;
    height: 24px;
    width: 70px;
    cursor: pointer;
}
.file {
    position: absolute;
    top: 0;
    right: 80px;
    height: 24px;
    line-height: 24px;
    filter: alpha(opacity : 0);
    opacity: 0;
    width: 260px
}
 
#portrait_con {
    width: 690px;
    margin: 10px 0;
}
#preview {
    height: 140px;
}
#cropzoom_container {
    display: none;
}
#preview #CurruntPicContainer{
    float: left;
    width: 100px;
}
.title {
    border-bottom: 1px solid #CCCCCC;
    padding: 5px;
}
.title b {
    font-weight: bold;
}
.photocontainer
{
    margin-top:10px;
    background:url("bg_120.gif") no-repeat left top;   
    padding:7px 12px 12px 7px;                                        
} 
.photocontainer img
{
    width: 80px;
    height: 80px;                                        
} 
.uploadtooltip {
    color: #555555;
    line-height: 150%;
    margin-top: 10px;
}
#SelectPicContainer {
    float: right;
    width: 560px;
}
#editPortrait {
    margin-top: 10px;
}
</style>
</head>
<body>
<p>
        <strong>更换头像.</strong>
    </p>
    <br/>
    <p>
        <strong>上传真实头像方便网友认识你。</strong>
    </p>
    <br/>
    <p>
        <strong>选择照片后，你可以使用裁剪功能，截取你希望展示的部分。</strong>
    </p>
     
     
    <div id="portrait_con">
        <div class="crop">
             
           <div id="preview">
                 
                <!--当前照片-->
                <div id="CurruntPicContainer">
                    <div class="title"><b>当前照片</b></div>
                    <div class="photocontainer">
                        <img id="imgphoto" src="portrait.gif" style="border-width:0px;" />
                    </div>
                </div>
                 
                 
                 <!--选择新头像-->
                 <div id="SelectPicContainer">
                    <div class="title"><b>更换头像</b></div>
                    <div id="uploadcontainer">
                        <div class="uploadtooltip">请选择新的头像图片，文件需小于1.0MB</div>
                        <div class="uploadtooltip">上传新头像图片后，您可以拖动选区以裁剪满意的头像</div>
                        <div class="uploaddiv file-box">
                            <form name="form_portrait" method="post" action="/setportrait" id="form_portrait" enctype="multipart/form-data">
                                <input type='text' name='tempFileValue' id='tempFileValue' class='txt' />
                                <input type='button' class='btn' value='选择照片' />
                                <input type="file" name="file" class="file" id="fileField" />
                                <input type="submit" name="newPortraitUpload" value="上 传" class="btn" id="newPortraitUpload" />
                            </form>
                        </div>
                    </div>
                 </div>
                 
            </div>
           
            <div id="cropzoom_container">
            
               <div class="title"><b style="margin-right: 50px;">裁切头像照片</b>您可以拖动下面的选区以裁剪满意的头像</div>
                
               <div style="margin:10px 0;">
                    <input type='button' value='保存选中区域' title='保存选中区域' id='btn_save_region' class='btn submit'/>
                    <input type='button' value='保存全图' title='保存全图' id='btn_save_all' class='btn submit'/> (注意：选择“保存全图”头像可能会变形)
                    <input type='button' value='取消' id='btn_cancel' class='btn submit'/>
               </div>
                
               <div id="editPortrait">
                    <img id="edit_portrait_temp" src=""/>
               </div>
 
                <form id='form_save' action="/admin/save_portrait" style='display:none;'>
                    <input type='hidden' id='img_left' name='left' value='0'/>
                    <input type='hidden' id='img_top' name='top' value='0'/>
                    <input type='hidden' id='img_width' name='width' value='0'/>
                    <input type='hidden' id='img_height' name='height' value='0'/>
                </form>
                
            </div>
            
           <div class="clear"></div>
        </div>
    </div>
</body>
</html>