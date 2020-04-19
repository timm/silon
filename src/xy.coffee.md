<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>


    {the}         = require '../src/the'
    {id,say,show} = require '../src/fun'
    {FastMap}     = require '../src/fastmap'

Recursive clustering:

    class Xy
      constructor: (t)->
        @x = new FastMap(t)
        @y = new FastMap(t)
        @x.cols = (u) -> u.x
        @y.cols = (v) -> v.y
      split: ->
        @x.split()
        @y.split()
        @
      doms: ->
        l = {}
        @x.leaves((z) -> 
           l[ id(z) ] = {doms:0, z:z, rule:z.mid()})
        for zid1,o1 of l
          o1.doms = 0
          for zid2,o2 of l
            if o1.rule.dominates(o2.rule, o1.z.y)
              o1.doms++
        l
       
Exports:

    @Xy = Xy
