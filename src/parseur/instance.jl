include("parseur.jl")
using Distances

function indexList(max :: Int64, s :: Int64)
    index = Vector{Int64}()
    println("max = ",max,", s = ",s)
    if(max > 0)
        if(max > s)
            max = s
            println("ERROR : max could only be as less of equal to size")
        end
        while size(index)[1]<= max-1
            i = round(Int64,(rand()*(s-1))+1)
            if !(i in index)
                append!(index,i)
            end 
        end
    else
        println("ERROR : max < 0 ")
    end
    return sort(index)
end

function build_Instance(path :: String, ratio :: Vector{Float64})
    dfSc = deepcopy(dfS)
    dfInfoSc = deepcopy(dfS)
    indexesA = Vector{Vector{Tuple{Int64,Int64}}}()
    for i in 1:3
        if(ratio[i] < 1.0)
            indexes = indexList(round(Int64,size(dfS[i])[1]*ratio[i]),size(dfS[i])[1])
            for j in indexes
                
            end
            println(indexes)
            dfSc[i] = dfS[i][indexes,:]
            dfInfoSc[i] = dfInfoS[i][indexes,:]
        end
    end
end

function build_Costs(dfS :: DataFrame, ratio :: Vector{Float64})
    
    

end