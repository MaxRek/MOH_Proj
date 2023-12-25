include("../struct/orderedVector.jl")

function fill_xjk(s :: solution, Axjk :: Matrix{Int64}, AzJ :: Vector{Int64}, alpha :: Float64)
    #indexes = vec(collect(1:size(s.x)[1]))
    K = findall(x->x==1,s.zK)
    #println("K = ",K)

    for j in 1:size(s.x)[1]
        # i = indexes[rand_in_list(indexes)]
        i_b = 1
        v_i = typemax(Int64)
        for k in K
            if (Axjk[j,k] + AzJ[j]) < v_i
                v_i = (Axjk[j,k] + AzJ[j])
                i_b = k
            end
        end
        max_v_i = v_i*(1+alpha)
        #println("v_i = ", v_i,", max_v_i = ",max_v_i)

        indexes = Vector{Int64}()
        for k in K
            if (Axjk[j,k] + AzJ[j]) <= max_v_i
                #println("k = ",k)
                append!(indexes, k)
            end
        end
        #println("indexes = ",indexes)
        k = indexes[rand_in_list(indexes)]
        #println(k)
        s.x[j,k] = 1
        s.zJ[k] = 1

        #indexes = filter(x->x!=i,indexes)
        #println("i = ",i,", indexes = ",indexes)
    end

    return s
end

function fill_yij(s :: solution, I :: Int64, Ayij :: Matrix{Int64}, C :: Int64, alpha :: Float64)
    i_to_place = collect(1:I)
    while(size(i_to_place)[1] > 0)
        i=i_to_place[1]
        # sort by cost of yij
        perm = sortperm(Ayij[i,:])
        j = 1
        stop = false
        
        while(!stop)  
            if(sum(s.y[:,perm[j]]) >= C)
                #no more capacity on j concentrator, checking if more interesting to place this i instead of another one
                
                #getting all other i
                indexes = findall(x->x == 1, s.y[:,perm[j]])
                
                #compute their values compare to actual i
                A_act = Vector{Int64}()
                for ip in indexes
                    append!(A_act, Ayij[i,perm[j]]-Ayij[ip,perm[j]])
                end
                
                #checking if costs more interesting
                i_possible = findall(x->x < 0 ,A_act)

                if(size(i_possible)[1]>0)
                    #one cost reduce the value, pulling it out, and pushing new i
                    sort_i_possible = sortperm(A_act[i_possible])
                    append!(i_to_place,indexes[i_possible[sort_i_possible[1]]])
                    s.y[indexes[i_possible[sort_i_possible[1]]],perm[j]] = 0
                    filter!(!=(i),i_to_place)
                    stop = true
                    s.y[i,perm[j]] = 1
                else
                    #println("il n'y a pas d'element à remplacer")
                    j += 1
                end
            else
                #yij available
                filter!(!=(i),i_to_place)
                stop = true
                s.y[i,perm[j]] = 1
            end       
        end
        #println("i_to_place = ",i_to_place)
          
    end
    #removing unused zJ
    for j in 1:size(Ayij)[2]
        if sum(s.y[:,j]) > 0
            s.zJ[j] = 1
        else
            s.zJ[j] = 0
        end
    end
    return s
end

# function fill_yij(s :: solution)
#     for k in 1:size(s.y)[1]
#         s.y[k, rand_in_list(collect(1:size(s.y)[2]))] = 1
#     end
#     return s
# end

function rand_fill_solution(s :: solution)
    K = findall(x->x==1,s.zK)
    #println("I = ",I)
    for j in 1:size(s.x)[1]
        s.x[j,rand_in_list(K)] = 1
    end
    for k in 1:size(s.y)[1]
        s.y[k, rand_in_list(collect(1:size(s.y)[2]))] = 1
    end
    return s
end

function rand_in_list(list :: Vector{Int64})
    return round(Int64, rand()*(size(list)[1]-1))+1
end

function t_connected_to_cl1(column :: Vector{Int64})
    indexes = Vector{Int64}()
    for i in 1:size(column)[1]
        if column[i] == 1
            append!(indexes, i)
        end
    end
    return indexes
end