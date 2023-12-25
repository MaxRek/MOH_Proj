include("../parseur/instance.jl")
include("model.jl")
include("../struct/orderedVector.jl")

function benchmark_model(name :: String, C :: Int64, p :: Int64, timeLimit :: Int64 = 0)
    path = String("out/"*name)
    if(!isdir(path))
        mkdir(path)
    end

    # Initialisation
    dfS, dfInfos, Ac, M = load_Instance(name)
    K = size(Ac[5])[1]
    J = size(Ac[4])[1]
    I = Int(size(Ac[3])[1]/J)

    #Results
    Atime = Vector{Float64}()
    AMOresults = Vector{Vector{Int64}}()
    
    models = [
        build_z1_model(I,J,K,C, Ac[2:5]),
        build_z2_model(Ac[1], M, p, K),
        build_MO_model(Ac[1], Ac[2:5],I,J,K,M,C,p)
        ]

    for i in 1:3
        push!(Atime,@elapsed optimize!(models[i]))
    end

    for i in 1:result_count(models[3])
        push!(AMOresults, round.(Int, objective_value(MO_model; result = i)))
    end


    return dfS, dfInfos, models, Atime, [objective_value(models[1]),objective_value(models[2]),AMOresults]
end

