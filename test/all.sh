coffee all.coffee.md |
gawk '{ print $0
        fails += $7 
      }
END   { exit (fails > 1 ? 1: 0) }'
