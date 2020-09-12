'''
Team Dijkstra
Board Generator
'''

import random
import math

class_name = 'evilExcavationsNoTraps'
name = 'team dijkstra test map (no traps)'
map_output = open('C:\\Users\\Alexander Liu\\Desktop\\dijkstra_maps\\{}.txt'.format(class_name), 'w')
board = []
rows = 100
cols = 100
start_x = 25
start_y = 55
cycle_time = 0.5
end_time = 300.0
n_lo = 10
n_hi = 40
for y in range(cols):
    row = []
    for x in range(rows):
        row.append(random.randint(n_lo, n_hi))
    board.append(row)
def generate_rectangle(board, x, y, w, h, lo, hi):
    for a in range(y, y + h):
        for b in range(x, x + w):
            board[a][b] = random.randint(lo, hi)
    return board
def generate_death_rectangle(board, x, y, w, h):
    for a in range(y, y + h):
        for b in range(x, x + w):
            board[a][b] = '(death)'
    return board
def map_like_arduino(value, min_1, max_1, min_2, max_2):
    range_1 = max_1 - min_1
    range_2 = max_2 - min_2
    scaled = float(value - min_1) / float(range_1)
    return min_2 + (scaled * range_2)
def generate_g_circle(board, x, y, layers):
    # layers go from core to outside
    # [radius, lo, hi]
    total_r = 0
    for l in layers:
        for angle in range(0, 360):
            for r in range(l[0]):
                cell_x = (total_r + r) * math.sin(math.radians(angle)) + x
                cell_y = (total_r + r) * math.cos(math.radians(angle)) + y
                if cell_x < 0:
                    cell_x = 0
                elif cell_x >= rows:
                    cell_x = rows
                if cell_y < 0:
                    cell_y = 0
                elif cell_y >= cols:
                    cell_y = cols
                board[int(round(cell_y))][int(round(cell_x))] = int(map_like_arduino(r, 0, l[0], l[1], l[2]))
        total_r += l[0]
    return board
def put_special_cell(board, c_type, x, y, x_2 = 0, y_2 = 0, jump_length = 0, hi = 0, lo = 0):
    if c_type == 0:
        board[y][x] = '(death)'
    elif c_type == 1:
        board[y][x] = '(jump {})'.format(jump_length)
    elif c_type == 2:
        board[y][x] = '(warpTo {}@{})'.format(x_2, y_2)
    elif c_type == 3:
        board[y][x] = random.randint(lo, hi)
    return board

board = generate_death_rectangle(board, 0, 38, 100, 62)
board = generate_rectangle(board, 1, 39, 98, 60, n_lo, n_hi)
board = generate_death_rectangle(board, 19, 39, 1, 32)
board = generate_death_rectangle(board, 29, 39, 1, 32)
board = generate_death_rectangle(board, 8, 49, 33, 1)
board = generate_death_rectangle(board, 8, 59, 33, 1)
board = generate_death_rectangle(board, 4, 4, 15, 15)
board = generate_death_rectangle(board, 89, 0, 11, 1)
board = generate_death_rectangle(board, 99, 0, 1, 11)
board = generate_death_rectangle(board, 63, 59, 37, 1)
board = generate_death_rectangle(board, 62, 48, 1, 1)

for i in range(9):
    board = generate_death_rectangle(board, 61, 49 + i * 4, 1, 1)
    board = generate_death_rectangle(board, 60, 50 + i * 4, 1, 1)
    board = generate_death_rectangle(board, 61, 51 + i * 4, 1, 1)
    board = generate_death_rectangle(board, 62, 52 + i * 4, 1, 1)
