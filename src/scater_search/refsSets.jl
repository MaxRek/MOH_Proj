include("../struct/orderedVector.jl")
include("../scater_search/sets.jl")
include("../dominance.jl")

function build_refSets(pop :: Vector{solution}, beta :: Int64)
    refsets = Vector{Vector{solution}}()
    sorted_z1,sorted_z2 = sort_pop_by_z(pop)
    push!(refsets,Vector{solution}())
    push!(refsets,Vector{solution}())

    half = round(Int64,beta/2)
    #println("Ajout meilleur solutions")
    for i in 1:half
        push!(refsets[1],sorted_z1[i])
        push!(refsets[2],sorted_z2[i])    
    end
    sorted_z1 = sorted_z1[half:size(pop)[1]]
    sorted_z2 = sorted_z2[half:size(pop)[1]]

    #println("Ajout solutions diverses")
    d_pop = v_calc_distance(pop)
    
    for i in 1:beta-half
        push!(refsets[1],pop[d_pop[(i*2)-1]])
        push!(refsets[2],pop[d_pop[(i*2)]])
    end
    return refsets
end

function actualize_refSets(refSets :: Vector{Vector{solution}}, A_improved :: orderedVector, beta)
    #we don't need to
    refR = deepcopy(refSets)
    S = toArray(A_improved)
    #Iterate on all non dominated solutions in A_improved
    for i in 1:size(S)[1]
        domS = [0,0]
        ind = Vector{Tuple{Int64,Int64}}()

        #Going to check which sets it dominates more. Most likely the one to which the solution was improved for.
        for j in 1:2
            for k in 1:beta
                if dominates((S[i][1],S[i][2]),(refSets[j][k].z1,refSets[j][k].z2)) == 1
                    domS[j] += 1
                    push!(ind, (j,k))
                end
            end
        end
        #println(domS)
        
        #Equal solutions, checking distances for both, we check distance for both
        if(domS[1]==domS[2])
            # println(" ----------------- No pref ----------------- ")
            d = zeros(Int64, 1, size(ind)[1])
            i_1 = Vector{Int64}()
            subpop = Vector{solution}()
            for i in 1:size(ind)[1]
                if(ind[i][1]==1)
                    push!(subpop, refSets[1][ind[i][2]])
                    push!(i_1,i)
                else
                    push!(subpop, refSets[2][ind[i][2]])
                end
            end
            Ai = calc_distance_i_pop(A_improved.vec[i], subpop)
            # println("Ai = ",Ai)

            #no duplicates
            if(sum(Ai) > 0)
                ip = sortperm(Ai,rev=true)[1]
                # println("ip = ",ip)
                # println("i_1 = ",i_1)

                if(ip in i_1)
                    popat!(refR[1],ind[ip][2])
                    push!(refR[1],A_improved.vec[i])
                else
                    popat!(refR[2],ind[ip-size(i_1)[1]][2])
                    push!(refR[2],A_improved.vec[i])
                end
            end
        else
            #More dominated solutions in z1
            if(domS[2]>domS[1])
                # println("----------------- z1 dominated ----------------- ")
                filter!(x->x[1]==1,ind)
                d = zeros(Int64, 1, size(ind)[1])
                subpop = Vector{solution}()
                for i in 1:size(ind)[1]
                    push!(subpop, refSets[1][ind[i][2]])
                end
                Ai = calc_distance_i_pop(A_improved.vec[i], subpop)
                # println("Ai = ",Ai)
                # println("ind = ",ind)

                #no duplicates
                if(sum(Ai) > 0)
                    ip = sortperm(Ai,rev=true)[1]
                    # println("ip = ",ip)
                    popat!(refR[1],ind[ip][2])
                    push!(refR[1],A_improved.vec[i])
                end
            else
                #More dominated solutions in z2
                # println("----------------- z2 dominated ----------------- ")

                filter!(x->x[1]==2,ind)
                d = zeros(Int64, 1, size(ind)[1])
                subpop = Vector{solution}()
                for i in 1:size(ind)[1]
                    push!(subpop, refSets[2][ind[i][2]])
                end
                Ai = calc_distance_i_pop(A_improved.vec[i], subpop)
                # println("Ai = ",Ai)
                # println("ind = ",ind)
                #no duplicates
                if(sum(Ai) > 0)
                    ip = sortperm(Ai,rev=true)[1]
                    #println("ip = ",ip)
                    popat!(refR[2],ip)
                    push!(refR[2],A_improved.vec[i])
                end
            end
        end
        # print_refSets(refSets)
        # print_refSets(refR)
    end
end

function print_Population(pop :: Vector{solution})
    s = size(pop)[1]
    ov = orderedVector(Vector{solution}())
    A = Vector{Tuple{Int64,Int64}}()
    for i in 1:s
        push!(A,(pop[i].z1,pop[i].z2))
        insert(ov, pop[i])
    end
    println("Pop s = ",s,", ind = ",A)
    println("ov = ",toArray(ov))
end

function print_refSets(refSets :: Vector{Vector{solution}})
    println("Refsets = ")
    for i in 1:size(refSets)[1]
        print_Population(refSets[i])
    end
end

function rand_in_pop(pop :: Vector{solution})
    return pop[round(Int64, rand()*(size(pop)[1]-1))+1]
end