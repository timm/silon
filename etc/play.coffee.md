#console.log src

    {silon,KOD} =require "./silon"
    console.log silon.okTables
    console.log KOD

    say = (l...) ->
      sep=""
      for x in l
        process.stdout.write sep+x
        sep=", "
      process.stdout.write "\n" 

    say 1