board = generate_rectangle(board, 75, 21, 6, 4, lo=400, hi=600)
board = generate_rectangle(board, 81, 21, 1, 5, lo=-200, hi=-100)
board = put_special_cell(board, 1, 79, 23, jump_length=6)
board = put_special_cell(board, 2, 79, 24, 72, 36)
board = generate_death_rectangle(board, 64, 17, 1, 23 - 17)
board = generate_death_rectangle(board, 66, 15, 1, 7)
board = generate_death_rectangle(board, 68, 13, 1, 13 - 22)
board = generate_death_rectangle(board, 66, 23, 1, 36 - 23)
board = generate_death_rectangle(board, 68, 24, 1, 36 - 24)
board = generate_death_rectangle(board, 70, 15, 1, 20 - 15)
board = generate_death_rectangle(board, 70, 24, 1, 27 - 24)
board = generate_death_rectangle(board, 70, 29, 1, 36 - 29)
board = generate_death_rectangle(board, 66, 23, 1, 35 - 23)
board = generate_death_rectangle(board, 72, 12, 1, 25 - 12)
board = generate_death_rectangle(board, 72, 31, 1, 36 - 31)
board = generate_death_rectangle(board, 74, 14, 1, 25 - 14)
board = generate_death_rectangle(board, 74, 33, 1, 2)
board = generate_death_rectangle(board, 76, 12, 1, 14 - 12)
board = generate_death_rectangle(board, 76, 16, 1, 19 - 16)
board = generate_death_rectangle(board, 76, 27, 1, 29 - 27)
board = generate_death_rectangle(board, 66, 23, 1, 2)
board = generate_death_rectangle(board, 80, 22, 1, 4)
board = generate_death_rectangle(board, 80, 27, 1, 5)
board = generate_death_rectangle(board, 82, 20, 1, 33 - 20)
board = generate_death_rectangle(board, 84, 14, 1, 35 - 14)

# YES

board = generate_death_rectangle(board, 72, 12, 76 - 72, 1)
board = generate_death_rectangle(board, 68, 13, 72 - 68, 1)
board = generate_death_rectangle(board, 72, 14, 74 - 72, 1)
board = generate_death_rectangle(board, 76, 14, 84 - 76, 1)
board = generate_death_rectangle(board, 66, 15, 68 - 66, 1)
board = generate_death_rectangle(board, 76, 16, 83 - 76, 1)
board = generate_death_rectangle(board, 64, 17, 66 - 64, 1)
board = generate_death_rectangle(board, 78, 18, 84 - 78, 1)
board = generate_death_rectangle(board, 68, 20, 71 - 68, 1)
board = generate_death_rectangle(board, 74, 20, 83 - 74, 1)
board = generate_death_rectangle(board, 68, 22, 71 - 68, 1)
board = generate_death_rectangle(board, 77, 22, 80 - 77, 1)
board = generate_death_rectangle(board, 74, 25, 80 - 74, 1)
board = generate_death_rectangle(board, 70, 27, 76 - 70, 1)
board = generate_death_rectangle(board, 78, 27, 80 - 78, 1)
board = generate_death_rectangle(board, 70, 29, 79 - 70, 1)
board = generate_death_rectangle(board, 72, 31, 80 - 72, 1)
board = generate_death_rectangle(board, 74, 33, 83 - 74, 1)
board = generate_death_rectangle(board, 76, 35, 85 - 76, 1)
board = generate_death_rectangle(board, 68, 36, 77 - 68, 1)
board = generate_death_rectangle(board, 64, 23, 3, 1)
board = generate_death_rectangle(board, 68, 13, 1, 22 - 13)

board = generate_rectangle(board, 5, 5, 13, 13, 100, 200)
board = put_special_cell(board, 1, 11, 2, jump_length=3)
board = put_special_cell(board, 1, 2, 11, jump_length=3)
board = put_special_cell(board, 1, 20, 11, jump_length=3)
board = put_special_cell(board, 1, 11, 20, jump_length=3)
board = generate_rectangle(board, 20, 21, 33, 14, -100, -80)
board = generate_rectangle(board, 32, 26, 9, 4, 100, 250)

board = generate_rectangle(board, 90, 1, 9, 9, -200, -100)
board = generate_rectangle(board, 92, 3, 5, 5, 150, 350)

board = put_special_cell(board, 1, 17, 40, jump_length=6)
board = put_special_cell(board, 1, 24, 57, jump_length=5)
board = put_special_cell(board, 1, 25, 62, jump_length=5)
board = put_special_cell(board, 1, 31, 54, jump_length=7)
board = put_special_cell(board, 1, 31, 62, jump_length=4)
board = put_special_cell(board, 2, 6, 49, 18, 51)
board = put_special_cell(board, 2, 7, 49, 18, 51)
board = put_special_cell(board, 2, 6, 59, 18, 59)
board = put_special_cell(board, 2, 7, 59, 18, 59)

