#z(x)1 dominates zx2 ?
#send 1 if yes, 2 if zx2 dominates zx1, 3 if incomparable
function dominates(zx1 :: Tuple{Int64,Int64}, zx2 :: Tuple{Int64,Int64})
    #z(x)1 dominates zx2 ?

    i = 1
    if(zx2[1] < zx1[1] && zx2[2] < zx1[2])
        i = 2
    else
        if(zx2[1] < zx1[1] && zx1[2] < zx2[2])
            i = 3
        else

        end
    end
    return i
end

