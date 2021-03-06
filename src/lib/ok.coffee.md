<a name=top></a><p>       
&nbsp;[home](http://git.io/silon) ::
[src](https://github.com/timm/silon/raw/master/src) ::
[issues](http://git.io/silon) ::
<a href="https://github.com/timm/silon/raw/master/raw/master/LICENSE.md">&copy; 2020</a>,
Tim Menzies
<<a href="mailto:timm@ieee.org">timm&commat;ieee.org</a>>
<br>
[<img width=900 src="https://github.com/timm/silon/raw/master/etc/img/banner.jpg">](http://git.io/silon)<br>

# OK

Unit tests.

    {the} = require '../../src/lib/the'

Code: 

    say = (l...) -> process.stdout.write l.join(", ") + "\n"
    today = () -> Date(Date.now()).toLocaleString().slice(0,25)
    s3= (n) ->  ('   '+n).slice(-3)

    class Ok
      @tries = 0
      @fails = 0
      @now   = ""
      @all   = {}
      @if    = (f,t) -> throw new Error t or "" if not f
      @go:  (now = "ok") ->
        say "\n# "+\
            "------------------------------------------------"+\
            "\n# " + today() + "\n"
        Ok.now = now
        (Ok.run name,f for name,f of Ok.all[now])
        true
      @fyi: (name,t1) ->
          a  = Ok.tries
          b  = Ok.fails
          c  = Math.floor(0.5 + 100*(a-b)/a)
          t2 = (new Date).getTime()
          say "#{Ok.now} #{s3(a)}) #{s3(c)} %passed after failures= 
              #{b} : #{name} in #{t2-t1} ms"
      @run: (name,f) ->
         t1 = (new Date).getTime()
         try
           Ok.tries++
           the.seed = 1
           await (f(); Ok.fyi(name,t1))
         catch error
           Ok.fails++
           l = error.stack.split('\n')
           say l[0]
           say l[2]
           Ok.fyi(name,t1)

Exports:

    @Ok = Ok
