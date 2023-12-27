include("../dominance.jl")

zx1 = (5,6); zx2 = (7,7)
println("Cas 1 ")
if(dominates(zx1,zx2) == 1)
    print(": OK\n")
else
    if(dominates(zx1,zx2) == 2)
        println("ERREUR : Dominance() == 2 : Cas où zx1 ",zx1," domine strictement zx2 ",zx2)
    else
        println("ERREUR : Dominance() == 3 : Cas où zx1 ",zx1," domine strictement zx2 ",zx2)
    end
end

zx1 = (7,7); zx2 = (5,6)
println("Cas 2 ")
if(dominates(zx1,zx2) ==2)
    print(": OK\n")
else
    if(dominates(zx1,zx2) == 1)
        println("ERREUR : Dominance() == 1 : Cas où zx2 ",zx2," domine strictement zx1 ",zx1)
    else
        println("ERREUR : Dominance() == 3 : Cas où zx2 ",zx2," domine strictement zx1 ",zx1)
    end
end

zx1 = (7,5); zx2 = (5,7)
println("Cas 3 ")
if(dominates(zx1,zx2) == 3)
    print(": OK\n")
else
    if(dominates(zx1,zx2) == 1)
        println("ERREUR : Dominance() == 1 : Cas où zx1 ",zx1," incomparable à zx2 ",zx2)
    else
        println("ERREUR : Dominance() == 2 : Cas où zx1 ",zx1," incomparable à zx2 ",zx2)
    end
end