# bulbapedia-pokemon-parser
Parses Pokemon Lists from Bulbapedia

# usage
copy the table of pokemon from a bulbapedia page 
![bulbapedia](./pictures/HerPokemon.png)
and paste it into pokemon.txt
![pokemon.txt](./pictures/paste.png)

```shell
lua main.lua
```
copy or look at the pokemon in the pokemon showdown format
![console](./pictures/console.png)

optionally uncomment and comment lines
```lua
printShowdown(pokemon)
--printJSON(pokemon)
```
to get a json output

