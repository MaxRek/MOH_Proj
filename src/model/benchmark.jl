include("../parseur/instance.jl")
include("model.jl")
include("../struct/orderedVector.jl")
include("../model/tools_plot.jl")

function benchmark_model(name :: String, timeLimit :: Int64 = 0)
    # Initialisation
    dfS, dfInfos, Ac, M = load_Instance(name)

    K = size(Ac[5])[1]
    J = size(Ac[4])[1]
    I = round(Int64,size(Ac[3])[1]/J)
    AC = [round(Int64, I/J, RoundUp)+1, round(Int64, I/J, RoundUp)*2, round(Int64, I/J, RoundUp)*3, round(Int64, I/J, RoundUp)*5,I]
    AP = [3,5]
    println("name = ",name, ",I = ",I, ", J = ",J, " K = ",K)
    println(size(Ac[2]))
    #Results

    println("AC = ",AC)

    
    for j in 1:size(AC)[1]
        for k in 1:size(AP)[1]
            AMOresults = Vector{Vector{Int64}}()
            Atime = Vector{Float64}()
            n = string(name,"_",AC[j],"_",AP[k])

            path = string("out/",n)
            if(!isdir(path))
                mkdir(path)
            end
            io = open(string(path,"/",n,".txt"),"w")

            models = [
                build_z1_model(I,J,K,AC[j], Ac[2:5],AP[k],timeLimit),
                build_z2_model(Ac[1], M, AP[k], K,timeLimit),
                build_MO_model(Ac[1], Ac[2:5],I,J,K,M,AC[j],AP[k],timeLimit)
                ]


            for i in 1:3
                push!(Atime,@elapsed optimize!(models[i]))
            end

            for i in 1:result_count(models[3])
                push!(AMOresults, round.(Int, objective_value(models[3]; result = i)))
            end

            println(io, Atime)
            println(io,[objective_value(models[1]),objective_value(models[2]),AMOresults])
            plotSolutions(path, n,[objective_value(models[1]),objective_value(models[2]),AMOresults], AC[j], AP[k])
            close(io)
        end
    end
end

