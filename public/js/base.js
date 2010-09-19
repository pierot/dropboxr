$(document).ready(function(){
	
	$('a img').each(function(){
		$(this).parent().css('border', 'none');
	});
	
	$('ul.gallery li a').fancybox({
		'transitionIn': 'elastic',
		'transitionOut': 'elastic',
		'speedIn': 600, 
		'speedOut': 200, 
		'overlayShow': false
	});
	
});