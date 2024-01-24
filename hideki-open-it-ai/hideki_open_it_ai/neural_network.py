import uuid
from pathlib import Path

import torch
import torch.nn as nn
import torch.nn.functional as F


class NeuralNetwork(nn.Module):
    def __init__(
        self, name: str = "", input_nc=67, hidden_nc=80, output_nc=1, hidden_c=2
    ):
        super().__init__()
        self.name = str(uuid.uuid4()) if not name else name
        self.args = [input_nc, hidden_nc, output_nc, hidden_c]
        self.layers = nn.ModuleList()
        self.layers.append(nn.Linear(input_nc, hidden_nc))
        for _ in range(hidden_c):
            self.layers.append(nn.Linear(hidden_nc, hidden_nc))
        self.layers.append(nn.Linear(hidden_nc, output_nc))

    def forward(self, x):
        # print(self.name)
        for layer in self.layers:
            # print("i", x, end=" ")
            x = F.sigmoid(layer(x))
            # print("o", x)
        return x

    def mutate_layer(self, layer: nn.Linear, mutation_rate):
        result = [layer.weight.data, layer.bias.data]
        for i in range(2):
            mutation = torch.randn_like(result[i]) * mutation_rate
            result[i] = result[i] + mutation
        return result

    def mutate(self, name, mutation_rate=0.1):
        new_network = NeuralNetwork(name, *self.args).cuda()
        with torch.no_grad():
            for new, old in zip(new_network.layers, self.layers):
                result = self.mutate_layer(old, mutation_rate)
                new.weight.data = result[0]
                new.bias.data = result[1]
        return new_network

    def print_nn(self):
        print("-" * 64)
        for l in self.layers:
            print(l.weight.data, l.bias.data)

    def to_json(self):
        data = []
        for layer in self.layers:
            l_data = []
            l_data.append([layer.weight.tolist(), layer.bias.tolist()])
            # print(layer, layer.weight, layer.bias)
            data.append(l_data)
        return data


# def main():
#     model = NeuralNetwork(1, 2, 1, 1).cuda()
#     model_path = Path("model.model")
#     if model_path.exists():
#         model.load_state_dict(torch.load(model_path))
#     input_data = torch.tensor([0.5]).cuda()
#     child = model.mutate(0.01)
#     torch.save(model.state_dict(), model_path)
#     model.print_nn()
#     child.print_nn()
#     print(model(input_data)*7)
#     print(child(input_data)*7)
