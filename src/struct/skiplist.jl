mutable struct cell_skiplist
    z1   :: Int64
    z2   :: Int64
    next :: Vector{cell_skiplist}   
end

struct skiplist
    start :: cell_skiplist
end

function init_skiplist()
    l = skiplist(cell_skiplist(typemin(Int64),typemax(Int64),Vector{skiplist}()))
    push!(l.start.next, cell_skiplist(typemax(Int64),typemin(Int64),Vector{skiplist}()))

    return l
end

function print_skiplist(sl :: skiplist)
    println("---------------------------------------")
    ax = sl.start
    stop = false
    prof = 0
    while(!stop)
        print("Cell ",prof," = {", ax.z1,", ",ax.z2)
    
        # println("size(ax.next ",size(ax.next)[1],") ")
        s = size(ax.next)[1]
        if s > 0
            print(" poiting to")
            for i in ax.next
                print("\n    -Cell z1 = ",i.z1)
            end
            if s > 1
                next_ax = 1
                # println("size(ax.next",s," >= 1")
                # println("next_ax_val ",next_ax_val," >= 1")
                j = 1
                next_ax_val = ax.next[1].z1
                for i in ax.next
                    # println("next_ax_val ",next_ax_val," >= 1")
                    if i.z1 < next_ax_val
                        # println("i.z1 ",i.z1," < next_ax_val ",next_ax_val)
                        next_ax_val = i.z1
                        next_ax = j
                    end
                    j += 1
                end
                ax = ax.next[next_ax]
                prof += 1
            else
                ax = ax.next[1]
                prof += 1
            end
            print("\n}\n")
        else            
            # println("size(ax.next) = ",s," <= 0")
            stop = true
            print("}")
        end
    end
    println("---------------------------------------")

end

function insert_skiplist(sl :: skiplist, z1 :: Int64, z2 :: Int64)
    ax = sl.start

end

function delete_skiplist(sl :: skiplist, z1 :: Int64, z2 :: Int64)
    ax = sl.start
    
end

function compare_skiplist(ax1 :: cell_skiplist, ax2 :: cell_skiplist)
    if (ax1.z1 == ax2.z1 && ax1.z2 == ax2.z2)
        if(ax1.next == [] && ax2.next == [] )
            return true
        else
            if(size(ax1.next)[1] == size(ax2.next)[1])
                x = 1
                nexti = typemax(Int64)
                for i in size(ax1.next)[1]
                   if(ax1.next[i].z1 != ax2.next[i].z1 || ax1.next[i].z2 != ax2.next[i].z2)
                        if(ax1.next[i].z1 < nexti)
                            x = 1
                            nexti = ax1.next[i].z1
                        end
                   end 
                end
                return compare_skiplist(ax1.next[x],ax2.next[x])
            else
                return false
            end
        end
    else
        return false
    end
end