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

    if p == 0 
        model = build_z1_model(I,J,K,C,Ac[2:5])
        optimize!(model)
        print_z1_model(model)
        zk = value.(model[:zk])
        for i in zk
            if i > 0.9
                p += 1
            end
        end
        if p == 1
            p = 2
        end
        #println("p = ", p)
    end

    solution = init_solution(I,J,K)
    
    #z2
    solution.zK = vec(grasp_z2(Ad, K, p, M, alpha[1]))
    #println("zK = ",solution.zK)

    #z1
    solution = grasp_z1(solution, I,J,K,C, Axjk, Ayij, AzJ ,alpha[2:3])

    return solution
end

function grasp_z1(s :: solution, I :: Int64, J :: Int64, K :: Int64, C :: Int64 , Axjk :: Matrix{Int64}, Ayij :: Matrix{Int64}, AzJ :: Vector{Int64}, alpha :: Vector{Float64})
    # println("I = ",I," J = ",J," K = ",K)
    
    # println(m_cl2_cl1)
    # println(m_cl1_t)    

    #filling xjk for the best connexion possible, at least one connection to k
    s = fill_xjk(s, Axjk, AzJ,alpha[1])

    #Filling yij with the best choices, opening all zJ
    s = fill_yij(s, I ,Ayij, C)

    #Using DROP_heuristics for facility location and grasp
    s = grasp_drop_heuristic(s,I,J,K,C, Axjk, Ayij, AzJ,alpha[2])

    return s
end

function grasp_drop_heuristic(s :: solution, I :: Int64, J :: Int64, K :: Int64, C :: Int64, Axjk :: Matrix{Int64}, Ayij :: Matrix{Int64}, AzJ :: Vector{Int64}, alpha :: Float64)
    AzJ = Ac[3]

    cost_r = 1

    while cost_r > 0
        J_i = findall(x->x == 1, s.zJ)
        A_cl = zeros(Int64, 1,size(J_i)[1])
        i = 1
        for j in J_i
            indexes = t_connected_to_cl1(Ayij[:,j])
            #A_cl[i] = sum()
        end
        
        cost_r = 0
    end

    sum = 0
    return s
end

function grasp_z2(Ad :: Matrix{Int64}, K :: Int64, p :: Int64, M :: Int64 ,alpha :: Float64)
    zK = zeros(Int64, 1,K)
    ZKt = zeros(Int64, 1,K)
    memory = Vector{Int64}()
    if(p >= K)
        println("p (",p,") >= K (",K,"), z2 complétement nullifié, interruption)")
        zK = 0
    else
        while(sum(zK) < p)
            max = 0
            for i in 1:K
                if !(i in memory) 
                    ZKt[i] = min(M, (sum(Ad[i,:])))
                    if ZKt[i] > max
                        max = ZKt[i]
                    end
                end
            end
            minZ = max * alpha
            println("max = ",max,", min = ",minZ)
            indexes = Vector{Int64}()
            for i in 1:K
                if !(i in memory)
                    if(minZ <= ZKt[i])
                        append!(indexes,i)
                    end
                end
            end
            println("indexes = ", indexes,", memory = ",memory)
            i = rand_in_list(indexes)
            append!(memory,indexes[i])
            zK[1,indexes[i]] = 1
            println("zK = ",zK)
        end
    end
    return zK
end