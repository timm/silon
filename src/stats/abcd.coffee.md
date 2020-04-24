<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>

# Log Precision, recall etc

    src = process.env.SILON or  "../../src" 
    {say,saym,sayr,p2} = require src+'/lib/fun'

Code

    class Abcd
      constructor:  ->
        @a   = {} ; @b  = {} ; @c   = {} ; @d = {}
        @yes = 0  ; @no = 0  ; @all = {}
      # --------- --------- --------- ---------
      toString: -> "#{@yes+@no}= #{@yes}+#{@no} :acc #{@acc()} "
      acc:      -> if (@yes+@no) > 0 then @yes / (@yes+@no) else 0
      # --------- --------- --------- ---------
      add:(want,got) ->
        @known(want)
        @known(got)
        if want is got then @yes +=1 else @no += 1
        for it,_ of @all
          @known(it)
          if (want is it)
            if got is want then @d[it] += 1 else @b[it] += 1
          else
            if got is it then @c[it] += 1 else @a[it] += 1
      # --------- --------- --------- ---------
      known: (x) ->
        @a[x] or= 0
        @b[x] or= 0
        @c[x] or= 0
        @d[x] or= 0
        @a[x]= @yes + @no if ++@all[x] is 1
      # --------- --------- --------- ---------
      report1: (k,a,b,c,d) ->
        y    = {}
        y.pd = y.pf = y.prec = y.f = y.g = y.pn = 0
        y.class = k
        y.a = a
        y.b = b
        y.c = c
        y.d = d
        y.prec = d / (c+d) if (c+d) > 0
        y.pd = d     / (b+d) if (b+d) > 0
        y.pf = c     / (a+c) if (a+c) > 0
        y.pn = (b+d) / (a+c) if (a+c) > 0
        y.g  = 2*(1-y.pf)*y.pd/(1-y.pf+y.pd) if (1-y.pf+y.pd)> 0
        y.f  = 2*y.prec*y.pd  /(y.prec+y.pd) if (y.prec+y.pd)> 0
        y.acc = @acc()
        y
      # --------- --------- --------- ---------
      report: (show=false,y=[]) ->
        all = ["a"] #["a","b","c","d","acc","pd","pf","prec","g","f"]
        all1 = all.push  "class"
        y.push all1
        for k,val of @all
          tmp = @report1 k,@a[k],@b[k],@c[k],@d[k]
          sayr tmp
          tmp = (tmp[k] for k in all)
          tmp.push k
          all.push tmp
        if show
          saym all
        y

End stuff

    @Abcd = Abcd


