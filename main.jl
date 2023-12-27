include("src/scater_search/grasp.jl")
include("src/parseur/instance.jl")
include("src/scater_search/scater_search.jl")


#parameter
ratios = [1.0,0.2,0.007]
alphas = [0.5,0.5]
C = 3
rM = 2.0
p = 5

# If we need instance
#write_Instance("in/data", [1.0,0.2,0.007], 1.5)
# Ac, M = build_Costs(dfS, rM)

#else

dfS, dfInfos, Ac, M = load_Instance("10_42_21")

#Parsing
K = size(Ac[5])[1]
J = size(Ac[4])[1]
I = Int(size(Ac[3])[1]/J)
Ad = reshape(Ac[1],K,K)
Axjk = reshape(Ac[2],J,K)
Ayij = reshape(Ac[3],I,J)
Ad = reshape(Ac[1],K,K)
AzJ = Ac[4]
AzK = Ac[5]
s1 = grasp(Ac,M,5,[0.0,0.0],3)
s2 = grasp(Ac,M,5,[0.0,0.0],3)


subSet = Vector{Tuple{solution,solution}}()
push!(subSet, (s2,s1))

solution_combination(subSet)
print_solution(s2)
print_solution(s1)
println("bababoui")

#scater_search(20, Ac, M, C , 100, ratios, 3)

# z1, z2 = calcZ_solution(s , M ,Ad ,AzK , AzJ, Axjk, Ayij)

# Modeles
#z1_model = build_z1_model(I,J,K,C, Ac[2:5], p)
#z2_model = build_z2_model(Ac[1], M, p, K)
#MO_model = build_MO_model(Ac[1], Ac[2:5],I,J,K,M,C,p)
