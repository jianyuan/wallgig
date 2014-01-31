$ ->
  $('[data-action=explain-add-profile-cover]').click (e) ->
    e.preventDefault()
    bootbox.alert
      title: 'Add profile cover'
      message: JST['modal_add_profile_cover_explanation']()