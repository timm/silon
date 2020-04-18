<a name=top></a><p>       
&nbsp;&nbsp;[home](http://tiny.cc/silon#top) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://tiny.cc/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>, Tim Menzies <<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>

# csv.coffee.md

Read comma-seperated values from disk.

Imports:

    fs       = require 'fs'
    readline = require 'readline'
    {the}    = require "./the"
    {last}   = require "./fun"

Code:

    class Csv
      constructor: (file, action, done) ->
        @use     = null
        @lines    = []
        @action  = action
        Csv.linesDo file, @line, (done or ->)
      line: (s) =>
        if s
          s = s.replace /\s/g,''
          s = s.replace /#.*/,''
          @merge s if s.length
      merge: (s) ->
        @lines.push s
        if last(s) isnt ','
          @act @lines.join("").split ','
          @lines = []
      act: (cells) ->
        if cells.length
          @use or= (i for c,i in cells when the.ch.ignore not in c)
          @action (@prep cells[i] for i in @use)
      prep: (s) ->
        t = +s
        if Number.isNaN(t) then s else t
      @linesDo: ( file, action, done = (-> ) ) ->
        stream = readline.createInterface
          input:    fs.createReadStream file
          output:   process.stdout
          terminal: false
        stream.on 'close',           -> done()
        stream.on 'error', ( error ) -> action error
        stream.on 'line',  ( line  ) -> action line

Exports:

    @Csv = Csv
