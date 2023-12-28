include("src/scater_search/grasp.jl")
include("src/parseur/instance.jl")
include("src/scater_search/scater_search.jl")
include("src/model/benchmark.jl")


#parameter
ratios = [1.0,0.2,0.007]
alphas = [0.5,0.5]
C = 3
rM = 2.0
p = 5


if(!isdir("in/instance/"))
    makedir("in/instance/")
end

if(length(readdir("in/instance")) == 0)
    write_Instance("in/data/", [1.0,0.2,0.007], 1.5)
end

names = getfname("in/instance/")
#print(names)

dfS, dfInfos, models, Atime = benchmark_model(names[1], C, p)

#Parsing
# K = size(Ac[5])[1]
# J = size(Ac[4])[1]
# I = Int(size(Ac[3])[1]/J)
# Ad = reshape(Ac[1],K,K)
# Axjk = reshape(Ac[2],J,K)
# Ayij = reshape(Ac[3],I,J)
# Ad = reshape(Ac[1],K,K)
# AzJ = Ac[4]
# AzK = Ac[5]
# s1 = grasp(Ac,M,5,[0.0,0.0],3)
# s2 = grasp(Ac,M,5,[0.0,0.0],3)


# subSet = Vector{Tuple{solution,solution}}()
# push!(subSet, (s2,s1))

# solution_combination(subSet)
# print_solution(s2)
# print_solution(s1)
# println("bababoui")

# scater_search(20, Ac, M, C , 100, ratios, 3)

# z1, z2 = calcZ_solution(s , M ,Ad ,AzK , AzJ, Axjk, Ayij)

# Modeles
# z1_model = build_z1_model(I,J,K,C, Ac[2:5], p)
# z2_model = build_z2_model(Ac[1], M, p, K)
# MO_model = build_MO_model(Ac[1], Ac[2:5],I,J,K,M,C,p)
