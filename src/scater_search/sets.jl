include("../struct/orderedVector.jl")

# don't have struct on his own, but is traited as Vector{Vector{solution}}

#dedicated "methods"

function building_sets(pop :: Vector{solution})
    #init
    sets = Vector{orderedVector}()
    copy_pop = deepcopy(pop)
    i = 1
    #iteration, we put all solution in orderedVector, would imply dominates, therefore will 
    while(!isempty(copy_pop))
        #println(copy_pop)
        #print_sets(sets)
        push!(sets,orderedVector(Vector{solution}()))
        for j in 1:size(copy_pop)[1]
            insert(sets[i],copy_pop[j])
        end
        
        #taking all z1,z2 of orderedVector of rank i, used to remove from copy_pop
        Z = ToArray(sets[i])
        #println(Z)
        filter!((x)->!((x.z1,x.z2) in Z),copy_pop)
        
        #preparation for next itération
        i += 1
    end
    #all solution has been ranked in adequate set, returning all sets

    return sets
end

function print_sets(sets :: Vector{orderedVector})
    if isempty(sets)
        println("sets vide")
    else
        for i in 1:size(sets)[1]
            println("______ Rank ",i," _________")
            println(ToArray(sets[i]))
        end
    end
end

function toArray(sets :: Vector{orderedVector})
    r_sets = Vector{Vector{Tuple{Int64,Int64}}}()
    for i in 1:size(sets)[1]
        push!(r_sets,Vector{Tuple{Int64,Int64}}())
        for j in 1:size(sets[i].vec)[1]
            push!(r_sets[i],(sets[i].vec[j].z1,sets[i].vec[j].z2))
        end
    end
    return r_sets
end

function sort_pop_by_z(pop :: Vector{solution})
    s = size(pop)[1]
    ind_z1 = zeros(Int64,1,s)
    ind_z2 = zeros(Int64,1,s)

    for i in 1:s
        ind_z1[1,i] = pop[i].z1
        ind_z2[1,i] = pop[i].z2
    end

    return pop[sortperm(vec(ind_z1), rev=true)], pop[sortperm(vec(ind_z2), rev=true)]
end

function calc_distance_i_pop(s :: solution, pop :: Vector{solution})
    d = size(pop)[1]
    Ar = Vector{Int64}()
    for j in 1:d
        push!(Ar,calc_distance(s,pop[j]))
    end
    return Ar
end

function v_calc_distance(pop :: Vector{solution})
    s = size(pop)[1]
    Ar = zeros(Int64, 1, s)
    for i in 1:s
        copy_pop = deepcopy(pop)
        popat!(copy_pop, i)
        Ar[i] = minimum(calc_distance_i_pop(pop[i],copy_pop))
    end

    #println("Ar = ",Ar)
    #println("sortperm = ",sortperm(vec(Ar),rev=true))
    return sortperm(vec(Ar),rev=true)
end