start = ->
  $('button.hideimage').click ->
    $('img.holder').toggle()

  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '200px'

  $('select#customer').change ->
    selected = $('select#customer').val()
    if selected
      $('.project').hide()
      $('.customer' + selected ).show()
    else
      $('.project').show()
    $('.project:visible .collapse' ).removeClass 'in'
    $('.project:visible .collapse:first' ).addClass 'in'
    $('.project:visible .building:first' ).click()

  $('a.building').click ->
    selected = $(@).data('building')
    if selected
      $('#floors.building').hide()
      $('#floors.building.building'+selected).show()
      $('#floors.building.building'+selected+' .accordion-toggle:first').click()

  window.drawTags = ()->
    floor_id = $('.in:visible .zoom').data('id')
    holder = $('.in:visible .holder')
    zoomer = $('.in:visible .zoomImg')
    opacity = parseInt zoomer.css('opacity')
    $('.unzoom').css 'opacity', 1-opacity
    $('.zoomed').css 'opacity', opacity
    _.each tags, (tag) ->
      if tag.obj
        if tag.floor_id is floor_id
          tag.obj.draw holder, zoomer

  $('#newtagform #name').change ->
    $('#newtagform #uid').val $('#newtagform #name').val()

  new_tag = (floor_id, pos_x, pos_y) ->
    window.floor_id = floor_id
    $('#newtagform #x').val pos_x
    $('#newtagform #y').val pos_y
    available_tags = _.select tags, (tag) -> tag.floor_id == null
    used_tags = _.select tags, (tag) -> tag.floor_id
    $('#newtagform #name').children().detach()
    _.each available_tags, (tag) ->
      option = $('<option>').val(tag.uid).text(tag.name)
      $('#newtagform #name').append option
    if available_tags.length and used_tags.length
      $('#newtagform #name').append '<optgroup label="-------"></optgroup>'
    _.each used_tags, (tag) ->
      option = $('<option>').val(tag.uid).text(tag.name + ' - used')
      $('#newtagform #name').append option
    $('#newtagform #name').change()
    $.fancybox.open
      href: '#newtagform'

  $('.cancel-button').click ->
    $.fancybox.close()

  $('.save-button').click ->
    x = parseInt $('#newtagform #x').val()
    y = parseInt $('#newtagform #y').val()
    uid = $('#newtagform #uid').val()
    _tag = _.find tags, (tag) -> tag.uid == uid
    floor_id = window.floor_id
    newtag = new tag floor_id, x, y, _tag
    newtag.name = $('#newtagform #name').val()
    newtag.img.attr 'title', newtag.name
    newtag.zimg.attr 'title', newtag.name
    $.ajax
      url: 'tags/' + _tag.id
      type: 'PUT'
      data:
        tag:
          x: newtag.x
          y: newtag.y
          name: newtag.uid
          floor_id: floor_id
    drawTags()
    $.fancybox.close()

  if tags?
    setInterval drawTags, 100
    $('body').mousemove ->
      drawTags()

    $('body').on 'click', '.in:visible .zoomImg', (event) ->
      pos_x = event.offsetX || event.pageX-$('.in:visible .zoomImg').offset().left
      pos_y = event.offsetY || event.pageY-$('.in:visible .zoomImg').offset().top
      parent = $('.in:visible .zoom')
      floor_id = parent.data('id')

      overlap = null
      _.each tags, (tag) ->
        if tag.floor_id == floor_id
          if Math.abs(tag.x-pos_x) < $('.256')[0].width/2
            if Math.abs(tag.y-pos_y) < $('.256')[0].height/2
              overlap = tag
      if overlap
        overlap.open()
      else
        new_tag floor_id, pos_x, pos_y

    $('.accordion-toggle').click (event) ->
      event.stopPropagation()
      $this = $(@)

      parent = $this.data('parent');
      actives = parent && $(parent).find('.collapse.in');

      if actives && actives.length
        actives.collapse('hide');

      target = $this.attr('data-target') || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, ''); #strip for ie7

      $(target).collapse('toggle');
      holder = $this.parents('.panel').find('.holder')
      url = $this.data 'url'
      if holder && url && holder.attr('src') != url
        holder.attr 'src', url
        holder.parent('span.zoom').zoom
          magnify: 1
      event.preventDefault();
    drawTags()

  #start up scripts go here
  $('#floors.building').hide()
  $('select#customer').change()
  $('.update-button').click ->
    open_tag = window.open_tag
    if open_tag
      json = open_tag.json
      json.name = $('#edittagform #name').val()
      open_tag.x = parseInt $('#edittagform #x').val()
      open_tag.y = parseInt $('#edittagform #y').val()
      open_tag.img.attr 'title', json.name
      open_tag.zimg.attr 'title', json.name
      open_tag.update_json()
      $.ajax
        url: 'tags/' + json.id
        type: 'PUT'
        data:
          tag:
            x: open_tag.x
            y: open_tag.y
            name: json.name
      open_tag = null
      drawTags()
    $.fancybox.close()

  $('.delete-button').click ->
    open_tag = window.open_tag
    if open_tag
      $.ajax
        url: 'tags/' + open_tag.json.id
        type: 'PUT'
        data:
          tag:
            x: null
            y: null
            floor_id: null
      open_tag.delete()
      open_tag = null
      drawTags()
    $.fancybox.close()

  if $('#graphdiv3').length > 0
    $('.sensor-select').chosen
      allow_single_deselect: true
      no_results_text: 'No results matched'
      width: '600px'
      placeholder_text_multiple: 'Sensors to Plot'

    axes = x:
      ticker: Dygraph.dateTicker
      old_axisLabelFormatter: (d, gran) ->
        Dygraph.zeropad(d.getHours()) + ":" + Dygraph.zeropad(d.getMinutes()) #+ ":" + Dygraph.zeropad(d.getSeconds()) + "." + Dygraph.zeropad(d.getMilliseconds())
      valueFormatter: Dygraph.dateString_
      axisLabelFormatter: Dygraph.dateString_

    $('#plot_button').click ->
      selected_tags = $('.sensor-select').val()
      if selected_tags?
        tags = selected_tags.join('+')
        type = $('.plot-type').val()
        switch type
          when 'temp'
            title = 'Temperature (°C)'
          when 'humidity'
            title = 'Humidity (%)'
          when 'zone'
            title = 'Comfort Zone'
        document.cookie = "selected_tags=#{tags}; plot_type=#{type}; expires=10 Sep 2020 12:00:00 UTC"
        g3 = new Dygraph $('#graphdiv3')[0], "data/#{type}/#{tags}",
          legend: 'always'
          title: title
          showRangeSelector: true
          xValueParser: (x) -> parseInt(x)
          axes: axes
          labelsSeparateLines: true
          labelsDiv: $('#legend')[0]
          width: 800
          height: 320
          connectSeparatedPoints: true
          drawGapEdgePoints: true
      else
        document.cookie = "selected_tags=null; plot_type=null; expires=10 Sep 2020 12:00:00 UTC"
    $('#plot_button').click()
  $('#datetimepicker1').datetimepicker()
  $('#datetimepicker2').datetimepicker()
  plotit = (t1, t2) ->
    tags = $('#selected_tag').val()
    title = 'DP (pa)'
    g3 = new Dygraph $('#graphdiv3')[0], "/data/#{tags}/from/#{t1}/to/#{t2}",
      legend: 'always'
      title: title
      showRangeSelector: true
      xValueParser: (x) -> parseInt(x)
      axes: axes
      labelsSeparateLines: true
      labelsDiv: $('#legend')[0]
      width: 800
      height: 320
      connectSeparatedPoints: true
      # drawGapEdgePoints: true
  $('#plot-graph').click ->
    t1 = $('#datetimepicker1').data('DateTimePicker').getDate().toDate().getTime()
    t2 = $('#datetimepicker2').data('DateTimePicker').getDate().toDate().getTime()
    if t2 <= t1
      alert '"From" should be before "To"'
    else
      plotit(t1, t2)
Turbolinks.enableProgressBar()
$(document).on 'page:change', start
