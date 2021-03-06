<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>

# Naive Bayes

    src           = process.env.SILON or "../../src"
    {the}         = require src+'/lib/the'
    {Table}       = require src+'/data/Table'
    {Abcd}        = require src+'/stats/abcd'
    {id,say,show} = require src+'/lib/fun'

Code:

    class Nb extends Table
      constructor: (args...) ->
        super args...
        [ @m,@k,@wait,@nKlasses ] = [ 2,1,5,0 ]
        [ @klasses,@log         ] = [ {}, new Abcd ]
      row: (l,id) ->
        out = super.row(l,id)
        @classify(l) if  @rows.length > @wait
        @known( @klassVal(l) ).add l
        out
      classify: (l) ->
        [got] = @mostLikely(l)
        want  = @klassVal(l)
        @log.add want, got
      known: (k) ->
        unless k of @klasses
          @klasses[k] = @clone()
          @nklasses++
        @klasses[k]
      mostLikely: (l,   got,x,best= -Infinity) ->
        for k,t of @klasses
          got or= k
          tmp = t.like(k,l,@,@m,@k)
          [ got,best ] = [ k,tmp ] if tmp > best
        #say "got #{got} nest #{best}"
        [ got,best ]

Exports:

    @Nb= Nb
