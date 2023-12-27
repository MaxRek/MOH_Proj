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

function calcZ1(x :: Matrix{Int64}, y :: Matrix{Int64}, zj :: Vector{Int64}, zk :: Vector{Int64}, AzK :: Vector{Int64}, AzJ :: Vector{Int64}, Axjk :: Matrix{Int64}, Ayij :: Matrix{Int64})
    z1 = 0
    K = size(AzK)[1]
    J = size(AzJ)[1]
    I = size(Ayij)[1]/J
    Kp = findall(x->x==1,zk)
    Jp = findall(x->x==1,zj)
    xp = findall(x->x==1,x)
    yp = findall(x->x==1,y)

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

    return z1
end

function calcZ2(zk :: Vector{Int64}, M :: Int64 ,Ad :: Matrix{Int64})
    #Compute z2
    Kp = findall(x->x==1,zk)

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

    return -(sum(ZK))
end

function calcZ_solution(s :: solution, M :: Int64 ,Ad :: Matrix{Int64}  ,AzK :: Vector{Int64}, AzJ :: Vector{Int64}, Axjk :: Matrix{Int64}, Ayij :: Matrix{Int64})
    return calcZ1(s.x,s.y,s.zJ,s.zK , AzK , AzJ, Axjk, Ayij),calcZ2(s.zK, M,Ad)
end

function compare_solution(s1 :: solution, s2 :: solution)
    bool = true
    if s1.zJ != s2.zJ
        bool = false
    else
        if s1.zK != s2.zK
            bool = false
        else
            if s1.x != s2.x
                bool = false
            else
                if s1.y != s2.y
                    bool = false
                end
            end
        end 
    end
    return bool
end

function calc_distance(s1 :: solution, s2 :: solution)
    sumD = 0 
    for i in 1:size(s1.x)[1]
        for j in 1:size(s1.x)[2]
            if s1.x[i,j] != s2.x[i,j]
                sumD += 1
            end
        end
    end
    for i in 1:size(s1.y)[1]
        for j in 1:size(s1.y)[2]
            if s1.y[i,j] != s2.y[i,j]
                sumD += 1
            end
        end
    end
    for i in 1:size(s1.zJ)[1]
        if s1.zJ[i] != s2.zJ[i]
            sumD += 1
        end
    end
    for i in 1:size(s1.zK)[1]
        if s1.zK[i] != s2.zK[i]
            sumD += 1
        end
    end
    return sumD
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