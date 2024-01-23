import random

import numpy as np
import torch

size = 8
cursor = [4, 3]
player = 0
players_score = [0, 0]
map = []


def generate_possible_values() -> list:
    possible_values = []
    cells_count = size * size
    cell_count = 6.0
    cell_type_count = round(cells_count / cell_count)
    for value in range(1, cell_type_count + 1):
        for _ in range(int(cell_count / 2)):
            possible_values += [value, -value]
    random.shuffle(possible_values)
    return possible_values[:cells_count]


def generate_map():
    possible_values = generate_possible_values()
    for y in range(size):
        map.append([])
        for _ in range(size):
            map[y].append(possible_values.pop())
    return map


def check_game_end():
    total = 0
    if player == 0:
        for x in range(size):
            total += 1 if map[cursor[1]][x] != 0 else 0
    else:
        for y in range(size):
            total += 1 if map[y][cursor[0]] != 0 else 0
    if total == 0:
        return True
    else:
        return False


def select(value: int):
    global player, cursor, map, players_score
    new_pos = []
    if player == 0:
        new_pos = [value, cursor[1]]
        if map[cursor[1]][value] == 0:
            for i in range(8):
                if map[cursor[1]][i] != 0:
                    new_pos = [i, cursor[1]]
    elif player == 1:
        new_pos = [cursor[0], value]
        if map[value][cursor[0]] == 0:
            for i in range(8):
                if map[i][cursor[0]] != 0:
                    new_pos = [cursor[0], i]
    # print(f"player: {player}, value: {new_pos[player]}")
    players_score[player] += (
        map[new_pos[1]][value] if player == 0 else map[value][new_pos[0]]
    )
    map[new_pos[1]][new_pos[0]] = 0
    player = 1 if player == 0 else 0
    cursor = new_pos
    return not check_game_end()


def print_state():
    print("cursor", cursor, "scores", players_score, "player", player)
    print(np.matrix(map)[::-1])


def get_input():
    return torch.concat(
        [
            torch.tensor(map).flatten() / 11,
            torch.tensor(players_score) / 198,
            torch.tensor([player]),
        ]
    )


def reset():
    global cursor, player, players_score, map
    cursor = [4, 3]
    player = 0
    players_score = [0, 0]
    map = []
    generate_map()


reset()
