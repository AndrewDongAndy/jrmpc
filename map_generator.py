'''
Team Dijkstra's
Board Generator
Note: All entered values should be 0 indexed
'''

import random
import math

def limit(n, minn, maxn):
    return max(min(maxn, n), minn)

def int_v_map(value, value1_low_range, value1_high_range, value2_low_range, value2_highrange, falloff = 1.0):
    range_1 = value1_high_range - value1_low_range
    range_2 = value2_highrange - value2_low_range
    range_ratio = range_2 / range_1
    mapped_value = round(limit(value ** falloff, value1_low_range, value1_highrange) * range_ratio)
    return mapped_value

class jrmpcboard():
    def __init__(self, class_name, board_name, rows, columns, start_x, start_y, cycle_time, end_time):
        self.class_name = class_name
        self.name = board_name
        self.rows = rows # y height
        self.cols = columns # x width
        self.x = start_x + 1
        self.y = start_y + 1
        self.ct = cycle_time
        self.et = end_time
        self.parsed_board = ''
        self.__init_board()
    def __init_board(self):
        self.board = []
        for y in range(self.rows):
            row = []
            for x in range(self.cols):
                row.append(0)
            self.board.append(row)
    def fill_board(self, low_range, high_range):
        if low_range > high_range:
            raise Exception('Your lower range can\'t be higher than your high range!')
        else:
            for y in range(self.rows):
                for x in range(self.cols):
                    self.board[y][x] = random.randint(low_range, high_range)
    def rect(self, x, y, width, height, low_range = 0, high_range = 0, death=False):
        if low_range > high_range:
            raise Exception('Your lower range can\'t be higher than your high range!')
        elif width <= 0 or height <= 0:
            raise Exception('Your width cannot be equal or lower than 0')
        elif width > self.cols or height > self.rows:
            raise Exception('Your width/height cannot be higher than the board width/height!\nMax width: {}, Max height: {}'.format(self.cols, self.rows))
        else:
            x = x % self.cols
            y = y % self.rows
            if not death:
                for a in range(y, y + height):
                    for b in range(x, x + width):
                        self.board[a][b] = random.randint(low_range, high_range)
            else:
                for a in range(y, y + height):
                    for b in range(x, x + width):
                        self.board[a][b] = '(death)'
    def circle(self, a, b, layers):
        r_counter = 0
        layer_counter = 1
        for layer in layers:
            for r in range(layer[0]):
                for y in range(layer[0] * 2):
                    for x in range(layer[0] * 2):
                        point = (x - a) ** 2 + (y - b) ** 2 - (r_counter + r + 1) ** 2
                        if point <= 1 and point >= -5:
                            self.board[limit(y, 0, self.rows - 1)][limit(x, 0, self.cols - 1)] = int_v_map(r + 1, 1, layer[0], layer[1], layer[2])
            r_counter += layer[0]
            layer_counter += 1
    def place_cell(self, cell_type, x, y, args):
        cell_type = int(cell_type)
        if cell_type == 0:
            self.board[y][x] = '(death)'
        elif cell_type == 1:
            self.board[y][x] = '(jump {})'.format(args[0])
        elif cell_type == 2:
            self.board[y][x] = '(warpTo {}@{})'.format(args[0] + 1, args[1] + 1)
        elif cell_type == 3:
            if args[0] > args[1]:
                raise Exception('Your lower range can\'t be higher than your high range!')
            else:
                self.board[y][x] = random.randint(args[0], args[1])
        else:
            raise Exception('There isn\'t a cell type No.{}'.format(cell_type))
    def save(self, path, filename):
        map_output = open('{}\\{}.txt'.format(path, filename), 'w')
        parsed_board = ['#({})'.format(' '.join([str(a) for a in i])) for i in self.board]
        parsed_board = '\n		'.join(parsed_board)
        self.output = '{}\n	^self new\n		name: \'{}\';\n		extent: {} @ {};\n		cycleTime: {}s;\n		endTime: {}s;\n		startLocation: {}@{};\n		cells: #(\n		{}\n		);\n		yourself'.format(self.class_name, self.name, self.cols, self.rows, float(self.ct), float(self.et), self.x, self.y, parsed_board)
        map_output.write(self.output)
        map_output.close()
        print('Written to {}\\{}.txt'.format(path, filename))