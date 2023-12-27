function fill_xjk(s :: solution, Axjk :: Matrix{Int64}, AzJ :: Vector{Int64}, alpha :: Float64)
    #indexes = vec(collect(1:size(s.x)[1]))
    K = findall(x->x==1,s.zK)
    #println("alpha = ",alpha)


    for j in 1:size(s.x)[1]
        # i = indexes[rand_in_list(indexes)]
        min_v_i = typemax(Int64)
        max_v_i = typemin(Int64)

        for k in K
            #println(" Axjk[j,k] + AzJ[j] = ", Axjk[j,k] + AzJ[j])
            if (Axjk[j,k] + AzJ[j]) < min_v_i
                min_v_i = (Axjk[j,k] + AzJ[j])
            else 
                if(Axjk[j,k] + AzJ[j] > max_v_i)  
                    max_v_i = (Axjk[j,k] + AzJ[j])
                end
            end
        end
        threshold = min_v_i + alpha * (max_v_i - min_v_i)
        #println("min_v_i = ", min_v_i,", max_v_i = ",max_v_i,", threshold = ",threshold)

        indexes = Vector{Int64}()
        for k in K
            if (Axjk[j,k] + AzJ[j]) <= threshold
                #println("k = ",k)
                append!(indexes, k)
            end
        end
        #println("indexes = ",indexes)
        k = indexes[rand_in_list(indexes)]
        s.x[j,k] = 1
        s.zJ[k] = 1

        #indexes = filter(x->x!=i,indexes)
        #println("i = ",i,", indexes = ",indexes)
    end

    return s
end

# 

function connect_i_yij(s :: solution, Ai :: Vector{Int64} ,Ayij :: Matrix{Int64}, C :: Int64)
    i_to_place = deepcopy(Ai)
    while(size(i_to_place)[1] > 0)
        i=i_to_place[1]
        # sort by cost of yij
        perm = sortperm(Ayij[i,findall(x->x==1,s.zJ)])
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
            s.x[j,:] = vec(zeros(Int64, 1, K))
        end
    end
    return s
end

function close_c_l1(j :: Int64, zJ :: Vector{Int64}, x :: Matrix{Int64},y :: Matrix{Int64})
    zJ[j] = 0
    x[j,:] .= 0
    Ai = findall(x->x==1, y[:,j])
    y[:,j] .= 0
    return Ai
end

