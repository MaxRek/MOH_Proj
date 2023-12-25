include("grasp.jl")

function scater_search(P :: Int64, Ac :: Vector{Vector{Int64}}, M :: Int64, C :: Int64, it :: Int64 ,alpha :: Vector{Float64}, p = 0,io = "")
    println("Début scater_search")
    println("Paramètres : P = ",P,"; M = ",M,", C = ",C,", alpha = ",alpha,", p = ",p)
    #Gen P
        # Diversification Generation Method
        # Improvement Method
    pop = Vector{solution}()
    A_s_improved = Vector{solution}()

    for i in 1:P
        s = grasp(Ac, M, C, alpha, p)
        push!(Pop,s)
    end

    if it < 1
        println("it = ",it,", doit être au moins égal à 1")
        it = 1
    end

    println("Fin de génération de population par GRASP, début boucle")
    #while !stop
        #Reference Set, Update Method
    while it > 0
        it -= 1
        
        #building refSets
        refsSets = build_refSets(pop, A_s_improved)
        
        subSets = build_subSets(refsSets)

        s1, s2 = solution_combination(subSets)

        s1 = tabu_search(s1)
        s2 = tabu_search(s2)
        push!(A_s_improved)
    
    end
        #Reference Set, Update Method

        #building refSets

        #Stop 

        #subset generation Method

        #Solution Combination Method

        #Improvement method
    #end
    
    

end