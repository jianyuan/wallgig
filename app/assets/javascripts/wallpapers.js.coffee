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

  if $('body.wallpapers.index, body.users.show').length == 1
    loadNextPage = (event, visible) ->
      return unless visible
      $this = $(this)
      url = $this.attr 'href'
      $this.unbind 'inview'
      $this.replaceWith('<hr /><div class="loading" />')
      $.get url, (html) ->
        $main = $('#main')
        $main.find('.loading').remove()
        $main.append(html)
        $('[rel=next]').bind('inview', loadNextPage)

    $('[rel=next]').bind('inview', loadNextPage)