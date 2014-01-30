$ ->
  if $('body.wallpapers.show').length == 1
    $('.btn-favourite').on 'ajax:success', (e, data) ->
      $this = $(this)
      if data.fav_status
        $this.addClass('favourited').html('<span class="glyphicon glyphicon-star"></span> Faved')
      else
        $this.removeClass('favourited').html('<span class="glyphicon glyphicon-star-empty"></span> Fav')

      $('.fav-count').text(data.fav_count)

  if $('body.wallpapers.index, body.collections.show, body.users.show, body.favourites.index').length == 1
    applyLazyLoad = ->
      $('.list-wallpaper .img-wallpaper.lazy:not(.lazy-loaded)').each ->
        $this = $(this)
        $this.addClass('lazy-loaded')
        $this.on 'load', ->
          $this.addClass 'lazy-show'
        $this.one 'inview', =>
          $this.attr('src', $this.data('src'))

    loadNextPage = (event, visible) ->
      return unless visible
      $this = $(this)
      url = $this.attr 'href'
      $this.unbind 'inview'
      $this.replaceWith('<hr /><div class="loading-spinner" />')
      $.get url, (html) ->
        $mainContainer = $('#main > .container')
        $mainContainer.find('.loading-spinner').remove()
        $mainContainer.append(html)
        applyLazyLoad()
        $('[rel=next]').bind('inview', loadNextPage)
      window.analytics.page(null, null, { path: url })

    applyLazyLoad()
    $('[rel=next]').bind('inview', loadNextPage)

    # Favourite action
    $('body').on 'click', '[data-action=favourite]', (event) ->
      $this = $(this)
      $this.on 'ajax:success', (event, data, status, xhr) ->
        $this.find('span.count').text data.count
        if data.favourite
          $this.addClass 'btn-info'
          window.analytics.track('Favourited a wallpaper')
        else
          $this.removeClass 'btn-info'
          window.analytics.track('Unfavourited a wallpaper')
      $this.on 'ajax:error', (event, xhr, status, error) ->
        # alert error
        Wallgig.Utilities.alert 'Error!', error
      $this.on 'ajax:complete', (event, xhr, status) ->
        Ladda.stopAll()

  if $('.btn-group-purity').length
    Ladda.bind '.btn-group-purity .btn'
    $this = $(this)
    $this.on 'ajax:success', (event, data, status, xhr) ->
      $("[data-action=change-purity][data-wallpaper-id=#{ data.id }]")
        .removeClass 'btn-active'
      $("[data-action=change-purity][data-wallpaper-id=#{ data.id }][data-purity=#{ data.purity }]")
        .addClass 'btn-active'
      window.analytics.track('Changed wallpaper purity')
    $this.on 'ajax:error', (event, xhr, status, error) ->
      # alert error
      Wallgig.Utilities.alert 'Error!', xhr.responseText || error
    $this.on 'ajax:complete', (event, xhr, status) ->
      Ladda.stopAll()

  if $('[data-provide=tag_editor]').length
    $tagEditor = $('[data-provide=tag_editor]')
    searchPath = $tagEditor.data 'search-path'
    currentRequest = null
    $tagEditor.selectize
      delimiter: ', '
      persist: false
      create: true
      valueField: 'tag'
      labelField: 'tag'
      searchField: 'tag'
      load: (query, callback) ->
        return callback() unless query.length
        currentRequest.abort() if currentRequest
        currentRequest = $.ajax
          url: searchPath
          data: { query: query }
          error: ->
            callback()
          success: (data) ->
            callback(data.map (tag) -> { tag: tag})

  if $('[data-action=save_settings]').length
    $('[data-action=save_settings]').on 'ajax:success', ->
      window.analytics.track 'Saved search settings',
        params: $(this).data('params')

  if $('[data-action=resize]').length
    $('[data-action=resize]').change ->
      $select = $(this)
      $option = $(this).find(':selected')
      url = $select.data('url')
      width = $option.data('width')
      height = $option.data('height')

      if width && height
        url += '/' + $option.data('width') + '/' + $option.data('height')
      else
      window.location.href = url