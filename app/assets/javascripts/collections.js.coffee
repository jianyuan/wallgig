$ ->
  if $('body.collections.index').length == 1
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

      ga('send', 'pageview', url) if ga

    $('[rel=next]').bind('inview', loadNextPage)