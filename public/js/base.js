$(document).ready(function(){
	
	$('a img').each(function(){
		$(this).parent().css('border', 'none');
	});
	
});

var isMobileDevice = function () {
  return !!(navigator.userAgent.toLowerCase().match(/(iPhone|iPod|blackberry|android 0.5|htc|lg|midp|mmp|mobile|nokia|opera mini|palm|pocket|psp|sgh|smartphone|symbian|treo mini|Playstation Portable|SonyEricsson|Samsung|MobileExplorer|PalmSource|Benq|Windows Phone|Windows Mobile|IEMobile|Windows CE|Nintendo Wii)/i));
};

// iOS fix
if(isMobileDevice()) {
  var a = document.getElementsByTagName("a");

  for(var i = 0; i < a.length; i++) {
      a[i].onclick=function() {
          window.location=this.getAttribute("href");
          return false;
      }
  }
}
