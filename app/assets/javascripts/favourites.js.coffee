$ ->
  if $('[data-action=favourite]').length > 0
    $('body').on 'ajax:success', '[data-action=favourite] [data-remote]', (event, data, status, xhr) ->
      $(this).closest('[data-action=favourite]').replaceWith data