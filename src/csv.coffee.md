
    readline  = require 'readline'
    fs        = require 'fs'

    {the} = require "./the"
    {last} = require "./fun"

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
          @use or= (i for c,i in cells \
                    when the.ch.ignore not in c)
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

    @Csv = Csv

