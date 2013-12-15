$ ->
  if $('[data-action=favourite]').length > 0
    $('body').on 'ajax:success', '[data-action=favourite] [data-remote]', (event, data, status, xhr) ->
      $(this).closest('[data-action=favourite]').replaceWith data

    $('form[data-action=change-collection] select').change ->
      $(this).closest('form').submit()

    $('body').on 'ajax:beforeSend', 'form[data-action=change-collection]', ->
      $(this).find('select').prop 'disabled', true

    $('body').on 'ajax:complete', 'form[data-action=change-collection]', ->
      $(this).find('select').prop 'disabled', false