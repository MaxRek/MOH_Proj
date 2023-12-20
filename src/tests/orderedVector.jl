include("../struct/orderedVector.jl")

ov = orderedVector([])

e1 = solution(5, 6, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e2 = solution(7, 7, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e3 = solution(2, 4, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e4 = solution(7, 1, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e5 = solution(6, 3, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e6 = solution(8, 4, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e7 = solution(3, 7, zeros(Int64,2,2),zeros(Int64,2,2),[],[])
e8 = solution(1, 9, zeros(Int64,2,2),zeros(Int64,2,2),[],[])

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