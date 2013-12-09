# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.img-wallpaper').click ->
    $this = $(this)
    if $this.is('.state-1')
      $this.removeClass('state-1')
      $this.addClass('state-2')
    else
      $this.removeClass('state-2')
      $this.addClass('state-1')