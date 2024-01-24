import json
import random
import uuid
from itertools import islice
from pathlib import Path

import torch

from hideki_open_it_ai.game_simulation import GameSimulation
from hideki_open_it_ai.neural_network import NeuralNetwork


def load_best_prev_players(mutate=True):
    players = []
    models_path = Path("models")
    for model_path in models_path.glob("*.dat"):
        name = model_path.stem
        player = NeuralNetwork(name)
        player.load_state_dict(torch.load(model_path))
        players.append(player)
        if not mutate:
            continue
        for _ in range(31):
            name = str(uuid.uuid4())
            player_m = player.mutate(f"{name}")
            players.append(player_m)
    return players


def generate_players():
    """Generate 256 playes"""
    players = load_best_prev_players()
    while len(players) < 256:
        players.append(NeuralNetwork())
    return players


def batched(iterable, n):
    it = iter(iterable)
    while True:
        batch = tuple(islice(it, n))
        if not batch:
            break
        yield batch


def tornament(players, min=8):
    if len(players) <= min:
        return players
    random.shuffle(players)
    new_round_players = []
    for current_players in list(batched(players, 2)):
        gs = GameSimulation(current_players[0], current_players[1])
        new_round_players.append(current_players[gs.simulate()])
    return tornament(new_round_players, min)


def remove_all_files(directory_path):
    path = Path(directory_path)
    for file_path in path.iterdir():
        if file_path.is_file():
            # print("remove", file_path)
            file_path.unlink()


def save(players):
    models_path = Path("models")
    models_path.mkdir(exist_ok=True)
    remove_all_files(models_path)
    for player in players:
        model_path = models_path / f"{player.name}.dat"
        torch.save(player.state_dict(), model_path)


def save_dict_to_json(data, file_path):
    with open(file_path, "w") as json_file:
        json.dump(data, json_file, indent=4)


def main():
    # train
    # for i in range(10000):
    #     print(f"Gen {i}")
    #     players = generate_players()
    #     players = tornament(players)
    #     save(players)
    # load
    # players = load_best_prev_players(mutate=False)
    # players = tornament(players, 1)
    # model = players[0]
    # data = torch.zeros(67)
    # print(model(data).item())
    model_path = Path("model.model")
    model = NeuralNetwork("", 1, 2, 1, 0)
    model.load_state_dict(torch.load(model_path))
    print(model)
    #     torch.save(model.state_dict(), model_path)
    save_dict_to_json(model.to_json(), "ai.json")
    data = torch.zeros(1)
    print(model(data))

    # all_players = []
    # for i in range(10000):
    #     all_players.append(NeuralNetwork())
    # while len(all_players) > 1:
    #     random.shuffle(all_players)
    #     players = []
    #     players.append(all_players.pop())
    #     players.append(all_players.pop())
    #     c = 0
    #     # players[0].print_nn()
    #     # players[1].print_nn()
    #     while True:
    #         c += 1
    #         # i = input()
    #         # if i == "r":
    #         #     continue
    #         # print(game.get_input())
    #         s = players[game.player](game.get_input()).tolist()
    #         # print(s)
    #         if not game.select(round(s[0] * 7)):
    #             # game.print_state()
    #             break
    #         # game.print_state()
    #     game.reset()
    #     print(c)
    #     if game.players_score[0] > game.players_score[1]:
    #         all_players.append(players[0])
    #     else:
    #         all_players.append(players[1])
    #
    # #     game.reset()
    # model_path = Path("model.model")
    # torch.save(all_players[0].state_dict(), model_path)
    # # model = NeuralNetwork()
    # # model.load_state_dict(torch.load(model_path))
    # # model.print_nn()


if __name__ == "__main__":
    main()
