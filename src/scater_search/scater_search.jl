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
    memory = Vector{Tuple{solution,solution}}()
    
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

    if it < 1
        println("it = ",it,", doit être au moins égal à 1")
        it = 1
    end

    println("Fin de génération de population par GRASP, début boucle")

    while it > 0
        println("---------------\nit : ", it)

        #Reference Set, Update Method
        it -= 1
        A_s_improved = orderedVector(Vector{solution}())

        #build subSets
        A = build_subSets(refSets,memory,beta)

        #solution combination
        S = solution_combination(A)

        #improvement
        for i in 1:size(S)[1]
            s1,s2 = tabu_search(S[i])
            insert(A_s_improved, s1)
            insert(A_s_improved, s2)
            end
        #building refSets
        refsSets = actualize_refSets(refSets, A_s_improved, round(Int64, beta))
    end

end