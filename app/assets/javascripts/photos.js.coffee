$ ->
  $('.single-image img').load ->
    $(this).addClass('portrait') if $(this).height() > $(this).width()
