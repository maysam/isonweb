window.open_tag = null
class @tag
  constructor: (@floor_id, @x,@y, @json) ->
    @uid = @json.uid
    if @json.obj
      @json.obj.delete()
    @json.obj = @
    @update_json()
    parent = _.find $('.zoom'), (zoom) => @floor_id - $(zoom).data('id') == 0
    @img = $('<img src="/images/tag-128.png" title="'+@json.name+'" rel="tipsy" />').addClass 'tag unzoom'
    @zimg = $('<img src="/images/tag-256.png" title="'+@json.name+'" rel="tipsy" />').addClass 'tag zoomed'
    @img.appendTo parent
    @zimg.appendTo parent
    @zimg.click => @.open()
    $('[rel=tipsy]').tipsy
      fade: true
      gravity: 'n'

  draw: (@holder, @zoomer)->
    return unless @holder.length
    return unless @zoomer.length
    i_left = Math.floor @holder.offset().left + @x * @holder.width() / @zoomer.width() - $('.128')[0].width/2
    i_top = Math.floor @holder.offset().top + @y * @holder.height() / @zoomer.height() - $('.128')[0].height/2

    @img.offset
      left: i_left
      top: i_top
    htop = parseInt @zoomer.offset().top
    hleft = @zoomer.offset().left
    z_left = Math.floor @x + hleft - $('.256')[0].width/2
    z_top = Math.floor @y + htop - $('.256')[0].height/2
    @zimg.offset
      left: z_left
      top: z_top

  delete: ->
    @json.x = null
    @json.y = null
    @json.floor_id = null
    @json.obj = null
    @img.remove()
    @zimg.remove()

  open: ->
    $('#edittagform #name').val @json.name
    $('#edittagform #uid').val @json.uid
    $('#edittagform #x').val @x
    $('#edittagform #y').val @y
    $('#edittagform .graph-button').attr('href', "/graph/#{@json.uid}")
    $.fancybox.open
      title: @json.uid
      href: '#edittagform'
    window.open_tag = @

  update_json: ->
    @json.x = @x
    @json.y = @y
    @json.floor_id = @floor_id

