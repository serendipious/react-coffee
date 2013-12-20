{DOM} = require 'react'
Mixin = require 'mixto'

TagNames = """
  a abbr address area article aside audio b base bdi bdo big blockquote body br
  button canvas caption cite code col colgroup data datalist dd del details dfn
  div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6
  head header hr html i iframe img input ins kbd keygen label legend li link main
  map mark menu menuitem meta meter nav noscript object ol optgroup option output
  p param pre progress q rp rt ruby s samp script section select small source
  span strong style sub summary sup table tbody td textarea tfoot th thead time
  title tr track u ul var video wbr circle g line path polyline rect svg text
""".split(/\s+/)

module.exports =
class DOMBuilder extends Mixin
  for tagName in TagNames
    do (tagName) => @::[tagName] = (args...) -> @component(tagName, args...)

  childrenStack: null

  component: (component, args...) ->
    for arg in args
      switch typeof arg
        when 'function' then content = arg
        when 'string', 'number' then text = arg.toString()
        when 'object' then attributes = arg

    if content?
      @pushChildren()
      content.call(this)
      children = @popChildren()
    else if text?
      children = [text]
    else
      children = []

    if typeof component is 'string'
      @appendChild(DOM[component](attributes, children...))
    else
      @appendChild(new component(attributes, children...))

  text: (text) ->
    @appendChild text

  pushChildren: ->
    @childrenStack ?= []
    @childrenStack.push([])

  popChildren: ->
    @childrenStack.pop()

  appendChild: (child) ->
    @childrenStack?[@childrenStack.length - 1]?.push(child)
    child
