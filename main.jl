include("src/scater_search/grasp.jl")
include("src/parseur/instance.jl")
include("src/model/benchmark.jl")
using DataFrames
using JuMP

#parameter
ratios = [1.0,0.2,0.007]
alphas = [0.5,0.5,0.25]
C = 3
rM = 2.0
timelimit = 900


if(!isdir("in/instance/"))
    makedir("in/instance/")
end

if(length(readdir("in/instance")) == 0)
    write_Instance("in/data/", [1.0,0.1,0.002], rM)
end

names = getfname("in/instance/")

for i in 1:size(names)[1]
    benchmark_model(names[i], timelimit)
end    

# #Parsing
# dfS, dfInfoS = build_Instance("in/data/", ratios)
# Ac, M = build_Costs(dfS, rM)


# s = grasp(Ac,M,5,alphas,3)
# z1, z2 = calcZ_solution(s , M ,Ad ,AzK , AzJ, Axjk, Ayij)

# Modeles
# z1_model = build_z1_model(I,J,K,C, Ac[2:5])
# z2_model = build_z2_model(Ac[1], M, p, K)
#MO_model = build_MO_model(Ac[1], Ac[2:5],I,J,K,M,C,p)