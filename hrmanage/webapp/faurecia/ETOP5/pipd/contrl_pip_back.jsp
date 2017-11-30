<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/share/jsp/cartTag.jsp"%>
<%@ page import="com.yq.authority.pojo.*"%>
<%@ page import="com.yq.authority.service.*"%>
<%
	Calendar cal = Calendar.getInstance();
	int begin_year = cal.get(Calendar.YEAR);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="/common/shareJsp/cartHead.jsp" />
<script type="text/javascript" src="${ctx }/js/ama/js/plugins/jquery.flot.pie.js"></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/pipd/charts.js"></script>
<script type='text/javascript' src='${ctx }/js/ama/js/plugins/fullcalendar.min.js'></script>
<script type="text/javascript" src="${ctx }/faurecia/ETOP5/pipd/calendar.js"></script>
</head>
<body>
	<div id="contentwrapper" class="contentwrapper">
		<jsp:include page="/faurecia/ETOP5/plant/plant_inner.jsp" flush="true">
			<jsp:param value="<%=Global.plant_type[2] %>" name="type"/>
			<jsp:param value="<%=begin_year %>" name="begin_year"/>
		</jsp:include>
		<div class="one_half left">
			<div class="widgetbox">
				<div class="title"><h4>Explanations to support selection of Top Priorities (18 months)</h4></div>
				<div class="widgetcontent">
					<div class="one_third left">
					<div id="bargraph1" style="height:150px;"></div>
					</div>
					<div class="one_third left">
					<div id="bargraph2" style="height:150px;"></div>
					</div>
					<div class="one_third last">
					<div id="bargraph3" style="height:150px;"></div>
					</div>
				</div><!--widgetcontent-->
				<div class="widgetcontent">
					<div class="one_half left">
					<div id="bargraph4" style="height:150px;"></div>
					</div>
					<div class="one_half last">
					<div id="bargraph5" style="height:150px;"></div>
					</div>
				</div><!--widgetcontent-->
				<div class="widgetcontent">
					<div class="one_half left">
					<div id="bargraph6" style="height:150px;"></div>
					</div>
					<div class="one_half last">
					<div id="bargraph7" style="height:150px;"></div>
					</div>
				</div><!--widgetcontent-->	
			</div><!--widgetbox-->
		</div><!--one_half last--> 
		                       
		<div class="one_half last">
			<div class="widgetbox">
				<div class="title"><h4>Plant Top Priorities management  (18 months)</h4></div>
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="33%" />
							<col class="con0" width="33%" />
							<col class="con0" width="34%" />
						</colgroup>
						<thead>
                                <tr>
                                    <th class="head0">Plant Top Priorities<br />(18 months)</th>
                                    <th class="head0">Breakthrough</th>
                                    <th class="head0">Daily Management</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Quality<br />Improvement</td>
                                    <td></td>
                                    <td class="center">Management control-Nb. of customer complaint</td>
                                </tr>
                                <tr>
                                    <td>MOD cost</td>
                                    <td></td>
                                    <td class="center">Management control-DLE Improvement</td>
                                </tr>
                                <tr>
                                    <td>Inventory control</td>
                                    <td></td>
                                    <td class="center">Management control-Cycle count accuracy</td>
                                </tr>
                                <tr>
                                    <td>Safety  Improvement</td>
                                    <td></td>
                                    <td class="center">Management control-FR2T</td>
                                </tr>
                                <tr>
                                    <td>New Program launch</td>
                                    <td>New Program Launch Management</td>
                                    <td class="center"></td>
                                </tr>
                                <tr>
                                    <td>Plant N-1 Successor Improvement</td>
                                    <td>N-1 and key position successor improve</td>
                                    <td class="center"></td>
                                </tr>
                                <tr>
                                    <td>Purchasing cost process improvement</td>
                                    <td>Purchasing process optimizing</td>
                                    <td class="center">20.5</td>
                                </tr>                                                                
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div><!--widgetbox-->                        
		</div><!--one_half last-->
		<div class="">
			<div class="widgetbox">
				<div class="widgetcontent">
					<table cellpadding="0" cellspacing="0" border="0" class="stdtable">
						<colgroup>
							<col class="con0" width="10%" />
							<col class="con0" width="35%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="10%" />
							<col class="con0" width="5%" />
							<col class="con0" width="5%" />
							<col class="con0" width="5%" />
							<col class="con0" width="5%" />
							<col class="con0" width="5%" />
						</colgroup>
						<thead>
                                <tr>
                                    <th class="head0">Top<br />Priorities</th>
                                    <th class="head0">Macro<br />Activities</th>
                                    <th class="head0">Responsible</th>
                                    <th class="head0">Support</th>
                                    <th class="head0">Output<br />KPI</th>
                                    <th class="head0">Initial<br />16.6</th>
                                    <th class="head0">Actual<br />16.6</th>
                                    <th class="head0">Tgt 6m<br />16.12</th>
                                    <th class="head0">Tgt 12m<br />17.6</th>
                                    <th class="head0">Tgt 18m<br />17.12</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Quality<br />Improvement</td>
                                    <td>
	                                    <p>
	                                    A1: Quality problems to improve: 
										       Internal Analysis , Supplier Audit ,7QB, Monthly tracking
										</p>
										<p>
										A2:Customer satisfaction to improve: 
										     QRCI workshop 3 times,
										</p>
										<p>
										A3:NPQ performance improvement: 
										     Aftermarket root cause analysis
	                                    </p>
                                    </td>
                                    <td>Sun Baicheng</td>
                                    <td></td>
                                    <td>Nb. Of Customer complaint</td>
                                    <td>9/M</td>
                                    <td>5/M</td>
                                    <td>9/M</td>
                                    <td>8/M</td>
                                    <td>7/M</td>
                                </tr>
                                <tr>
                                    <td>MOD cost</td>
                                    <td>
	                                    <p>
	                                    B4:Unplanned time analysis:
										      Monthly review
										B5: Downtime improvement: 
										       maintenance QRCI  review by plant level 
										B6:Production efficiency optimization: 
										 5 Hosin workshop 3 times
										B7:GAP Size optimization: 
										     GAP size Workshop&monthly review
	                                    </p>                                    
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>                                    
                                </tr>
                                <tr>
                                    <td>Inventory control</td>
                                    <td>
                                    	<p>
                                    	C8: Cycle count daily management
										4 booking point implement improvement;
										negative stock analysis;
										C9:  Nonconforming product management
                                    	</p>
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>                                    
                                </tr>
                                <tr>
                                    <td>Safety  Improvement</td>
                                    <td>
                                    	<p>
                                    	D10: Logistics forklift and small train optimization:         
										      Logistics area impact monthly review 
										D11: Risk Identification and Elimination: 
										        Core Team Audit & Management Review
                                    	</p>
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>                                    
                                </tr>
                                <tr>
                                    <td>New Program launch</td>
                                    <td>
                                    	<p>
                                    	E12: launch cost control:
											Package design optimize, 
											 open issue for new program review monthly
                                    	</p>
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>                                    
                                </tr>
                                <tr>
                                    <td>Plant N-1 Successor Improvement</td>
                                    <td>
                                    	<p>
                                    	F13:  People Review: 
										Yearly people review process , Monthly review
										F14:  Succession Plan: 
										Yearly ST succession plan, Make potential ST succession plan ,Monthly review
										F15:  Recruitment plan : 
										Monthly review action plan
                                    	</p>
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>                                    
                                </tr>
                                <tr>
                                    <td>Purchasing cost process improvement</td>
                                    <td>
                                    	<p>
                                    	G16:  Spare parts cost optimization:
										Price benchmark analysis, spare parts utilization analysis, 
										G17:  Supplier VAVE:
										Supplier VAVE workshop monthly, weekly follow up
                                    	</p>
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>                                    
                                </tr>                                                                
                            </tbody>
                        </table>
				</div><!--widgetcontent-->
			</div><!--widgetbox-->		
		</div>
		<div>
			<jsp:include page="/faurecia/ETOP5/pipd/contrl_plant_schcedule.jsp" flush="true" />
		</div>
	</div>
</body>
</html>
