$(function() {
		/* initialize the calendar */
		$('#calendar').fullCalendar({
			header: {
				left: 'month,agendaWeek,agendaDay',
				center: 'title',
				right: 'today, prev, next'
			},
			buttonText: {
				prev: '&laquo;',
				next: '&raquo;',
				prevYear: '&nbsp;&lt;&lt;&nbsp;',
				nextYear: '&nbsp;&gt;&gt;&nbsp;',
				today: 'today',
				month: 'month',
				week: 'week',
				day: 'day'
			},
			editable: false,//判断该日程能否拖动
			droppable: true, // this allows things to be dropped onto the calendar !!!
			drop: function(date, allDay) { // this function is called when something is dropped
				// retrieve the dropped element's stored Event Object
				var originalEventObject = $(this).data('eventObject');
				
				// we need to copy it, so that multiple events don't have a reference to the same object
				var copiedEventObject = $.extend({}, originalEventObject);
				
				// assign it the date that was reported
				copiedEventObject.start = date;
				copiedEventObject.end = new Date(date.getTime()+getTimeInMillis(65,'d'));
				
				
				//alert(copiedEventObject.start.format("yyyy-MM-dd hh:mm:ss"));
				//alert(copiedEventObject.end.format("yyyy-MM-dd hh:mm:ss"));
				
				$.each(copiedEventObject,function(n,value){
					//alert(n);
					//alert(value);
					}
				);
				copiedEventObject.allDay = allDay;
				
				// render the event on the calendar
				// the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
				
				$('#calendar').fullCalendar('renderEvent', copiedEventObject, true);
				
				// is the "remove after drop" checkbox checked?
				
				$(this).remove();
				
			},
			viewDisplay: function (view) {//动态把数据查出，按照月份动态查询
				$("#calendar").fullCalendar('removeEvents');
				var param = {};
				param['pageIndex']=1;
				param['pageSize']=1000;
				param['state']='1';
				param['begin_date']=year+'-01-01 00:00:00';
				param['end_date']=year+'-12-31 00:00:00';
				ajaxUrl(_url,param,function(json){
					var resultCollection = json.rows;
					$.each(json.rows, function (n, value) {
						value.start=value.begin_date;
						value.end=value.end_date;
						$("#calendar").fullCalendar('renderEvent', value, true);
			        });
                }); //把从后台取出的数据进行封装以后在页面上以fullCalendar的方式进行显示
			}
		});
		
		
		
		///// SWITCHING LIST FROM 3 COLUMNS TO 2 COLUMN LIST /////
		function reposTitle() {
			if($(window).width() < 450) {
				if(!$('.fc-header-title').is(':visible')) {
					if($('h3.calTitle').length == 0) {
						var m = $('.fc-header-title h2').text();
						$('<h3 class="calTitle">'+m+'</h3>').insertBefore('#calendar table.fc-header');
					}
				}
			} else {
				$('h3.calTitle').remove();
			}
		}
		reposTitle();
		
		///// ON RESIZE WINDOW /////
		//$(window).resize(function(){
		//	reposTitle();
		//});
		
});
