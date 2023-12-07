# Require: P, un ensemble de n points du plan (pi )1≤i≤n
# Ensure: L, la pile des sommets de conv (P) donnée dans le sens horaire
# 1: ppivot ← le point d’ordonnée minimale
# 2: On note p2, . . . , pn les points restants triés par angle polaire croissant autour de ppivot
# 3: Empiler(ppivot , L) ; Empiler(p2, L) // le début de conv(S)
# 4: for i = 3 to n do
# 5: while pi est à droite de [AvantDernier(L), Dernier(L)) do
# 6: Dépiler(L)
# 7: end while
# 8: Empiler(pi , L)
# 9: end for
# 10: return L

#  sens = (x2–x1)(y3–y1)–(y2–y1)(x3–x1)

using DataStructures

struct Point2D
    x :: Float64
    y :: Float64 
end

function sens(p1 :: Point2D, p2 :: Point2D, p3 :: Point2D)
    return( (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x) )
end

function Graham_alg_2D(P :: Vector{Point2D})
    r = Vector{(Point2D)}()
    Pp = deepcopy(P)
    
    pile = Stack{Point2D}()
    minz = typemax(Float64)
    n = size(P)[1]

    z = 1
    for i in 1:n
        if P[i].x < minz
            minz = P[i].x 
            z = i
        end
    end

    println(P[z])

    push!(pile, P[z])
    popat!(Pp,z)

    M = zeros(n-1,2)
    
    for i in 1:n-1
        M[i,1] = i
        M[i,2] = atan((Pp[i].y-P[z].y)/(Pp[i].x-P[z].x))
        println(Pp[i])
    end

    printMatrix(M)

    return r
end

function sort_by_z(P)
    r = Vector{Point2D}()
    if(typeof(P[1]) == Point2D)
        M = zeros(size(P)[1], 2)
    end

    for i in collect(1:size(P)[1])
        M[i,1] = P[i].x; M[i,2] = P[i].y
    end

    M = sortslices(M, dims = 1)

    for i in collect(1:size(M)[1])
        push!(r, Point2D(M[i,1],M[i,2]))
    end
    print(r)
    return r
end

function printMatrix(matrix)
    for i in 1:size(matrix)[1]
        println(matrix[Int64(i),:])
    end
end

P = [Point2D(5.0,6.0),Point2D(7.0,7.0),Point2D(2.0,4.0),Point2D(6.0,3.0),Point2D(8.0,4.0),Point2D(3.0,7.0),Point2D(7.0,1.0)]


Graham_alg_2D(P)