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

    src   = process.env.SILON or "../../src"
    {Ok}  = require src+'/lib/ok'
    {Abcd}= require src+'/stats/abcd'
    {say,p2} = require src+'/lib/fun'

Code:

    Ok.all.abcd = {}
    Ok.all.abcd.one = ->
      """
      yes no maybe <- predicted as
      6            | yes
          2        | no
          1  5     | maybe
      """
      abcd = new Abcd
      abcd.add("yes","yes")     for i in [1..6]
      abcd.add("no","no")       for i in [1..2]
      abcd.add("maybe","maybe") for i in [1..5]
      abcd.add("maybe","no")
      abcd.report(show=true)
      #for f,v of y
      #  say f
      #  for f1,v1 of v
      #    say "   "+f1+'\t'+v1
      Ok.if 0.928 < y.yes.acc <0.93
      Ok.if 0.666 <  y.no.prec<  0.67
      Ok.if  0.909 < y.maybe.g< 0.91

    Ok.go "abcd"

