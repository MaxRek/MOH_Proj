using JuMP
using MultiObjectiveAlgorithms
using HiGHS
using Gurobi
include("tools.jl")

function build_MO_model(Ad :: Vector{Int64}, Ac :: Vector{Vector{Int64}},I :: Int64, J :: Int64 ,K :: Int64, M :: Int64, C :: Int64, p :: Int64, timelimit :: Int64 = 0)
    
    # Model configuration
    model = Model()
    set_optimizer(model, () -> MultiObjectiveAlgorithms.Optimizer(Gurobi.Optimizer))
    set_attribute(model, MultiObjectiveAlgorithms.Algorithm(), MultiObjectiveAlgorithms.EpsilonConstraint())
    set_attribute(model, MultiObjectiveAlgorithms.SolutionLimit(), 20)
    if timelimit > 0.0
        set_time_limit_sec(model, timelimit)
    end

    #Variables
        @variable(model, x[j in 1:J,k in 1:K], Bin)
        @variable(model, y[i in 1:I,j in 1:J], Bin)
        @variable(model, zj[1:J], Bin)
        @variable(model, zk[1:K], Bin)
        @variable(model, Zk[1:K], Int)


    #Objectives
    @objective(model, Min, 
    [
        sum(x[j,k]*Ac[1][((k-1)*K)+j] for j in 1:J for k in 1:K)+ sum(y[i,j]*Ac[2][((j-1)*J)+i] for i in 1:I for j in 1:J)+ sum(zj[j]*Ac[3][j] for j in 1:J)+ sum(zk[k]*Ac[4][k] for k in 1:K)
        ,-(sum(Zk[k] for k in 1:K))
])
 
    #   Contraintes :
        # Tous terminaux sont reliés
        @constraint(model, terminal_i_[i = 1:I], sum(y[i,j] for j in 1:J) == 1)

        # Une connection de t_cl1_ implique une connexion entre cl1 et un cl2
        @constraint(model, ti_cl1_to_cl1_cl2[i = 1:I, j = 1:J], y[i,j] <= sum(x[j,k] for k in 1:K))

        # Connexion du terminal au c_l1 possible si c_l1 ouvert
        @constraint(model, connect_ti_cl1_[i = 1:I,j = 1:J], y[i,j]<=zj[j])

        # Connexion du c_l2 au c_l1 si c_l1 ouvert
        @constraint(model, connect_cl1_cl2_[j = 1:J,k = 1:K], x[j,k]<=zj[j])

        # Connexion du c_l2 au c_l1 si c_l2 ouvert
        @constraint(model, connect_cl2_cl1_[k = 1:K,j = 1:J], x[j,k]<=zk[k])

        # Il y a au plus une seule connexion de c_l1 à un c_l2
        @constraint(model, lim_connect_cl1_cl2_[j = 1:J], sum(x[j,k] for k in 1:K) <= 1)

        # Un cl1 peut avoir au plus C Connexion
        @constraint(model, capacite_cl1_[j in 1:J], sum(y[i,j] for i in 1:I) <= C )

        #On ouvre p postes
        @constraint(model, lim_zk, sum(zk[k] for k in 1:K) == p)

        #zK est limité par M
        @constraint(model, lim_M_Z[k = 1:K], Zk[k] <= M*zk[k])

        #zK est limité par la somme de ses distances avec les autres locations
        @constraint(model, lim_kp_Z[k in 1:K], Zk[k] <= sum(Ad[((k-1)*K)+kp]*zk[kp] for kp in 1:K if kp != k) )

    return model
end

function build_z1_model(I :: Int64, J :: Int64, K :: Int64, C :: Int64, Ac :: Vector{Vector{Int64}}, p :: Int64, timelimit :: Int64 = 0)
    model = Model(Gurobi.Optimizer)
    if timelimit > 0.0
        set_time_limit_sec(model, timelimit)
    end

    #Variables
    @variable(model, x[j in 1:J,k in 1:K], Bin)
    @variable(model, y[i in 1:I,j in 1:J], Bin)
    @variable(model, zk[1:K], Bin)
    @variable(model, zj[1:J], Bin)

    #   Contraintes :
        # Tous terminaux sont reliés
        @constraint(model, terminal_i_[i = 1:I], sum(y[i,j] for j in 1:J) == 1)

        #On ouvre p postes
        @constraint(model, lim_zk, sum(zk[k] for k in 1:K) == p)

        # Une connection de t_cl1_ implique une connexion entre cl1 et un cl2
        @constraint(model, ti_cl1_to_cl1_cl2[i = 1:I, j = 1:J], y[i,j] <= sum(x[j,k] for k in 1:K))

        # Connexion du terminal au c_l1 possible si c_l1 ouvert
        @constraint(model, connect_ti_cl1_[i = 1:I,j = 1:J], y[i,j]<=zj[j])

        # Connexion du c_l2 au c_l1 si c_l1 ouvert
        @constraint(model, connect_cl1_cl2_[j = 1:J,k = 1:K], x[j,k]<=zj[j])

        # Connexion du c_l2 au c_l1 si c_l2 ouvert
        @constraint(model, connect_cl2_cl1_[k = 1:K,j = 1:J], x[j,k]<=zk[k])

        # Il y a au plus une seule connexion de c_l1 à un c_l2
        @constraint(model, lim_connect_cl1_cl2_[j = 1:J], sum(x[j,k] for k in 1:K) <= 1)

        # Un cl1 peut avoir au plus C Connexion
        @constraint(model, capacite_cl1_[j in 1:J], sum(y[i,j] for i in 1:I) <= C )

    #Fonction Objective
    @objective(model, Min, sum(x[j,k]*Ac[1][((k-1)*K)+j] for j in 1:J for k in 1:K)+ sum(y[i,j]*Ac[2][((j-1)*J)+i] for i in 1:I for j in 1:J)+ sum(zj[j]*Ac[3][j] for j in 1:J)+ sum(zk[k]*Ac[4][k] for k in 1:K))

    return model
end
   
function build_z2_model(Ad :: Vector{Int64}, M :: Int64, p :: Int64 ,K :: Int64, timelimit :: Int64 = 0)
    model = Model(Gurobi.Optimizer)
    if timelimit > 0.0
        set_time_limit_sec(model, timelimit)
    end

    @variable(model, zk[1:K], Bin)
    @variable(model, Zk[1:K], Int)

    #Contraintes : 
        #On ouvre p postes
        @constraint(model, lim_zk, sum(zk[k] for k in 1:K) == p)

        #zK est limité par M
        @constraint(model, lim_M_Z[k = 1:K], Zk[k] <= M*zk[k])

        #zK est limité par la somme de ses distances avec les autres locations
        @constraint(model, lim_kp_Z[k in 1:K], Zk[k] <= sum(Ad[((k-1)*K)+kp]*zk[kp] for kp in 1:K if kp != k) )
    
    #Fonction objective : Maximiser Zk
    @objective(model, Min, sum( -Zk[k] for k in 1:K))

    return model
end