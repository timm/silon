The

    {the} = require "./the"
    {int,say,today,s4} = require "./fun"

Say

    class Ok
      @tries = 0
      @fails = 0
      @all   = {}
      @if    = (f,t) -> throw new Error t or "" if not f
      @go:  ->
        say "\n# " + "-".n() + "\n# " + today() + "\n"
        (Ok.run name,f for name,f of Ok.all)
      @fyi: (name) ->
        a= Ok.tries
        b= Ok.fails
        c= int(0.5 + 100*(a-b)/a)
        process.stdout.write "#{s4(a)} #{s4(c,3)}
                    %passed after failures= #{b} " 
        console.timeEnd(name)
      @run: (name,f) ->
        try
          Ok.tries++
          the.seed = 1
          console.time(name)
          await (f(); Ok.fyi(name))
        catch error
          Ok.fails++
          l = error.stack.split('\n')
          say l[0]
          say l[2]
          Ok.fyi(name)

    Ok.all.bad= -> 
      Ok.if 1 is 2,"deliberate error to check test engine"
    Ok.go()

Exports

    @Ok = Ok

