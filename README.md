# Dijkstra

djisktra is a gem that constructs a graph and finds the shortest path between two user-supplied points.

The gem is a CLI application that accepts three arguments.

* The first argument is the name of the file that represents the graph
* The second argument is the name of the starting node
* The third argument is the name of the ending node

## Installation & Usage
`$ rake build`

`$ cd pkg`

`$ gem install --local ./dijkstra-1.0.0.gem`

`$ dijkstra my_graph.txt A G`

## Graph Files Look Like This
```
[A,B,1]
[A,C,2]
[B,C,3]
[B,D,3]
[C,D,1]
[B,E,2]
[D,F,3]
[D,E,3]
[E,G,3]
[F,G,1]
```
## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

