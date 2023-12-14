using JuMP
using MultiObjectiveAlgorithms
using HiGHS

function build_bio_model(A :: Dict, I :: Vector{Int}, J :: Vector{Int64} ,K :: Vector{Int64})
    
    #Variables
    model = Model(MultiObjectiveAlgorithms.Optimizer)
    for j in J
        for k in K
            @variable(model, x[j,k], valtype = BinaryRef)
        end
        for i in I
            @variable(model, y[i,j], valtype = BinaryRef)
        end
        @variable(model, zj[j], valtype = BinaryRef)
    end
    for i in I
        @variable(model, zi[i], valtype = BinaryRef)
    end

    #Objective
    @objective(model, min, sum(sum(A["x",j,k]*x[j,k] for k in K) for j in J))

    #Constraints
    for j in J
        # c_l1 doit être connecté à au plus un c_l2
        @constraint(model, affect_l2_l1[j,k], sum(x[j,k] for k in K) <= 1)
        
        # Chaque terminal doit être connecté à exactement un c_l1 
        @constraint(model, affect_l1_t[i,j], sum(y[i,j] for i in I) == 1)

        # Chaque connection au c_l1 est possible uniquement si le c_l1 est ouvert
        for i in I
            @constraint(model, open_zj[j], y[i,j] <= zj[j])
        end
    end

    for k in K
        #Chaque connection du c_l1 au c_l2 est possible si c_l2 est ouvert

    end 
end

function build_z1_model(I :: Vector{Int}, J :: Vector{Int64}, Aij :: Vector{Int64}, K :: Vector{Int64}, Ajk :: Vector{Int64})
    model = Model(HiGHS.Optimizer)

    #Variables
    for i in I
        for j in J
            @variable(model, y[i,j])
        end
    end

    return model
end
   
function build_z2_model(Ad :: Vector{Int64}, M :: Int64, p :: Int64 ,K :: Vector{Int64})
    model = Model(HiGHS.Optimizer)

    @variable(model, zk[1:length(K)], Bin)
    @variable(model, Zk[1:length(K)], Int)

    #Contrainte : On ouvre p postes
    @constraint(model, lim_zk, sum(zk[k] for k in K) == p)

    #zK est limité par M
    @constraint(model, lim_M_Z[k = 1:length(K)], Zk[k] <= M*zk[k])

    k = 1
    #zK est limité par la somme de ses distances avec les autres locations
    @constraint(model, lim_kp_Z[k in K], Zk[k] <= sum(Ad[((k-1)*length(K))+kp]*zk[kp] for kp in 1:length(K) if kp != k) )
    
    #Fonction objective : Maximiser Zk

    @objective(model, Max, sum(Zk[k] for k in K))

    return model
end