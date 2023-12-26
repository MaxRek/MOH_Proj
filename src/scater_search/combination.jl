function solution_combination(subSet :: Vector{Tuple{solution,solution}})
    C = Vector{solution}()
    for i in 1:size(subSet)[1]
        push!(C,subSet[i][1])
        push!(C,subSet[i][2])
    end
    return C
end