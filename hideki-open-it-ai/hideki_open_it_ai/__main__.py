import random
from pathlib import Path

import torch

from hideki_open_it_ai import game
from hideki_open_it_ai.neural_network import NeuralNetwork


def main():
    all_players = []
    for i in range(10000):
        all_players.append(NeuralNetwork())
    while len(all_players) > 1:
        random.shuffle(all_players)
        players = []
        players.append(all_players.pop())
        players.append(all_players.pop())
        c = 0
        # players[0].print_nn()
        # players[1].print_nn()
        while True:
            c += 1
            # i = input()
            # if i == "r":
            #     continue
            # print(game.get_input())
            s = players[game.player](game.get_input()).tolist()
            # print(s)
            if not game.select(round(s[0] * 7)):
                # game.print_state()
                break
            # game.print_state()
        game.reset()
        print(c)
        if game.players_score[0] > game.players_score[1]:
            all_players.append(players[0])
        else:
            all_players.append(players[1])

    #     game.reset()
    model_path = Path("model.model")
    torch.save(all_players[0].state_dict(), model_path)
    # model = NeuralNetwork()
    # model.load_state_dict(torch.load(model_path))
    # model.print_nn()


if __name__ == "__main__":
    main()
