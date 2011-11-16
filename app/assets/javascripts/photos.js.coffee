$ ->
  $('.single-image img').load ->
    $(this).css('max-width', '508px') if $(this).height() > $(this).width()
