from dataclasses import dataclass
from enum import IntFlag, auto


class Player(IntFlag):
    FIRST = 0
    SECOND = 1


@dataclass
class Vector2:
    x: int = 0
    y: int = 0
