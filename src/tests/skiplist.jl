include("../struct/skiplist.jl")

sk = init_skiplist()

insert_skiplist(sk, 5,6)
insert_skiplist(sk, 7,7)
insert_skiplist(sk, 2,4)
insert_skiplist(sk, 6,3)
insert_skiplist(sk, 8,4)
insert_skiplist(sk, 3,7)
insert_skiplist(sk, 7,1)

#[(2,4),(3,7),(5,6),(6,3),(7,1)]
sk2 = deepcopy(sk)
sk3 = deepcopy(sk)
#print_skiplist(sk)

println("compare_skiplist()")

println("\nCas 1")
if(compare_skiplist(sk.start,sk2.start))
    print(" : OK")
else
    println("ERREUR : devrait être vrai")
    print_skiplist(sk)
    print_skiplist(sk2)
end

println("\nCas 2")
if(!compare_skiplist(sk.start,sk2.start))
    print(" : OK")
else
    println("ERREUR : devrait être faux")
    print_skiplist(sk)
    print_skiplist(sk2)
end
