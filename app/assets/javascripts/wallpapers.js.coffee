$ ->
  if $('body.wallpapers.show').length == 1
    $imgWallpaper = $('.img-wallpaper')

    $imgWallpaper.click ->
      $this = $(this)
      if $this.is('.state-1')
        $this.removeClass('state-1')
        $this.addClass('state-2')
      else
        $this.removeClass('state-2')
        $this.addClass('state-1')

  # disable infinite scroll
  # if $('body.wallpapers.index, body.users.show').length == 1
  #   loadNextPage = (event, visible) ->
  #     return unless visible
  #     $this = $(this)
  #     url = $this.attr 'href'
  #     $this.unbind 'inview'
  #     $this.replaceWith('<hr /><div class="loading" />')
  #     $.get url, (html) ->
  #       $main = $('#main')
  #       $main.find('.loading').remove()
  #       $main.append(html)
  #       $('[rel=next]').bind('inview', loadNextPage)

  #     ga('send', 'pageview', url) if ga?

  #   $('[rel=next]').bind('inview', loadNextPage)

  if $('.btn-group-purity').length
    Ladda.bind '.btn-group-purity .btn'
    $this = $(this)
    $this.on 'ajax:success', (event, data, status, xhr) ->
      $("[data-action=change-purity][data-wallpaper-id=#{ data.id }]")
        .removeClass 'btn-active'
      $("[data-action=change-purity][data-wallpaper-id=#{ data.id }][data-purity=#{ data.purity }]")
        .addClass 'btn-active'
    $this.on 'ajax:error', (event, xhr, status, error) ->
      # alert error
      Wallgig.Utilities.alert 'Error!', xhr.responseText || error
    $this.on 'ajax:complete', (event, xhr, status) ->
      Ladda.stopAll()