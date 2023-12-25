include("src/scater_search/grasp.jl")
include("src/parseur/instance.jl")

<<<<<<< HEAD
dfS, dfInfoS = build_Instance("in/data/", [1.0,0.2,0.007])
Ac, M = build_Costs(dfS)
=======
#parameter
ratios = [1.0,0.2,0.007]
alphas = [0.5,0.5,0.25]
C = 10
rM = 2.0
p = 5

#Parsing
dfS, dfInfoS = build_Instance("in/data/", ratios)
Ac, M = build_Costs(dfS, rM)
>>>>>>> 077caeb31ea6a5877a7cea14c8f2484022d76c97
K = size(Ac[5])[1]
J = size(Ac[4])[1]
I = Int(size(Ac[3])[1]/J)
Ad = reshape(Ac[1],K,K)
Axjk = reshape(Ac[2],J,K)
Ayij = reshape(Ac[3],I,J)
Ad = reshape(Ac[1],K,K)
AzJ = Ac[4]
AzK = Ac[5]
<<<<<<< HEAD
s = grasp(Ac,M,5,[0.2,0.5,0.25],5)
z1, z2 = calcZ_solution(s , M ,Ad ,AzK , AzJ, Axjk, Ayij)
=======

# s = grasp(Ac,M,5,alphas,3)
# z1, z2 = calcZ_solution(s , M ,Ad ,AzK , AzJ, Axjk, Ayij)

# Modeles
z1_model = build_z1_model(I,J,K,C, Ac[2:5])
z2_model = build_z2_model(Ac[1], M, p, K)
#MO_model = build_MO_model(Ac[1], Ac[2:5],I,J,K,M,C,p)
>>>>>>> 077caeb31ea6a5877a7cea14c8f2484022d76c97
