include("parseur.jl")

using Distances, DataFrames, CSV

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

function write_Instance(path_data :: String, ratio :: Vector{Float64}, rM :: Float64)
    dfS, dfInfoS = build_Instance(path_data, ratio)
    Ac, M = build_Costs(dfS, rM)
    name = string(size(Ac[5])[1],"_",size(Ac[4])[1],"_",Int(size(Ac[3])[1]/size(Ac[4])[1]))

    path = String("in/instance/"*name)
    if(!isdir(path))
        mkdir(path)
    end
    for i in 1:3
        CSV.write(string(path*"/dfS_",i,".csv"), dfS[1])
        CSV.write(string(path,"/dfInfoS_",i,".csv"), dfInfoS[1])
    end

    io = open(string(path,"/Ac.txt"),"w")
    println(io, Ac)
    println(io, M)
    close(io)
end

function write_Instance(name :: String, dfS :: Vector{DataFrame}, dfInfoS :: Vector{DataFrame}, Ac :: Vector{Vector{Int64}}, M :: Int64)
    path = String("in/instance/"*name)
    if(!isdir(path))
        mkdir(path)
    end
    for i in 1:3
        CSV.write(string(path*"/dfS_",i,".csv"), dfS[1])
        CSV.write(string(path,"/dfInfoS_",i,".csv"), dfInfoS[1])
    end
    io = open(string(path,"/Ac.txt"),"w")
    println(io, Ac)
    println(io, M)
    close(io)
end

function load_Instance(name :: String)
    dfS = Vector{DataFrame}()
    dfInfoS = Vector{DataFrame}()
    Ac = Vector{Vector{Int64}}()
    path = String("in/instance/"*name)

    for i in 1:3
        push!(dfS, CSV.read(string(path,"/dfS_",i,".csv"), DataFrame))
        push!(dfInfoS, CSV.read(string(path,"/dfInfoS_",i,".csv"), DataFrame))
    end

    str = open(string(path,"/Ac.txt")) do file
        read(file, String)
    end

    line = findfirst("\n", str)
    str = [str[1:line[1]],str[line[1]:length(str)-1]]
    
    i = findall("], [", str[1])
    push!(i,findfirst("[[", str[1]))
    push!(i,findfirst("]]", str[1]))
    i = sort(i)

    #println(i)

    for j in 1:5
        #println(i[j][2]+1, " " , i[j+1][1]-1," str = ",str[i[j][2]+1:i[j+1][1]-1],"\n___________________________")
        if(j == 1)
            push!(Ac, parse.(Int64,split(str[1][i[j][2]+1:i[j+1][1]-1],", ")))
        else
            push!(Ac, parse.(Int64,split(str[1][i[j][2]+3:i[j+1][1]-1],", ")))
        end
    end

    return dfS, dfInfoS, Ac, parse(Int64,str[2])
end

function build_Instance(path :: String, ratio :: Vector{Float64})
    dfS, dfInfoS = parseData(path)
    dfSc = deepcopy(dfS)
    dfInfoSc = deepcopy(dfInfoS)

    for i in 1:3
        if(ratio[i] < 1.0)
            indexes = indexList(round(Int64,size(dfS[i])[1]*ratio[i]),size(dfS[i])[1])
            k = 1
            dfSc[i] = dfS[i][indexes,:]
            dfInfoSc[i] = dfInfoS[i][indexes,:]
        end
    end
    return dfSc, dfInfoSc
end

#Renvoie 
#   - M plus grande distance * rM (Int64)
#   - Ac, tableaux de coûts où i :
#       - 1 : Distance entre les concentrateurs lvl 2, pour z2
#       - 2 : Connection d'un connecteur lvl 2 à lvl 1
#       - 3 : Connection d'un connecteur lvl 1 à un terminal
#       - 4 : coût ouverture concentrateur lvl 1
#       - 5 : coût ouverture concentrateur lvl 2

function build_Costs(dfS :: Vector{DataFrame}, rM :: Float64)
    #A = Dict()
    Ac = Vector{Vector{Int64}}()
    cumul1 = 0
    M = 0
    cumul2 = 0

    i = 1
    push!(Ac, Vector{Int64}())

    #z2 : Distance entres les concentrateurs lvl 2, M définit
    for j in 1:size(dfS[1])[1]
        for k in 1:size(dfS[1])[1]
            if(j != k)
                d = haversine(dfS[1][j,:].geometry.coordinates,dfS[1][k,:].geometry.coordinates)
                if M < d
                    M = d
                end
                append!(Ac[i], round(Int64,d))
                #A["xz2",j,k] = d
            else
                append!(Ac[i], 0)
            end
        end
    end

    push!(Ac, Vector{Int64}())
    i += 1  

    #println("cumul = ",cumul," Moyenne = ", cumul/((size(dfS[1])[1]-1)*size(dfS[2])[1]-1))
    #z1 : Connection d'un connecteur lvl 2 à lvl 1
    for j in 1:size(dfS[1])[1]
        for k in 1:size(dfS[2])[1]
            d = haversine(dfS[1][j,:].geometry.coordinates,dfS[2][k,:].geometry.coordinates)
            #A["x",j,k] = round(Int64,0.75*d+rand()*d*0.5)
            append!(Ac[i], round(Int64,0.75*d+rand()*d*0.5))
            #cumul += A["x",j,k]
            cumul2 += Ac[i][size(Ac[i])[1]]
        end
    end
        
    push!(Ac, Vector{Int64}())
    i += 1

    #z1 : Connection d'un connecteur lvl 1 à un terminal
    for j in 1:size(dfS[2])[1]
        for k in 1:size(dfS[3])[1]
            d = haversine(dfS[2][j,:].geometry.coordinates,(dfS[3][k,:].X,dfS[3][k,:].Y))  
            append!(Ac[i], round(Int64,0.75*d+rand()*d*0.5))
            #A["y",j,k] = round(Int64,0.75*d+rand()*d*0.5)
            #cumul += A["y",j,k]
            cumul1 += Ac[i][size(Ac[i])[1]]
        end
    end

    push!(Ac, Vector{Int64}())
    i += 1

    #z1 = coût ouverture concentrateur lvl 1
    moyenne1 = cumul1/((size(dfS[2])[1]-1)*size(dfS[3])[1]-1)
    #println("cumul = ",cumul," Moyenne = ", cumul/((size(dfS[2])[1]-1)*size(dfS[3])[1]))
    for j in 1:size(dfS[2])[1]
        append!(Ac[i], round(Int64,0.75*moyenne1+rand()*moyenne1*0.5)*2) 
        #A["zj",j] = round(Int64,0.75*moyenne+rand()*moyenne*0.5)*4
    end

    push!(Ac, Vector{Int64}())
    i += 1

    #z1 = coût ouverture concentrateur lvl 2
    moyenne2 = cumul2/((size(dfS[1])[1]-1)*size(dfS[2])[1]-1)
    for j in 1:size(dfS[1])[1]
        append!(Ac[i],round(Int64,0.75*moyenne2+rand()*moyenne2*0.5)*5)
        #A["zk",j] = round(Int64,0.75*moyenne2+rand()*moyenne2*0.5)*10
    end

    return Ac, round(Int64,M*rM)
end