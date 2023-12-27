function build_subSets(refsSets :: Vector{Vector{solution}}, memory :: Vector{Tuple{solution, solution}}, beta :: Int64)
    A = Vector{Tuple{solution,solution}}()
    i = 1; j = 5;
    stop = 120

    while(size(A)[1]<beta)
        if(i > beta)
            i = 1
        end
        if(j < 1)
            j = beta
        end
        if(check_memory((refsSets[1][i],refsSets[2][j]),memory))
            push!(A, (refsSets[1][i],refsSets[2][j]))
            push!(memory, (refsSets[1][i],refsSets[2][j]))
            i += 1
            j -= 1
            stop = 120

        else
            if(rand()<=0.5)
                i += 1
                stop -= 1
            else
                j -= 1
                stop -= 1
            end
        end
        if stop == 0
            println("Memory overloaded, can't find anything")
            return false
        end
        println("size memory = ",size(memory)[1],", stop = ",stop)
        stop -= 1

    end
    return A
end

function check_memory(in :: Tuple{solution,solution}, memory :: Vector{Tuple{solution,solution}})
    #println("Checking in memory")
    bool = true
    i = 1
    while(bool && i < size(memory)[1])
        if (compare_solution(in[1],memory[i][1]) || compare_solution(in[1],memory[i][1]))
            if(compare_solution(in[2],memory[i][1]) || compare_solution(in[2],memory[i][2]))
                bool = false
            else
                i += 1
            end
        else
            i += 1
        end
    end
    return bool
end