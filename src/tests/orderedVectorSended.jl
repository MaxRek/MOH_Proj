struct Solution
  obj::Vector{Int64}
  sol::Vector{Int64}
end

include("../struct/OrderedVector.jl")

function ToArray(ov :: orderedVector)
    a = Vector{Tuple{Int64, Int64}}()
    for i in 1:size(ov.vec)[1]
     push!(a,(ov.vec[i].obj[1],ov.vec[i].obj[2]))
    end
    return a
end


ov = orderedVector([])

e1 = Solution([5,6], [0,1,1,0,0,1,1,1])
e2 = Solution([7,7], [0,1,1,0,0,1,1,1])
e3 = Solution([2,4], [0,1,1,0,0,1,1,1])
e4 = Solution([7,1], [0,1,1,0,0,1,1,1])
e5 = Solution([6,3], [0,1,1,0,0,1,1,1])
e6 = Solution([8,4], [0,1,1,0,0,1,1,1])
e7 = Solution([3,7], [0,1,1,0,0,1,1,1])
e8 = Solution([1,9], [0,1,1,0,0,1,1,1])

open("src/tests/debug/debug_testSL.txt", "w") do file
    write(file, "Test begins : \n")
end

println("\nCas 1 : insertion e1 : résultat attendu (5,6)")
open("src/tests/debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\n Test 1 : insertion (5,6)\n")
end
insert(ov, e1)
if(ToArray(ov) == [(5,6)])
    print(" : OK")
else
  print(ToArray(ov))
end

println("\nCas 2 : insertion e2 : résultat attendu (5,6)")
open("src/tests/debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 2 : insertion (7,7)\n")
end
insert(ov, e2)
if(ToArray(ov) == [(5,6)])
    print(" : OK")
else
  print(ToArray(ov))
end

println("\nCas 3 : insertion e3 : résultat attendu (2,4)")
open("src/tests/debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 3 : insertion (2,4)\n")
end
insert(ov, e3)
if(ToArray(ov) == [(2,4)])
    print(" : OK")
else
  print(ToArray(ov))
end

println("\nCas 4 : insertion e4 : résultat attendu (2,4) (7,1)")
open("src/tests/debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 4 : insertion (7,1)\n")
end
insert(ov, e4)
if(ToArray(ov) == [(2,4), (7,1)])
    print(" : OK")
else
  print(ToArray(ov))
end

println("\nCas 5 : insertion e5 : résultat attendu (2,4) (6, 3) (7,1)")
open("src/tests/debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 5 : insertion (6,3)\n")
end
insert(ov, e5)
if(ToArray(ov) == [(2,4), (6,3), (7,1)])
    print(" : OK")
else
  print(ToArray(ov))
end

println("\nCas 6 : insertion e6 : résultat attendu (2,4) (6, 3) (7,1)")
open("src/tests/debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 6 : insertion (8,4)\n")
end
insert(ov, e6)
if(ToArray(ov) == [(2,4), (6,3), (7,1)])
    print(" : OK")
else
  print(ToArray(ov))
end

println("\nCas 7 : insertion e7 : résultat attendu (2,4) (6, 3) (7,1)")
open("src/tests/debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 7 : insertion (3,7)\n")
end
insert(ov, e7)
if(ToArray(ov) == [(2,4), (6,3), (7,1)])
    print(" : OK")
else
  print(ToArray(ov))
end

println("\nCas 8 : insertion e8 : résultat attendu (1,9) (2,4) (6, 3) (7,1)")
open("src/tests/debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 7 : insertion (3,7)\n")
end
insert(ov, e8)
if(ToArray(ov) == [(1,9),(2,4), (6,3), (7,1)])
    print(" : OK")
else
  print(ToArray(ov))
end