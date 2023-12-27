function solution_combination(subSet :: Vector{Tuple{solution,solution}})
    C = Vector{solution}()

    for i in 1:size(subSet)[1]
        dominated = dominates(subSet[i][1],subSet[i][2])
        if dominated == 1 
            println("z1")
            s_init = subSet[i][2]
            s_targ = subSet[i][1]
        else
            if dominated == 2
                println("z2")

                s_init = subSet[i][1]
                s_targ = subSet[i][2]
            else
                println("none")

                if round(Int64, rand())+1 == 1
                    println("z1 picked")

                    s_init = subSet[i][2]
                    s_targ = subSet[i][1]
                else
                    println("z2 picked")

                    s_init = subSet[i][1]
                    s_targ = subSet[i][2]
                end
            end
        end
        println("z^1 = (",subSet[i][1].z1,",",subSet[i][1].z2,"), z^2 = (",subSet[i][2].z1,",",subSet[i][2].z2,")")

        #path_relinking
        println(compare_cl(s_init,s_targ))
        light_print_solution(s_init)
        light_print_solution(s_targ)
    end

end

function compare_cl(s_init :: solution, s_target :: solution)
    In = Vector{Vector{Int64}}()
    Out = Vector{Vector{Int64}}()

    println("s(zK) = ",size(s_init.zK)[1], ",s(zJ) = ", size(s_init.zJ)[1] )


    #zK
    push!(In, Vector{Int64}())
    push!(Out, Vector{Int64}())
    for i in 1:size(s_target.zK)[1]
        if(s_target.zK[i] == 1 && s_init.zK[i] == 0)
            push!(In[1],i)
        else
            if(s_target.zK[i] == 0 && s_init.zK[i] == 1)
                push!(Out[1],i)
            end
        end
    end

    #zJ
    push!(In, Vector{Int64}())
    push!(Out, Vector{Int64}())
    for i in 1:size(s_init.zJ)[1]
        if(s_target.zJ[i] == 1 && s_init.zJ[i] == 0)
            push!(In[2],i)
        else
            if(s_target.zJ[i] == 0 && s_init.zJ[i] == 1)
                println("s_target.zJ[",i,"] = ", s_target.zJ[i],", s_init.zJ[,",i,"] = ",s_init.zJ[i],)
                push!(Out[2],i)
            end
        end
    end

    return In,Out
end