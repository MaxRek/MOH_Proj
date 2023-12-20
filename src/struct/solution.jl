mutable struct solution
    z1 :: Int64
    z2 :: Int64
    x :: Matrix{Int64}
    y :: Matrix{Int64}
    zK :: Vector{Int64}
    zJ :: Vector{Int64}
end

function init_solution(I :: Int64, J :: Int64, K :: Int64)
    x = zeros(Int64, J,K)
    y = zeros(Int64, I,J)
    zj = Vector{Int64}()
    for j in 1:J
        append!(zj,1)
    end
    zk = Vector{Int64}()
    for k in 1:K
        append!(zk,1)
    end
    return solution(0,0,x,y,zk,zj)
end

function calcZ_solution(s :: solution, M :: Int64 ,Ad :: Matrix{Int64}  ,AzK :: Vector{Int64}, AzJ :: Vector{Int64}, Axjk :: Matrix{Int64}, Ayij :: Matrix{Int64})
    z1 = 0
    z2 = 0
    K = size(AzK)[1]
    J = size(AzJ)[1]
    I = size(Ayij)[1]/J
    Kp = findall(x->x==1,s.zK)
    Jp = findall(x->x==1,s.zJ)
    xp = findall(x->x==1,s.x)
    yp = findall(x->x==1,s.y)

    #Compute z1
    # zK 
    for k in Kp
        z1 += AzK[k]
        #println("z1 = ",z1,", AzK[k] = ",AzK[k])
    end

    # zJ
    for j in Jp
        #println("z1 = ",z1,", Azj[j] = ",AzJ[j])
        z1 += AzJ[j]
    end

    #xjk
    for x in xp
        z1 += Axjk[x]
        #println("z1 = ",z1,", AzK[k] = ",AzK[k])
    end

    #yij
    for y in yp
        z1 += Ayij[y]
        #println("z1 = ",z1,", AzK[k] = ",AzK[k])
    end

    #Compute z2
    ZK = Vector{Int64}()
    #println("Kp = ",Kp)
    for k in Kp
        Z = 0
        for kp in Kp
            Z = min(M,(Z + Ad[k,kp]))
        end
        append!(ZK, Z)
    end
    #println("ZK = ",ZK)

    z2 = sum(ZK)

    return z1,z2
end

function print_solution(s :: solution, io = "")
    # println(s.zJ)
    # println(s.zK)
    if(io == "")
        println("_________________________\n z1 = ", s.z1,", z2 = ",s.z2,"\n_____________________________\n C_l1 to Terminal")
        for j in 1:size(s.y)[2]
            bool = false
            for i in 1:size(s.y)[1]
                if(s.y[i,j] >= 0.9)
                    if(!bool)
                        print("\nC_l1 : ",j,", zj_j = ",s.zJ[j]," connecté à  : ")
                        bool = true
                    end
                    print(i," ")
                end
            end
        end

        println("\n_____________________________\n zj : ")
        for i in 1:size(s.zJ)[1]
            if(s.zJ[i] >= 0.9)
                print(i," ")
            end
        end

        println("\n_____________________________\n C_l2 to C_l1")

        for k in 1:size(s.x)[2]
            bool = false
            for j in 1:size(s.x)[1]
                if(s.x[j,k] >= 0.9)
                    if(!bool)
                        println("\nC_l2 : ",k,", zk_k = ",s.zK[k]," connecté à : ")
                        bool = true
                    end
                    print(j," ")
                end
            end
        end

        println("\n_____________________________\n zk : ")
        for i in 1:size(s.zK)[1]
            if(s.zK[i] >= 0.9)
                print(i," ")
            end
        end

        println("\n")

    else
        println("_________________________\n z1 = ", s.z1,", z2 = ",s.z2,"\n_____________________________\n C_l1 to Terminal")

        for j in :1size(s.y)[2]
            bool = false
            for i in 1:size(s.y)[1]
                if(s.y[i,j] > 0.9)
                    if(!bool)
                        println(io,"\nC_l1 : ",j,", zj_j = ",s.zJ[j]," connecté à  : ")
                        bool = true
                    end
                    print(io,i," ")
                end
            end
        end

        println(io,"\n_____________________________\n zj : ")
        for i in 1:size(s.zJ)[1]
            if(s.zJ[i] >= 0.9)
                print(io,i," ")
            end
        end


        for k in 1:size(s.x)[2]
            bool = false
            for j in 1:size(s.x)[1]
                if(s.x[j,k] >= 0.9)
                    if(!bool)
                        println(io,"C_l2 : ",k,", zk_k = ",zk[k]," connecté à : ")
                        bool = true
                    end
                    print(io,j," ")
                end
            end
        end

        println(io,"\n_____________________________\n zk : ")
        for i in 1:size(s.zK)[1]
            if(s.zK[i] >= 0.9)
                print(io,i," ")
            end
        end

        println(io,"\n")

    end
end