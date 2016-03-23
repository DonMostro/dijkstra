# dijkstra
Graphic implementaction of Dijkstra Algorith

Installer requires apache ant

Steps

Build the project, install database and resolve php dependences
```
ant -D db.password={your mysql password}
```

Resolve and patch javascript dependences of Tangerine 
```
ant tangerine-bower
```

Generate Apache alias for Tangerine javascript libs  
```
ant tangerine-alias
```
