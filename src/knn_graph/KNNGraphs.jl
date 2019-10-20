module KNNGraphs

using Distances: PreMetric, SemiMetric, result_type, evaluate
using DataStructures: BinaryMaxHeap, top, pop!

# imports for adding method definitions
import Base: eltype, ==, <, isless
import LightGraphs: AbstractGraph, edges, edgetype, has_edge, has_vertex, inneighbors, ne, nv
import LightGraphs: outneighbors, vertices, is_directed, AbstractEdge, src, dst, reverse


# Abstract KNN Graph definitions
"""
ApproximateKNNGraph{V, K} subtypes are weighted, directed graphs where each vertex
has exactly `k` forward edges.
"""
abstract type ApproximateKNNGraph{V, K, U <: Real} <: AbstractGraph{V} end

# interface
eltype(::ApproximateKNNGraph{V, K, U}) where {V, K, U} = V
# all knn graphs are directed
is_directed(::Type{<:ApproximateKNNGraph}) = true
is_directed(::ApproximateKNNGraph) = true

include("heap_edge.jl")
include("heap_graph.jl")
include("heap_utils.jl")

end