function costs_others_j(s :: solution ,Cj :: Vector{Int64}, yij :: Vector{Vector{Int64}} , xjk :: Vector{Vector{Int64}} ,Axjk :: Matrix{Int64}, Ayij :: Matrix{Int64}, AzJ :: Vector{Int64})
    s.z1 = calcZ1(s.x,s.y,s.zJ,s.zK, AzK, AzJ, Axjk, Ayij)
    zJ = findall(x->x==1,s.zJ)
    J = size(zJ)[1]
    
    cost_j = zeros(Int64, 1, J)
    s_j = Vector{solution}()

    #Adapting all cost for cost_j
    for j in 1:J
        cost_j[j] -= (AzJ[zJ[j]] + Axjk[zJ[j],xjk[j][1]]) 
    end
    
    #println(yij)

    #Checking for all open zJ, canceling the one concerned
    for j in 1:J
        zJ = findall(x->x==1,s.zJ)
        println("zJ = ",zJ,", j = ",j)
        copy_Cj = copy(Cj)
        copy_y = copy(s.y)
        copy_x = copy(s.x)
        copy_zj = copy(s.zJ)
        println("        copy_zj = ",copy(s.zJ))
        Ai = close_c_l1(zJ[j], copy_zj, copy_x, copy_y)
        println("        copy_zj = ",copy(s.zJ))

        #Checking for all i connected to j 
        for i in 1:size(yij)[1]
            i_to_place = yij[i]
            while(size(i_to_place)[1]>0)
                #println("______________________\ni_to_place = ",i_to_place," i = ",i)
                #println("yij =  ",yij[i])
                ip = i_to_place[1]
                perm = sortperm(Ayij[ip,zJ])
                #println("perm = ",perm)
                ind = 1
                stop = false
                while(!stop)
                    #println("copy_Cj = ",copy_Cj)
                    if(copy_Cj[perm[ind]] >= C)
                        #println("failed capacity")

                        #no more capacity on j concentrator, checking if more interesting to place this i instead of another one
                        
                        #getting all other i
                        indexes = findall(x->x == 1, copy_y[:,perm[ind]])
                        
                        #compute their values compare to actual i
                        A_act = Vector{Int64}()

                        #For all connections
                        for ip in indexes
                            append!(A_act, Ayij[ip,perm[ind]]-Ayij[ip,perm[ind]])
                        end
                        
                        #checking if costs more interesting
                        i_possible = findall(x->x < 0 ,A_act)
        
                        if(size(i_possible)[1]>0)
                            #one cost reduce the value, pulling it out, and pushing new i
                            sort_i_possible = sortperm(A_act[i_possible])
                            append!(yij[ip],indexes[i_possible[sort_i_possible[1]]])
                            copy_y[indexes[i_possible[sort_i_possible[1]]],perm[ind]] = 0
                            filter!(!=(i),yij[ip])
                            stop = true
                            copy_y[ip,perm[ind]] = 1
                        else
                            #println("il n'y a pas d'element à remplacer")
                            ind += 1
                        end
                    else
                        #println("pas de probleme de capacité")
                        #println("i_to_place = ",i_to_place," i = ",i)

                        #yij available
                        i_to_place = filter(!=(ip),i_to_place)
                        #println("post i_to_place = ",i_to_place)
                        stop = true
                        copy_y[ip,perm[ind]] -= 1
                    end
                end
            end
        end
        println("copy_zj = ",copy_zj)
        #println("z1 = ",s.z1,", calcZ1 = ",calcZ1(copy_x,copy_y,copy_zj,s.zK, AzK, AzJ, Axjk, Ayij))
        cost_j[j] += (calcZ1(copy_x,copy_y,copy_zj,s.zK, AzK, AzJ, Axjk, Ayij))
        push!(s_j,solution(0,0,copy_x,copy_y,copy(s.zK),copy_zj))
        return cost_j
    end
end

# function fill_yij(s :: solution, I :: Int64, Ayij :: Matrix{Int64}, C :: Int64)
#     i_to_place = collect(1:I)
#     while(size(i_to_place)[1] > 0)
#         i=i_to_place[1]
#         # sort by cost of yij
#         perm = sortperm(Ayij[i,:])
#         j = 1
#         stop = false
        
#         while(!stop)  
#             if(sum(s.y[:,perm[j]]) >= C)
#                 #no more capacity on j concentrator, checking if more interesting to place this i instead of another one
                
#                 #getting all other i
#                 indexes = findall(x->x == 1, s.y[:,perm[j]])
                
#                 #compute their values compare to actual i
#                 A_act = Vector{Int64}()
#                 for ip in indexes
#                     append!(A_act, Ayij[i,perm[j]]-Ayij[ip,perm[j]])
#                 end
                
#                 #checking if costs more interesting
#                 i_possible = findall(x->x < 0 ,A_act)

#                 if(size(i_possible)[1]>0)
#                     #one cost reduce the value, pulling it out, and pushing new i
#                     sort_i_possible = sortperm(A_act[i_possible])
#                     append!(i_to_place,indexes[i_possible[sort_i_possible[1]]])
#                     s.y[indexes[i_possible[sort_i_possible[1]]],perm[j]] = 0
#                     filter!(!=(i),i_to_place)
#                     stop = true
#                     s.y[i,perm[j]] = 1
#                 else
#                     #println("il n'y a pas d'element à remplacer")
#                     j += 1
#                 end
#             else
#                 #yij available
#                 filter!(!=(i),i_to_place)
#                 stop = true
#                 s.y[i,perm[j]] = 1
#             end       
#         end
#         #println("i_to_place = ",i_to_place)
            
#     end
#     #removing unused zJ
#     for j in 1:size(Ayij)[2]
#         if sum(s.y[:,j]) > 0
#             s.zJ[j] = 1
#         else
#             s.zJ[j] = 0
#         end
#     end
#     return s
# end