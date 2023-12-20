include("../scater_search/sets.jl")

e1 = solution(5, 6, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e2 = solution(7, 7, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e3 = solution(2, 4, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e4 = solution(7, 1, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e5 = solution(6, 3, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e6 = solution(8, 4, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e7 = solution(3, 7, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e8 = solution(1, 9, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e9 = solution(4, 9, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e10 = solution(8, 9, zeros(Int64,2,2),zeros(Int64,2,2),[],[])

println("Si tests sur orderedVector faux, ne pas prendre en compte ce test")

println("Tests function building_sets() : ")
sets = building_sets([e1,e2,e3,e4,e5,e6,e7,e8,e9,e10])

if(toArray(sets) == [[(1,9),(2,4),(6,3),(7,1)],[(3,7),(5,6),(8,4)],[(4,9),(7,7)],[(8,9)]])
    print("OK")
else
    println("ERREUR : sets ne correspond au résultat attendu, print sets reçu")
    print(sets)
end