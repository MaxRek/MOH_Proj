include("src/scater_search/grasp.jl")
include("src/parseur/instance.jl")

dfS, dfInfoS = build_Instance("in/data/", [0.4,0.2,0.007])
Ac, M = build_Costs(dfS)
K = size(Ac[5])[1]
J = size(Ac[4])[1]
I = Int(size(Ac[3])[1]/J)
Ad = reshape(Ac[1],K,K)
Axjk = reshape(Ac[2],J,K)
Ayij = reshape(Ac[3],I,J)
Ad = reshape(Ac[1],K,K)
AzJ = Ac[4]
AzK = Ac[5]
s = grasp(Ac,M,5,[0.5,0.5,0.25],3)
s.z1, s.z2 = calcZ_solution(s , M ,Ad ,AzK , AzJ, Axjk, Ayij)

pop1, pop2 = Vector{Vector{solution}}(),Vector{Vector{solution}}()
for i in 1:20
    push!(pop1, grasp(Ac,M,100,[0.5,0.5,0.25],3))
    pop1[i].z1,pop1[i].z2 = calcZ_solution(pop1[i],M,Ad,Azk,AzJ,Axjk,Ayij)
end
for i in 1:20
    push!(pop2, grasp(Ac,M,5,[0.5,0.5,0.25],3))
end