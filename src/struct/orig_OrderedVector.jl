struct Solution
  obj::Vector{Int64}
  sol::Vector{Int64}
end

mutable struct orderedVector
  vec::Vector{Solution}
end

function insert(ov, sol)
 if ov.vec == []
   push!(ov.vec, sol)
 else
   i=1
   while(i<=size(ov.vec)[1] && ov.vec[i].obj[1]<=sol.obj[1])
     if sol.obj[2] >= ov.vec[i].obj[2] #El is dominated
       return
     end
     i = i + 1
   end
   if i>size(ov.vec)[1] 
     push!(ov.vec, sol)
   else
     insert!(ov.vec, i, sol)
   end
   j = i
   while j<=size(ov.vec)[1]
     if sol.obj[2] <= ov.vec[i].obj[2]
       ov.vec = ov.vec[1:j]
       return
     end
     j = j + 1
   end
 end
end
