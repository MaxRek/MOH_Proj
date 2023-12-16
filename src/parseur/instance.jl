include("parseur.jl")
using Distances

function indexList(max :: Int64, s :: Int64)
    index = Vector{Int64}()
    #println("max = ",max,", s = ",s)
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
    dfS, dfInfoS = parseData(path)
    dfSc = deepcopy(dfS)
    dfInfoSc = deepcopy(dfInfoS)
    indexesA = Vector{Vector{Tuple{Int64,Int64}}}()
    push!(indexesA,Vector{Tuple{Int64,Int64}}())
    push!(indexesA,Vector{Tuple{Int64,Int64}}())
    push!(indexesA,Vector{Tuple{Int64,Int64}}())

    for i in 1:3
        if(ratio[i] < 1.0)
            indexes = indexList(round(Int64,size(dfS[i])[1]*ratio[i]),size(dfS[i])[1])
            k = 1
            for j in indexes
                push!(indexesA[i],(k,j))
                k += 1
            end
            dfSc[i] = dfS[i][indexes,:]
            dfInfoSc[i] = dfInfoS[i][indexes,:]
        else
            for j in 1:size(dfS)[1]
                push!(indexesA[i],(j,j))
            end
        end
    end
    return dfSc, dfInfoSc, indexesA
end

function build_Costs(dfS :: Vector{DataFrame})
    A = Dict()
    cumul = 0
    for j in 1:size(dfS[1])[1]

        if(typeof(dfS[1][j,:].geometry) == GeoJSON.Point{2,Float32})
            for k in 1:size(dfS[2])[1]
                if(typeof(dfS[2][k,:].geometry) == GeoJSON.Point{2,Float32})
                    d = haversine(dfS[1][j,:].geometry.coordinates,dfS[2][k,:].geometry.coordinates)
                    A["x",j,k] = round(Int64,0.75*d+rand()*d*0.5)
                    cumul += A["x",j,k]
                end
            end
        end
    end
    #println("cumul = ",cumul," Moyenne = ", cumul/((size(dfS[1])[1]-1)*size(dfS[2])[1]-1))
    cumul = 0
    for j in 1:size(dfS[2])[1]
        if(typeof(dfS[2][j,:].geometry) == GeoJSON.Point{2,Float32})
            for k in 1:size(dfS[3])[1]
                d = haversine(dfS[2][j,:].geometry.coordinates,(dfS[3][k,:].X,dfS[3][k,:].Y))
                A["y",j,k] = round(Int64,0.75*d+rand()*d*0.5)
                cumul += A["y",j,k]

            end
        end
    end
    #println("cumul = ",cumul," Moyenne = ", cumul/((size(dfS[2])[1]-1)*size(dfS[3])[1]))

    return A
end