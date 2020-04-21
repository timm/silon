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

    src           = "../../src/"
    {the}         = require src+'lib/the'
    {Table}       = require src+'data/Table'
    {id,say,show} = require src+'lib/fun'

Code:

    class Nb extends Table
      constructor: (args...) ->
        super args...
        [ @m,@k,@wait,@klasses,@nKlasses ] = [ 2,1,10,{},0 ]
      row: (l,id) ->
        out = super.row(l,id)
        @classify(l) unless --@wait > 0
        @learn l
        out
      known: (k) ->
        unless k in @klasses
          @klasses[k] = clone()
          @nklasses++
        @klasses[k]
      learn: (l) ->
        @known( @klassVal(l) ).add l
      classify: (l, out, best=0) ->
        for k,t of @klasses
          out or= k
          tmp = t.like(l,@)
          [ best,out ] = [ k,tmp ] if tmp > best
        [out,best]

Exports:

    @Nb = Nb
