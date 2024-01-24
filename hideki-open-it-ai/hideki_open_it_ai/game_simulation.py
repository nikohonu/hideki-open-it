import random

import numpy as np
import torch

from hideki_open_it_ai.game_types import Player, Vector2


class GameSimulation:
    """Class that allow simulate hideki_open_it_ai game"""

    def __init__(self, calc_player1_move, calc_player2_move) -> None:
        self.size = 8
        self.generate_map()
        self.cursor = Vector2(4, 3)
        self.player = Player.FIRST
        self.scores = [0, 0]
        self.calc_player1_move = calc_player1_move
        self.calc_player2_move = calc_player2_move

    def generate_possible_values(self) -> list:
        """Generate possible cells values for map"""
        possible_values = []
        cells_count = self.size**2
        cell_count = 6.0
        cell_type_count = round(cells_count / cell_count)
        for value in range(1, cell_type_count + 1):
            for _ in range(int(cell_count / 2)):
                possible_values.extend([value, -value])
        random.shuffle(possible_values)
        return possible_values[:cells_count]

    def generate_map(self):
        """Generate map for game"""
        possible_values = self.generate_possible_values()
        self.map = np.zeros((self.size, self.size), dtype=int)

        for y in range(self.size):
            for x in range(self.size):
                self.map[y, x] = possible_values.pop()

    def select(self):
        """Select cell"""
        value = self.map[self.cursor.y, self.cursor.x]
        self.map[self.cursor.y, self.cursor.x] = 0
        return value

    def find_existing_move(self):
        """Find exising move if player make incorrect move"""
        if self.player == Player.FIRST:
            for i in range(8):
                if self.map[self.cursor.y, i] != 0:
                    return i
        else:
            for i in range(8):
                if self.map[i, self.cursor.x] != 0:
                    return i
        return -1

    def get_input(self):
        return torch.concat(
            [
                torch.tensor(self.map).flatten() / 11,
                torch.tensor(self.scores) / 198,
                torch.tensor([self.player]),
            ]
        )

    def simulate(self) -> Player:
        """Simulate game"""
        while True:
            if self.player == Player.FIRST:
                move = self.calc_player1_move(self.get_input())
                move = round(move.data[0].item() * 7)
                if self.map[self.cursor.y, move] == 0:
                    move = self.find_existing_move()
                    if move == -1:
                        break
                self.cursor.x = move
            else:
                move = self.calc_player2_move(self.get_input())
                move = round(move.data[0].item() * 7)
                if self.map[move, self.cursor.x] == 0:
                    move = self.find_existing_move()
                    if move == -1:
                        break
                self.cursor.y = move
            # self.print_state()
            self.scores[self.player] = self.select()
            self.player = Player.SECOND if self.player == Player.FIRST else Player.FIRST
        return (
            Player.FIRST
            if self.scores[Player.FIRST] > self.scores[Player.SECOND]
            else Player.SECOND
        )

    def print_array(
        self,
        array,
        highlight_coords,
        highlight_row,
        highlight_column,
        cell_color="\033[1;31m",
        row_column_color="\033[1;33m",
    ):
        for i in range(array.shape[0]):
            for j in range(array.shape[1]):
                cell_value = array[i, j]
                if (i, j) == highlight_coords:
                    print(f"{cell_color}{cell_value:3d}\033[0m", end=" ")
                elif (i == highlight_row or j == highlight_column) and cell_value == 0:
                    print(f"{row_column_color}---\033[0m", end=" ")
                elif i == highlight_row or j == highlight_column:
                    print(f"{row_column_color}{cell_value:3d}\033[0m", end=" ")
                elif cell_value == 0:
                    print("---", end=" ")
                else:
                    print(f"{cell_value:3d}", end=" ")
            print()

    def print_state(self):
        """Print current map state"""
        print("cursor", self.cursor, "scores", self.scores, "player", self.player)
        if self.player == Player.FIRST:
            self.print_array(
                self.map[::-1],
                (7 - self.cursor.y, self.cursor.x),
                7 - self.cursor.y,
                -1,
            )
        else:
            self.print_array(
                self.map[::-1], (7 - self.cursor.y, self.cursor.x), -1, self.cursor.x
            )
