function printMatrix(matrix, io = "")
    if(io == "")
        for i in 1:size(matrix)[1]
            println(matrix[Int64(i),:])
        end
    else
        for i in 1:size(matrix)[1]
            println(io,matrix[Int64(i),:])
        end
    end
end