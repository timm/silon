<a name=top>&nbsp;</a><p>       
&nbsp;&nbsp;[home](http://tiny.cc/silon#top) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://tiny.cc/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>, Tim Menzies <<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br> [<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://tiny.cc/silon)<br>


    {the}  = require '../src/the'
    {say,id}  = require '../src/fun'
    {Row}  = require '../src/row'
    {Csv}  = require '../src/csv'
    {Sym}  = require '../src/sym'
    {Some} = require '../src/some'

Table

    class Table
      constructor:        -> [ @cols,@x,@y,@rows ] = [[],[],[],[]]
      klass:              -> @y[0]
      from:(f,after=same) -> new Csv f,((row) => @add row), (=> after(@))
      add:         (l,id) -> @cols.length and @row(l,id) or @top(l,id)
      top:  (l, id,pos=0) -> @cols = (@col(txt,pos++) for txt in l); l
      names:              -> (col.txt for col in @cols)
      dump:               -> say @names(); (say row.cells for row in @rows)
      # --------- --------- --------- --------- ---------  -----------
      mid: -> new Row (c.mid() for c in @cols)
      # --------- --------- --------- --------- ---------  -----------
      clone: (rows=[]) ->
        t=new Table
        t.add (c.txt for c in @cols)
        for row in rows
          t.add row.cells
        t
      # --------- --------- --------- --------- ---------   
      furthest:  (row1,cols,best=0, better=(x,y) -> x>y) ->
        for row2 in @rows
          if id(row1) isnt id(row2)
            tmp = row1.dist(row2,cols)
            if better(tmp,best)
              [ best,out ] = [ tmp,row2 ]
        out
      # --------- --------- --------- --------- ---------   
      nearest: (row1,cols) ->
        @furthest(row1, cols, 10**32, (x,y) -> x < y)
      # --------- --------- --------- --------- ---------   
      row: (l,id) -> 
        l=(col.add( l[col.pos] ) for col in @cols)
        @rows.push(new Row(l,id))
      # --------- --------- --------- ---------
      col: (txt,pos) ->
        what   = if Table.isNum(txt)   then Some else Sym
        where  = if Table.isY(txt)     then @y   else @x
        weight = if the.ch.less in txt then -1   else 1
        c      = new what(txt,pos,weight)
        where.push(c)
        c
      # --------- --------- --------- ---------
      @isNum= (txt) -> switch
        when the.ch.sym  in txt then false
        when the.ch.num  in txt then true
        when the.ch.less in txt then true
        when the.ch.more in txt then true
        else false
      # --------- --------- --------- ---------
      @isY= (txt) -> 
        the.ch.klass in txt or the.ch.less in txt or the.ch.more in txt
      # --------- --------- --------- ---------
      bins: () ->
        t = new Table
        t.add ((the.ch.sym + name) for name in @names())
        for row in @rows
          t.add ( col.bin(row.cells[col.pos]) for col in @cols )
        t

Exprt

    @Table = Table
