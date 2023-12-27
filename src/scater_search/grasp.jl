include("../struct/solution.jl")
include("../model/model.jl")
include("tools.jl")

function grasp(Ac :: Vector{Vector{Int64}}, M :: Int64 ,C :: Int64 , alpha :: Vector{Float64},p = 0)
    K = size(Ac[5])[1]
    J = size(Ac[4])[1]
    I = Int(size(Ac[3])[1]/J)
    Ad = reshape(Ac[1],K,K)
    Axjk = reshape(Ac[2],J,K)
    Ayij = reshape(Ac[3],I,J)
    AzJ = Ac[4]

    #println("I = ",I," J = ",J," K = ",K)

    solution = init_solution(I,J,K)
    
    #z2
    solution.zK = vec(grasp_z2(Ad, K, p, M, alpha[1]))
    #println("zK = ",solution.zK)

    #z1
    solution = grasp_z1(solution, I,J,K,C, Axjk, Ayij, AzJ ,alpha[2])

    return solution
end

function grasp_z1(s :: solution, I :: Int64, J :: Int64, K :: Int64, C :: Int64 , Axjk :: Matrix{Int64}, Ayij :: Matrix{Int64}, AzJ :: Vector{Int64}, alpha :: Float64)
    # println("I = ",I," J = ",J," K = ",K)
    
    # println(m_cl2_cl1)
    # println(m_cl1_t)    

    #filling xjk for the almost best grasp, at least one connection to k
    s = fill_xjk(s, Axjk, AzJ,alpha[1])

    #Filling yij with the best choices, opening all zJ
    s = connect_i_yij(s, collect(1:I) ,s.zJ,Ayij, C)

    #Using DROP_heuristics for facility location and grasp
    #s = grasp_drop_heuristic(s,I,J,K,C, Axjk, Ayij, AzJ,alpha[3])

    return s
end

function capacitated_drop_heuristic(s :: solution, I :: Int64, J :: Int64, K :: Int64, C :: Int64, Axjk :: Matrix{Int64}, Ayij :: Matrix{Int64}, AzJ :: Vector{Int64})
    AzJ = Ac[3]

    cost_r = 1
    min_cost = 0
    max_cost = typemin(Int64)

    while cost_r > 0
        z1 = calcZ1(s.x,s.y,s.zJ,s.zK, AzK, AzJ, Axjk, Ayij)
        zJ = findall(x->x == 1, s.zJ)
        J = size(zJ)[1]

        gains = zeros(1, J)
        yij = Vector{Vector{Int64}}()
        xjk = Vector{Vector{Int64}}()
        Cj = zeros(Int64, 1, J)
        Cj = Cj .+ C
        
        #print(Cj)
        
        #getting all connections between t and c_l1, c_l2 and c_l1
        for j in 1:J
            push!(yij, findall(x->x == 1,s.y[:,zJ[j]]))
            push!(xjk, findall(x->x == 1,s.x[zJ[j],:]))
        end


        #Adapting capacity for all c_l1
        for j in 1:size(yij)[1]
            Cj[j] -= size(yij[j])[1] 
        end

        #Calculating the revenue to close one c_l1 at best
        cost_j = costs_others_j(s, zJ, vec(Cj), yij, xjk, Axjk, Ayij, AzJ)
        j_close = 1
        max_cost = cost_j[1]
        for j in 2:J
            if(cost_j[j] < max_cost)
                j_close = j
                max_cost = cost_j[j]
            end
        end

        # println("cost_j = ",cost_j)
        # println("max_cost = ",max_cost," ,j = ",j_close)
        #print_solution(s)
        # println("z1 = ",z1,", calcZ1 = ",calcZ1(s.x,s.y,s.zJ,s.zK, AzK, AzJ, Axjk, Ayij))

        
        Ai = close_c_l1(j_close, s.zJ, s.x, s.y)
        # println("Ai = ",Ai, ", z1 = ",z1,", calcZ1 = ",calcZ1(s.x,s.y,s.zJ,s.zK, AzK, AzJ, Axjk, Ayij))

        connect_i_yij(s, Ai, zJ, Ayij, C)
        println("z1 = ",z1,", calcZ1 = ",calcZ1(s.x,s.y,s.zJ,s.zK, AzK, AzJ, Axjk, Ayij))
        # print_solution(s)



        #         indexes = t_connected_to_cl1(Ayij[:,j])
        #         #A_cl[i] = sum()
        #     end
        # println("zJ = ",zJ)
        # println("yij = ",yij)
        # println("cost_j = ",cost_j)
        #println("\n", xjk)
        #println("\nCj = ",Cj)
        

        cost_r = 0
    end
        
    sum = 0

    println("")
    return s
end

function grasp_z2(Ad :: Matrix{Int64}, K :: Int64, p :: Int64, M :: Int64 ,alpha :: Float64)
    zK = zeros(Int64, 1,K)
    ZKt = zeros(Int64, 1,K)
    memory = Vector{Int64}()
    if(p >= K)
        #println("p (",p,") >= K (",K,"), z2 complétement nullifié, interruption)")
        zK = 0
    else
        while(sum(zK) < p)
            maxK = 0
            minK = typemax(Int64)
            for i in 1:K
                if !(i in memory) 
                    ZKt[i] = min(M, (sum(Ad[i,:])))
                    if ZKt[i] > maxK
                        maxK = ZKt[i]
                    end
                    if ZKt[i] < minK
                        minK = ZKt[i]
                    end
                end
            end
            threshold = minK + alpha * (maxK - minK)
            #println("max = ",maxK,", min = ",minK,", threshold = ",threshold,"\n ZKt = ",ZKt)
            indexes = Vector{Int64}()
            for i in 1:K
                if !(i in memory)
                    if(threshold <= ZKt[i])
                        append!(indexes,i)
                    end
                end
            end
            #println("indexes = ", indexes,", memory = ",memory)
            i = rand_in_list(indexes)
            append!(memory,indexes[i])
            zK[1,indexes[i]] = 1
            #println("zK = ",zK)
        end
    end
    return zK
end