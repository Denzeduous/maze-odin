package maze

import "core:fmt"

push :: proc {
    push_q,
    push_pq,
    push_s,
};

pop :: proc {
    pop_q,
    pop_pq,
    pop_s,
};

push_q :: proc(_q: ^Queue($T), value: T) {
    q := _q;

    q.values[size] = value;
    q.size += 1;
}

push_pq :: proc(pq: ^Priority_Queue($R, $T), value: R, heuristic: T) {
    part1 := 0;
    part2 := len(pq.values);
    //fmt.print("Current size: ");
    //fmt.println(pq.size);
    if (pq.size > 0) {
        for {
            index := (part1 + part2) / 2;
            pq_heur := pq.heuristic[index];

            if (part1 != part2 && part1 != part2 - 1) {
                if (heuristic < pq_heur) {
                    part1 = index;
                }

                else if (heuristic > pq_heur) {
                    part2 = index;
                }

                else {
                    if (index != len(pq.values)) {
                        //fmt.println("Got here while parts are not together and index != len(pq.values)");
                        copy(pq.values[index + 1:], pq.values[index:]);
                        pq.values[index] = value;

                        copy(pq.heuristic[index + 1:], pq.heuristic[index:]);
                        pq.heuristic[index] = heuristic;
                        
                        break;
                    }

                    else {
                        //fmt.println("Got here while parts are not together and index does equal len(pq.values)");
                        append_elem(&pq.values, value);
                        append_elem(&pq.heuristic, heuristic);
                        
                        break;
                    }
                }
            }

            else {
                if (part2 != len(pq.values)) {
                    //fmt.println("Got here while parts are together and part2 != len(pq.values)");
                    copy(pq.values[part2 + 1:], pq.values[part2:]);
                    pq.values[part2] = value;

                    copy(pq.heuristic[part2 + 1:], pq.heuristic[part2:]);
                    pq.heuristic[part2] = heuristic;
                    
                    break;
                }

                else {
                    //fmt.println("Got here while parts are together and part2 does equal len(pq.values)");
                    append_elem(&pq.values, value);
                    append_elem(&pq.heuristic, heuristic);
                    
                    break;
                }
            }
        }
    }

    else {
        append_elem(&pq.values, value);
        append_elem(&pq.heuristic, heuristic);
        
        //fmt.println("Being initialized");
    }

    pq.size += 1;
}

push_s :: proc(s: ^Stack($T), value: T) {
    s.values[size] = value;
    s.size += 1;
}

pop_q :: proc(q: ^Queue($T)) -> T {
    q.size -= 1;
    val := q.values[0];
    copy(q.values[:], q.values[1:]);
    return val;
}

pop_pq :: proc(pq: ^Priority_Queue($R, $T)) -> (R, T) {
    val, heur := pq.values[0], pq.heuristic[0];
    copy(pq.values[:], pq.values[1:]);
    copy(pq.heuristic[:], pq.heuristic[1:]);
    pq.size -= 1;
    return val, heur;
}

pop_s :: proc(s: ^Stack($T)) -> T {
    s.size -= 1;
    return s.values[size];
}

clean_q :: proc(q: ^Queue($T)) {
    delete(q.values);
    free(q);
}

Priority_Queue :: struct(R, T: typeid) {
    values: [dynamic]R,
    heuristic: [dynamic]T,
    size: int,
}

Queue :: struct(T: typeid) {
    values: [dynamic]T,
    size: int,
}

Stack :: struct(T: typeid) {
    values: [dynamic]T,
    size: int,
}