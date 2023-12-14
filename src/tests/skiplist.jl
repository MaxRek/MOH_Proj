include("../struct/skiplist.jl")

sk = SkipList([])

e1 = SolutionOfProblem([5,6], [0,1,1,0,0,1,1,1])
e2 = SolutionOfProblem([7,7], [0,1,1,0,0,1,1,1])
e3 = SolutionOfProblem([2,4], [0,1,1,0,0,1,1,1])
e4 = SolutionOfProblem([7,1], [0,1,1,0,0,1,1,1])
e5 = SolutionOfProblem([6,3], [0,1,1,0,0,1,1,1])
e6 = SolutionOfProblem([8,4], [0,1,1,0,0,1,1,1])
e7 = SolutionOfProblem([3,7], [0,1,1,0,0,1,1,1])
e8 = SolutionOfProblem([1,9], [0,1,1,0,0,1,1,1])

open("debug/debug_testSL.txt", "w") do file
    write(file, "Test begins : \n")
end

println("\nCas 1 : insertion e1 : résultat attendu [5,6]")
open("debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\n Test 1 : insertion [5,6]\n")
end
insert_skiplist(sk, e1, true)
if(ToArray(sk) == [[5,6]])
    print(" : OK")
else
  print(ToArray(sk))
end

println("\nCas 2 : insertion e2 : résultat attendu [5,6]")
open("debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 2 : insertion [7,7]\n")
end
insert_skiplist(sk, e2, true)
if(ToArray(sk) == [[5,6]])
    print(" : OK")
else
  print(ToArray(sk))
end

println("\nCas 3 : insertion e3 : résultat attendu [2,4]")
open("debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 3 : insertion [2,4]\n")
end
insert_skiplist(sk, e3, true)
if(ToArray(sk) == [[2,4]])
    print(" : OK")
else
  print(ToArray(sk, true))
end

println("\nCas 4 : insertion e4 : résultat attendu [2,4] [7,1]")
open("debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 4 : insertion [7,1]\n")
end
insert_skiplist(sk, e4, true)
if(ToArray(sk) == [[2,4], [7,1]])
    print(" : OK")
else
  print(ToArray(sk, true))
end

println("\nCas 5 : insertion e5 : résultat attendu [2,4] [6, 3] [7,1]")
open("debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 5 : insertion [6,3]\n")
end
insert_skiplist(sk, e5, true)
if(ToArray(sk) == [[2,4], [6,3], [7,1]])
    print(" : OK")
else
  print(ToArray(sk, true))
end

println("\nCas 6 : insertion e6 : résultat attendu [2,4] [6, 3] [7,1]")
open("debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 6 : insertion [8,4]\n")
end
insert_skiplist(sk, e6, true)
if(ToArray(sk) == [[2,4], [6,3], [7,1]])
    print(" : OK")
else
  print(ToArray(sk, true))
end

println("\nCas 7 : insertion e7 : résultat attendu [2,4] [6, 3] [7,1]")
open("debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 7 : insertion [3,7]\n")
end
insert_skiplist(sk, e7, true)
if(ToArray(sk) == [[2,4], [6,3], [7,1]])
    print(" : OK")
else
  print(ToArray(sk, true))
end

println("\nCas 8 : insertion e8 : résultat attendu [1,9] [2,4] [6, 3] [7,1]")
open("debug/debug_testSL.txt", "a") do file
write(file, "--------------------------------------------------\nTest 7 : insertion [3,7]\n")
end
insert_skiplist(sk, e8, true)
if(ToArray(sk) == [[1,9],[2,4], [6,3], [7,1]])
    print(" : OK")
else
  print(ToArray(sk, true))
end


