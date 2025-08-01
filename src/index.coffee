import FS from "node:fs/promises"

Pkg =

  read: ->
    JSON.parse await FS.readFile "package.json", "utf8"

  getName: ( qname ) ->
    if qname.startsWith "@"
      ( qname.split "/" )[ 1 ]
    else qname

  isPreset: ( qname ) ->
    name = Pkg.getName qname
    name.startsWith "drn-"

Resolvers =

  load: load = ( drn ) ->
    pkg = await do Pkg.read
    qnames = Object
      .keys pkg.devDependencies
      .filter ( qname ) -> Pkg.isPreset qname
    if drn?.loader?.presets?
      qnames = [ qnames..., drn.loader.presets... ]
    for qname in qnames
      console.log { qname }
      require require.resolve qname, 
        paths: [ "./node_modules" ]

export default Resolvers
export { load }