$ ->
  if $('[data-provide=comments]')
    $commentForm = $('form[data-provide=comments]')
    $commentInput = $commentForm.find('#comment_comment')
    $commentList = $('.list-comment')
    $commentsContainer = $commentList.closest('.container-comments')
    $commentForm.on 'ajax:success', (event, data, status, xhr) ->
      $commentInput.val('')
      $commentList.prepend data
      $commentsContainer.removeClass('hide')
    $('[data-action=load-comments]').on 'ajax:success', (event, data, status, xhr) ->
      $commentList.html data
      $(this).remove()