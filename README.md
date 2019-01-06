# NearestNeighborDescent.jl

[![Build Status](https://travis-ci.com/dillondaudert/NearestNeighborDescent.jl.svg?branch=master)](https://travis-ci.com/dillondaudert/NearestNeighborDescent.jl) [![codecov](https://codecov.io/gh/dillondaudert/NearestNeighborDescent.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/dillondaudert/NearestNeighborDescent.jl) [![Coverage Status](https://coveralls.io/repos/github/dillondaudert/NearestNeighborDescent.jl/badge.svg?branch=master)](https://coveralls.io/github/dillondaudert/NearestNeighborDescent.jl?branch=master)

Julia implementation of the nearest neighbor descent algorithm described in:

Dong, Wei *et al.* Efficient K-Nearest Neighbor Graph Construction for Generic Similarity Measures. *WWW* (2011).

## Usage
The `DescentGraph` constructor builds the approximate kNN graph:
```jl
DescentGraph(data, n_neighbors, metric; max_iters, sample_rate, precision)
```
- `data`: The set of points to build the tree from. This must be of type
`Vector{V}`, where `V <: AbstractVector` **or** `AbstractMatrix`.
- `n_neighbors`: An integer specifies the number of neighbors to find
- `metric`: Any metric `M` where `M <: SemiMetric` from the Distances.jl package. Default is `Euclidean()`.

The performance of NN Descent can be tuned with several keyword arguments.
- `max_iters`: This controls the maximum number of iterations to search for
neighbors. Default is `10`.
- `sample_rate`: The algorithm performs a local join around the candidate
neighbors of each point during execution. The sample rate is the likelihood
that each candidate be included in the local join for an iteration. Default is
`1.`.
- `precision`: This argument roughly corresponds to the fraction of true
nearest neighbors that will be missed by the algorithm. Default `.001`.

The kNN graph can be accessed through the `graph` attribute. This is a
`KxN` matrix containing tuples of ids and distances to the neighbors, where
`K = n_neighbors` and `N = length(data)`.

Example:
```jl
using NearestNeighborDescent
data = [rand(10) for _ in 1:1000]
n_neighbors = 5

# nn descent search
knngraph = DescentGraph(data, n_neighbors)

# access nearest neighbors
knngraph.graph[k,n] # = (id, dist)
```

Once constructed, the `DescentGraph` can be used to find the nearest
neighbors to new points. This is done via the `search` method:
```jl
search(graph, queries, n_neighbors, queue_size) -> indices, distances
```
- `graph`: An instance of `DescentGraph`
- `queries`: A vector of new data points of type `Vector{V}`. Note that the
dimensionality of the queries should match that of the data used to originally
construct the graph.
- `n_neighbors`: The number of neighbors to find for each query. This does
*not* have to be the same as the number used to construct `graph`.
- `queue_size`: Each query maintains a heap of candidate neighbors.
`queue_size` controls the maximum number of candidates as a multiple of
`n_neighbors`. Default is `1.`.

Example:
```jl
queries = [rand(10) for _ in 1:100]
idxs, dists = search(knngraph, queries, 4)
```
