import json
import random
import uuid
from itertools import islice
from pathlib import Path

import torch

from hideki_open_it_ai.game_simulation import GameSimulation
from hideki_open_it_ai.neural_network import NeuralNetwork


def load_best_prev_players(mutate=True) -> list:
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
    """Generate 128 playes"""
    players = load_best_prev_players()
    while len(players) < 128:
        players.append(NeuralNetwork())
    random.shuffle(players)
    return players


def batched(iterable, n):
    it = iter(iterable)
    while True:
        batch = tuple(islice(it, n))
        if not batch:
            break
        yield batch


def tornament(players, min=2):
    if len(players) <= min:
        return players
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


def max_player(input: torch.tensor):
    map = (input[:64] * 22).reshape(-1, 8)
    cursor = input[64] * 7
    score = input[65] * 198
    player = int(input[-1])
    cells = map[int(cursor), ::] if player == 0 else map[::, int(cursor)]
    best_move = 0
    best_cell = float("-inf")
    for move, cell in enumerate(cells):
        if cell > best_cell and cell >= -11:
            best_cell = cell
            best_move = move
    print(map)
    print("cursor", cursor, "player", player, "best_move", best_move, "score", score)
    return torch.tensor([best_move / 7])


# torch.set_default_device(torch.cuda.current_device())
torch.set_num_threads(12)


def test(model):
    print("test", model(torch.zeros(67)), model(torch.ones(67)))
    pass


def main():
    inputs = []
    outputs = []
    # --------------- here ---------------
    # 34
    epochs = 1000
    g = 200
    hn = 140
    hc = 2
    # --------------- here ---------------
    # for i in range(g):
    #     gs = GameSimulation(max_player, max_player)
    #     result, local_inputs, locals_outputs = gs.simulate()
    #     inputs.extend(local_inputs)
    #     outputs.extend(locals_outputs)
    # inputs = torch.stack(inputs)
    model_path = Path("model.model")

    model = NeuralNetwork("a", 67, hn, 1, hc)
    if model_path.exists():
        model.load_state_dict(torch.load(model_path))
    result = 0
    i = 0
    while result != 1:
        gs = GameSimulation(max_player, model)
        result, _, _ = gs.simulate()
        i += 1
        print(f"{i} win player {result}")
        break
    # test(model)
    # optimizer = torch.optim.SGD(model.parameters(), lr=0.01)
    # criterion = torch.nn.MSELoss()
    # optimizer = torch.optim.Adam(model.parameters())
    # best_training_loss = float("inf")
    # for e in range(epochs):
    #     running_loss = 0
    #     for input, output_i in zip(inputs, outputs):
    #         optimizer.zero_grad()
    #         output = model(input)
    #         loss = criterion(output, output_i)
    #         loss.backward()
    #         optimizer.step()
    #         running_loss += loss.item()
    #     else:
    #         training_loss = running_loss / len(input)
    #         print(
    #             f"Epoch {e}, Training loss: {training_loss}, {best_training_loss-training_loss}, {best_training_loss}"
    #         )
    #         if training_loss < ((1.0 / 7.0) ** 2):
    #             test(model)
    #             save_dict_to_json(model.to_json(), "ai.json")
    #             torch.save(model.state_dict(), model_path)
    #             break
    #         best_training_loss = min(training_loss, best_training_loss)
    # print(model(inputs[10]), max_player(inputs[10]))
    # test(model)
    # save_dict_to_json(model.to_json(), "ai.json")
    # torch.save(model.state_dict(), model_path)


if __name__ == "__main__":
    main()
