package maze

import "core:fmt"

heuristic :: proc(curr, end: Point) -> u32 {
    return (curr.x > end.x ? curr.x - end.x : end.x - curr.x) +
           (curr.y > end.y ? curr.y - end.y : end.y - curr.y);
}

neighbors :: proc(p: Point) -> [4]Point {
    return {Point{(p.x > 0 ? p.x - 1 : 0), p.y}, Point{p.x, (p.y > 0 ? p.y - 1 : 0)},
            Point{p.x + 1, p.y},                 Point{p.x, p.y + 1}};
}

astar :: proc(grid: []bool,
              sizex, sizey: int,
              start, end: Point) -> map[u64]Point {

    frontier := Priority_Queue(Point, u32) {make([dynamic]Point),
                                            make([dynamic]u32),
                                            0};
    fmt.println("Got here");
    push(&frontier, start, cast(u32)0);
    fmt.println("Got here 2");
    came_from := make(map[u64]Point);

    came_from[hash_point(start)] = start;

    for i in 0..5 {
        if (frontier.size == 0) {
            break;
        }
        fmt.println("Got here 3");
        curr, curr_cost := pop(&frontier);
        fmt.println("Got here 4");
        fmt.print("Current: ");
        fmt.println(curr);
        fmt.print("Neighbors: ");
        fmt.println(neighbors(curr));

        if (curr.x == end.x && curr.y == end.y) {
            break;
        }

        for next in neighbors(curr) {
            if (!grid[next.y * u32(sizex) + next.x] && (next.x != 0 || next.y != 0)) {
                fmt.print("Got here with: ");
                fmt.println(next);
                priority := heuristic(next, end);
                fmt.print("Priority: ");
                fmt.println(priority);

                push(&frontier, next, priority);
                fmt.print("Frontier size: ");
                fmt.println(frontier.size);
                came_from[hash_point(next)] = curr;
                fmt.println();
            }
        }
        fmt.println('\n');
    }

    return came_from;
}