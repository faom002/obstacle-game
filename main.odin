package main

import "core:fmt"
import r "vendor:raylib"

main :: proc () {
    r.InitWindow(800, 500, "moving obstacles")

    circle_x: f32 = 200.0
    circle_y: f32 = 200.0
    triangle_x: f32 = 400.0
    triangle_y: f32 = 200.0

    xVel: f32 = 1.0
    yVel: f32 = 1.0

    xVel2: f32 = 1.0
    yVel2: f32 = 1.0


    speed := 0

    points := 0

    r.SetTargetFPS(60)

    for !r.WindowShouldClose() {
        ball_position := r.GetMousePosition()

	speed += 1

	if speed >= 10 {
		points += 1
		speed = 0
	}


        circle_x += xVel 
        circle_y += yVel 

        triangle_x -= xVel2
        triangle_y -= yVel2

        if circle_x >= 750 || circle_x <= 50 { xVel = -xVel }
        if circle_y >= 450 || circle_y <= 50 { yVel = -yVel }

        if triangle_x >= 750 || triangle_x <= 50 { xVel2 = -xVel2 }
        if triangle_y >= 450 || triangle_y <= 50 { yVel2 = -yVel2 }

        mouse_circle_radius: f32 = 10.0
        moving_circle_radius: f32 = 20.0
        dist_circle := r.Vector2Distance(ball_position, r.Vector2{circle_x, circle_y})
        is_circle_collision := dist_circle <= (mouse_circle_radius + moving_circle_radius)

        triangle_size: f32 = 30.0
        tri_v1 := r.Vector2{triangle_x, triangle_y - triangle_size / 2}
        tri_v2 := r.Vector2{triangle_x - triangle_size / 2, triangle_y + triangle_size / 2}
        tri_v3 := r.Vector2{triangle_x + triangle_size / 2, triangle_y + triangle_size / 2}

        is_point_in_triangle := point_in_triangle(ball_position, tri_v1, tri_v2, tri_v3)

        r.BeginDrawing()
        r.ClearBackground(r.BLACK)

        r.DrawCircleLinesV(ball_position, mouse_circle_radius, r.WHITE)

        r.DrawCircleLinesV(r.Vector2{circle_x, circle_y}, moving_circle_radius, r.RED)


        r.DrawTriangleLines(tri_v1, tri_v2, tri_v3, r.GREEN)

	r.DrawText(r.TextFormat("points: %d", points),0,0,20,r.RED)

        if is_circle_collision {
            r.DrawText("Circle Collision Detected!", 10, 10, 20, r.YELLOW)
	    
        }

        if is_point_in_triangle {
            r.DrawText("Triangle Collision Detected!", 10, 30, 20, r.YELLOW)
        }

        r.EndDrawing()
    }

    r.CloseWindow()
}

point_in_triangle :: proc(p: r.Vector2, a: r.Vector2, b: r.Vector2, c: r.Vector2) -> bool {
    d1 := sign(p, a, b)
    d2 := sign(p, b, c)
    d3 := sign(p, c, a)

    has_neg := (d1 < 0) || (d2 < 0) || (d3 < 0)
    has_pos := (d1 > 0) || (d2 > 0) || (d3 > 0)

    return !(has_neg && has_pos)
}

sign :: proc(p1: r.Vector2, p2: r.Vector2, p3: r.Vector2) -> f32 {
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
}

