package maze

import "core:fmt"
import "core:math"

heuristic :: proc(curr, end: Point) -> f64 {
    return math.sqrt(math.pow(cast(f64)(curr.x > end.x ? curr.x - end.x : end.x - curr.x), 2) +
                     math.pow(cast(f64)(curr.y > end.y ? curr.y - end.y : end.y - curr.y), 2));
}

neighbors :: proc(p: Point,
                  sizex, sizey: int) -> [4]Point {

    return {Point{(p.x > 0 ? p.x - 1 : 0), p.y}, // Left (lower check)
            Point{p.x, (p.y > 0 ? p.y - 1 : 0)}, // Up   (lower check)
            Point{(p.x < cast(u32)sizex - 1 ? p.x + 1 : cast(u32)sizex - 1), p.y},  // Right (upper check)
            Point{p.x, (p.y < cast(u32)sizey - 1 ? p.y + 1 : cast(u32)sizey - 1)}}; // Down  (upper check)
}

is_equal :: proc(curr, next: Point) -> bool {
    return curr.x == next.x && curr.y == next.y;
}

astar :: proc(grid: []bool,
              sizex, sizey: int,
              start, end: Point) -> map[u64]Point {

    // Initialize the "point_score_priority" priority queue
    point_score_priority := Priority_Queue(Point, f64) {make([dynamic]Point),
                                            make([dynamic]f64),
                                            0};

    push(&point_score_priority, start, 0 - heuristic(start, end));

    came_from := make(map[u64]Point);

    costs := make(map[u64]f64);
    costs[hash_point(start)] = 0;

    // Loop until point_score_priority is exhausted or we've reached the end
    for {
        if (point_score_priority.size == 0) {
            break;
        }

        curr, curr_cost := pop(&point_score_priority);

        fmt.print("Current: ");
        fmt.println(curr);
        fmt.print("Came from: ");
        fmt.println(came_from[hash_point(curr)]);
        fmt.println();
        fmt.print("Neighbors: ");
        fmt.println(neighbors(curr, sizex, sizey));

        if (curr.x == end.x && curr.y == end.y) {
            return came_from;
        }

        for next in neighbors(curr, sizex, sizey) {
            fmt.print("Point: ");
            fmt.println(next);
            fmt.print("Blocked: ");
            fmt.println(grid[next.y * u32(sizex) + next.x]);
            // If not the beginning and not blocked, proceed with heuristic
            fmt.print("Points are not equal: ");
            fmt.println(next.x != curr.x || next.y != curr.y);
            if (!grid[next.y * u32(sizex) + next.x]) {
                fmt.print("heuristic: ");
                fmt.println(heuristic(curr, next));
                overall_cost := curr_cost - heuristic(curr, next);
                curr_g := costs[hash_point(curr)];
                fmt.print("curr_cost: ");
                fmt.println(curr_cost);
                fmt.print("curr_g: ");
                fmt.println(curr_g);
                previous_cost, ok := costs[hash_point(next)];
                previous_cost = ok ? previous_cost : 0;
                fmt.print("previous_cost: ");
                fmt.println(previous_cost);
                fmt.print("overall_cost: ");
                fmt.println(overall_cost);
                if (overall_cost <= previous_cost && !is_equal(came_from[hash_point(curr)], next) && !is_equal(curr, next)) {
                    fmt.print("Got here with: ");
                    fmt.println(next);
                    fmt.print("Last point: ");
                    fmt.println(came_from[hash_point(curr)]);
                    // Make the bigger heuristic values smaller for priority
                    costs[hash_point(next)] = overall_cost;
                    fmt.print("overall_cost: ");
                    fmt.println(overall_cost);
                    fmt.print("pushed score: ");
                    fmt.println(previous_cost - heuristic(next, end));
                    if (hash_point(next) in came_from)) {
                        came_from[hash_point(next)] = curr;
                    }

                    push(&point_score_priority, next, previous_cost - heuristic(next, end));
                    
                }
            }
            fmt.print("point_score_priority: ");
                    fmt.println(point_score_priority);
                    fmt.print("point_score_priority size: ");
                    fmt.println(point_score_priority.size);
            fmt.println();
        }
        fmt.println('\n');
    }

    return nil;
}

/*astar :: proc(grid: []bool,
              sizex, sizey: int,
              start, end: Point) -> map[u64]Point {

    // Initialize the "point_score_priority" priority queue
    point_score_priority := Priority_Queue(Point, f64) {make([dynamic]Point),
                                            make([dynamic]f64),
                                            0};
    
    push(&point_score_priority, start, 0);

    came_from := make(map[u64]Point);
    
    g_score := make(map[u64]f64);
    g_score[hash_point(start)] = 0;

    f_score := make(map[u64]f64);
    f_score[hash_point(start)] = heuristic(start, end);

    for {
        if (point_score_priority.size == 0) {
            break;
        }

        curr, curr_cost := pop(&point_score_priority);
        
        if (is_equal(curr, end)) {
            return came_from;
        }

        fmt.print("curr: ");
        fmt.println(curr);

        fmt.print("point_score_priority: ");
        fmt.println(point_score_priority);

        for neighbor in neighbors(curr, sizex, sizey) {
            fmt.print("neighbor: ");
            fmt.println(neighbor);
            tentative_gscore := g_score[hash_point(curr)] - heuristic(curr, neighbor);
            fmt.print("tentative_gscore: ");
            fmt.println(tentative_gscore);
            fmt.print("curr g_score: ");
            fmt.println(g_score[hash_point(curr)]);
            fmt.print("blocked: ");
            fmt.println(grid[neighbor.y * u32(sizex) + neighbor.x]);
            if tentative_gscore < g_score[hash_point(neighbor)] && !grid[neighbor.y * u32(sizex) + neighbor.x] {
                came_from[hash_point(neighbor)] = curr;

                g_score[hash_point(neighbor)] = tentative_gscore;
                fmt.print("g_score: ");
                fmt.println(tentative_gscore);
                f_score[hash_point(neighbor)] = g_score[hash_point(neighbor)] - heuristic(start, end);
                fmt.print("f_score: ");
                fmt.println(f_score[hash_point(neighbor)]);
                push(&point_score_priority, neighbor, f_score[hash_point(neighbor)]);
            }

            fmt.println();
        }

        fmt.println('\n');
    }

    return nil;
}*/