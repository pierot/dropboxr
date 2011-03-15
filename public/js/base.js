$(document).ready(function(){
	
	$('a img').each(function(){
		$(this).parent().css('border', 'none');
	});
	
});

// iOS fix
var a = document.getElementsByTagName("a");

for(var i = 0; i < a.length; i++) {
    a[i].onclick=function() {
        window.location=this.getAttribute("href");
        return false;
    }
}