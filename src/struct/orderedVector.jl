include("solution.jl")

mutable struct orderedVector
  vec::Vector{solution}
end

function insert(ov :: orderedVector, s :: solution)
 if ov.vec == []
   push!(ov.vec, s)
 else
   i=1
   while(i<=size(ov.vec)[1] && ov.vec[i].z1<=s.z1)
     if s.z2 >= ov.vec[i].z2 #El is dominated
       return
     end
     i = i + 1
   end
   if i>size(ov.vec)[1] 
     push!(ov.vec, s)
   else
     insert!(ov.vec, i, s)
   end
   j = i
   while j<=size(ov.vec)[1]
     if s.z2 <= ov.vec[i].z2
       ov.vec = ov.vec[1:j]
       return
     end
     j = j + 1
   end
 end
end

function ToArray(ov :: orderedVector)
  a = Vector{Tuple{Int64, Int64}}()
  for i in 1:size(ov.vec)[1]
   push!(a,(ov.vec[i].z1,ov.vec[i].z2))
  end
  return a
end