board = generate_g_circle(board, 24, 84, [(8, 200, 10), (4, -75, -150)])

board = generate_rectangle(board, 14, 50, 2, 9, 100, 300)

board = put_special_cell(board, 3, 9, 53, hi=300, lo=100)
board = put_special_cell(board, 3, 9, 55, hi=300, lo=100)
board = put_special_cell(board, 3, 11, 52, hi=300, lo=100)
board = put_special_cell(board, 3, 12, 53, hi=300, lo=100)
board = put_special_cell(board, 3, 12, 54, hi=300, lo=100)
board = put_special_cell(board, 3, 12, 55, hi=300, lo=100)
board = put_special_cell(board, 3, 11, 56, hi=300, lo=100)

board = generate_rectangle(board, 30, 55, 3, 3, 200, 300)
board = generate_rectangle(board, 30, 46, 3, 3, 200, 300)
board = put_special_cell(board, 2, 31, 43, 44, 28)
board = put_special_cell(board, 2, 2, 97, 2, 2)
board = put_special_cell(board, 2, 40, 60, 25, 12)
board = generate_rectangle(board, 53, 55, 7, 7, -800, -500)
board = generate_rectangle(board, 63, 48, 10, 8, 200, 350)
board = put_special_cell(board, 3, 56, 58, hi=1000, lo=800)
board = generate_rectangle(board, 63, 60, 36, 2, -450, -350)
board = generate_rectangle(board, 63, 71, 36, 2, -450, -350)
board = generate_rectangle(board, 71, 62, 3, 9, -450, -350)
board = generate_rectangle(board, 88, 62, 3, 9, -450, -350)
board = put_special_cell(board, 1, 61, 58, jump_length=5)
board = put_special_cell(board, 1, 61, 62, jump_length=5)
board = put_special_cell(board, 1, 61, 70, jump_length=5)
board = put_special_cell(board, 1, 72, 59, jump_length=5)
board = put_special_cell(board, 1, 89, 59, jump_length=5)
board = put_special_cell(board, 1, 70, 62, jump_length=5)
board = put_special_cell(board, 1, 74, 62, jump_length=5)
board = put_special_cell(board, 1, 87, 62, jump_length=5)
board = put_special_cell(board, 1, 91, 62, jump_length=5)
board = put_special_cell(board, 1, 98, 62, jump_length=5)
board = put_special_cell(board, 1, 70, 70, jump_length=5)
board = put_special_cell(board, 1, 74, 70, jump_length=5)
board = put_special_cell(board, 1, 87, 70, jump_length=5)
board = put_special_cell(board, 1, 91, 70, jump_length=5)
board = put_special_cell(board, 1, 98, 70, jump_length=5)
board = put_special_cell(board, 3, 11, 18, hi=n_hi, lo=n_lo)
board = generate_rectangle(board, 61, 84, 1, 15, -1000, -800)
board = generate_rectangle(board, 55, 90, 5, 5, 400, 600)
board = generate_rectangle(board, 64, 39, 14, 9, -150, -100)
board = generate_death_rectangle(board, 72, 60, 1, 13)
board = generate_death_rectangle(board, 89, 60, 1, 13)
board = generate_death_rectangle(board, 63, 73, 9, 1)
board = generate_death_rectangle(board, 74, 73, 14, 1)
board = generate_death_rectangle(board, 90, 73, 9, 1)
board = generate_rectangle(board, 63, 63, 4, 7, 200, 400)
board = generate_rectangle(board, 79, 64, 4, 7, 200, 500)
board = generate_rectangle(board, 93, 65, 5, 3, 200, 550)
board = put_special_cell(board, 3, 52, 38, hi=n_hi, lo=n_lo)
parsed_board = ['#({})'.format(' '.join([str(a) for a in i])) for i in board]
parsed_board = '\n		'.join(parsed_board)
output = '{}\n	^self new\n		name: \'{}\';\n		extent: {} @ {};\n		cycleTime: {}s;\n		endTime: {}s;\n		startLocation: {}@{};\n		cells: #(\n		{}\n		);\n		yourself'.format(class_name, name, rows, cols, cycle_time, end_time, start_x, start_y, parsed_board)
map_output.write(output)
