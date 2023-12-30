using PyPlot

function plotSolutions(path, name, As, C, p)
    minX, maxX = As[1],typemin(Int64)
    minY, maxY = As[2],typemin(Int64)
    
    X = Vector{Int64}()
    Y = Vector{Int64}()

    for i in 1:size(As[3])[1]
        if As[3][i][1] > maxX
            maxX = As[3][i][1]
        end
        if As[3][i][2] > maxY
            maxY = As[3][i][2]
        end
        push!(X, As[3][i][1])
        push!(Y, As[3][i][2])

    end

    Lx = [[minX,minX],[(minY), (maxY)]]
    Ly = [[(minX), (maxX)],[minY,minY]]
    
    # println("X = ", X, ", Y = ",Y)
    # println("Lx = ",Lx)
    # println("Ly = ",Ly)
    # println("minX = ",minX,", maxX = ",maxX,", minY = ",minY,", maxY = ",maxY)

    figure("solutions efficaces",figsize=(6,6)) # Create a new figure
    title(string(" Solutions efficaces pour ", name))
    xlabel("z1")
    ylabel("z2")

    # if(size(As[3])[1]>1)
    #     xlim(round(Int64,minX*1.2), round(Int64, maxX*1.2))
    #     ylim(round(Int64,minY*1.2), round(Int64, maxY*1.2))
    # end
    #printing solutions
    if(size(X)[1]>0)
        scatter(X,Y, color = "black")
    end
    #printing z1
    plot(Lx[1],Lx[2], color = "red")
    
    #printing z2
    plot(Ly[1],Ly[2], color = "blue")

    savefig(string(path,"/",name,"_graph_y.png"))
    close()
end