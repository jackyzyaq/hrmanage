	function validateEtopPwd(_url,title){
		//_url = _url.replaceAll("&","|");
		//parent.showHtml(ctx+'/faurecia/ETOP5/etop_pwd.jsp?jumpUrl='+_url,title,1024);
		_window_width = (_window_width>900?900:_window_width);
		_window_height = (_window_height>500?500:_window_height);
		parent.showHtml(_url,title,_window_width);
	}