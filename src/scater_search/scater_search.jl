include("grasp.jl")
include("refsSets.jl")
include("subsets.jl")
include("combination.jl")
include("improvement.jl")

function scater_search(P :: Int64, Ac :: Vector{Vector{Int64}}, M :: Int64, C :: Int64, it :: Int64 ,alpha :: Vector{Float64}, p = 0,io = "")
    
    K = size(Ac[5])[1]
    J = size(Ac[4])[1]
    I = Int(size(Ac[3])[1]/J)
    Ad = reshape(Ac[1],K,K)
    Axjk = reshape(Ac[2],J,K)
    Ayij = reshape(Ac[3],I,J)
    AzJ = Ac[4]
    beta = round(Int64, P/4)
    init = true
    
    println("Début scater_search")
    println("Paramètres : P = ",P,"; M = ",M,", C = ",C,", alpha = ",alpha,", p = ",p)
    #Gen P
        # Diversification Generation Method
        # Improvement Method
    pop = Vector{solution}()

    for i in 1:P
        s = grasp(Ac, M, C, alpha, p) 
        push!(pop,s)
    end

    println("Constructing refSets")
    refSets = build_refSets(pop, beta)

    m_calc_distance(pop)

    if it < 1
        println("it = ",it,", doit être au moins égal à 1")
        it = 1
    end

    println("Fin de génération de population par GRASP, début boucle")
    #while !stop
        #Reference Set, Update Method
    while it > 0
        it -= 1
        A_s_improved = orderedVector(Vector{solution}())

        for i in 1:beta
            subSet = build_subSets(refSets)
            s1, s2 = solution_combination(subSet)
            s1_1, s1_2 = tabu_search(s1)
            s2_1, s2_2 = tabu_search(s2)
            insert(A_s_improved, s1_1)
            insert(A_s_improved, s1_2)
            insert(A_s_improved, s2_1)
            insert(A_s_improved, s2_2)

        end
        #building refSets
        refsSets = actualize_refSets(refSets, A_s_improved, round(Int64, beta))
    
    end

end