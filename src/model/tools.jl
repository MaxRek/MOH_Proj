
include("../tools/gen.jl")

function print_z2_model(model :: Model,K :: Vector{Int64}, Ad :: Vector{Int64}, io = "")
    n = size(K)[1]
    zk = value.(model[:zk])
    Zk = value.(model[:Zk])

    index = []
    for i in 1:size(zk)[1]
        if zk[i]>0
            append!(index,i)
        end
    end
    # println(Ad)

    #Récupère les coûts
    matrix = zeros(Int64, n,n )
    for i in 0:n-1
        matrix[i+1,:] = Ad[((i*n)+1):(i+1)*n] 
    end

    if(io == "")
        println("Distance entre les points")
        printMatrix(matrix)

        print("\nzk choisi : ")
        for i in index
            print(i," ")
        end
        print("\nValeur des Zk  : ")
        for i in index
            print(Zk[i]," ")
        end
        
        println("\nValeur objective : ", objective_value(model))

    else
        println(io,"Distance entre les points")
        printMatrix(matrix,io)

        print(io,"\nzk choisi : ")
        for i in index
            print(io, i," ")
        end
        print(io,"\nValeur des Zk  : ")
        for i in index
            print(io, Zk[i]," ")
        end
        println(io,"\nValeur objective : ", objective_value(model))

    end

end

function print_z1_model(model :: Model, io = "")
    y = value.(model[:y])
    x = value.(model[:x])
    zk = value.(model[:zk])
    zj = value.(model[:zj])


    if(io == "")
        println("_____________________________\n C_l1 to Terminal")
        for j in 1:size(y)[2]
            bool = false
            for i in 1:size(y)[1]
                if(y[i,j] >= 0.9)
                    if(!bool)
                        print("\nC_l1 : ",j,", zj_j = ",zj[j]," connecté à  : ")
                        bool = true
                    end
                    print(i," ")
                end
            end
        end

        println("\n_____________________________\n zj : ")
        for i in 1:size(zj)[1]
            if(zj[i] >= 0.9)
                print(i," ")
            end
        end

        println("\n_____________________________\n C_l2 to C_l1")

        for k in 1:size(x)[2]
            bool = false
            for j in 1:size(x)[1]
                if(x[j,k] >= 0.9)
                    if(!bool)
                        println("\nC_l2 : ",k,", zk_k = ",zk[k]," connecté à : ")
                        bool = true
                    end
                    print(j," ")
                end
            end
        end

        println("\n_____________________________\n zk : ")
        for i in 1:size(zk)[1]
            if(zk[i] >= 0.9)
                print(i," ")
            end
        end

        println("\n")

    else
        for j in :1size(y)[2]
            bool = false
            for i in 1:size(y)[1]
                if(y[i,j] > 0.9)
                    if(!bool)
                        println(io,"\nC_l1 : ",j,", zj_j = ",zj[j]," connecté à  : ")
                        bool = true
                    end
                    print(io,i," ")
                end
            end
        end

        println(io,"\n_____________________________\n zj : ")
        for i in 1:size(zj)[1]
            if(zj[i] >= 0.9)
                print(io,i," ")
            end
        end


        for k in 1:size(x)[2]
            bool = false
            for j in 1:size(x)[1]
                if(x[j,k] >= 0.9)
                    if(!bool)
                        println(io,"C_l2 : ",k,", zk_k = ",zk[k]," connecté à : ")
                        bool = true
                    end
                    print(io,j," ")
                end
            end
        end

        println(io,"\n_____________________________\n zk : ")
        for i in 1:size(zk)[1]
            if(zk[i] >= 0.9)
                print(io,i," ")
            end
        end

        println(io,"\n")

    end

        
end