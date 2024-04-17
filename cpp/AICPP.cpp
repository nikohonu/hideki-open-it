#include "AICPP.hpp"

#include <algorithm>
#include <cmath>

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/global_constants.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/property_info.hpp>
#include <godot_cpp/godot.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

Result::Result(int val, Vector2i pos) : value(val), cursor(pos) {}

void AICPP::_bind_methods() {
  ClassDB::bind_method(D_METHOD("calc", "state", "level"), &AICPP::calc);
}

AICPP::AICPP() {}

AICPP::~AICPP() {}

GameState::GameState(Object *state) {
  Array col = state->get("map");
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      Array row = col[i];
      map[i][j] = row[j];
    }
  }
  turn = state->get("turn");
  Array state_scores = state->get("scores");
  scores[0] = state_scores[0];
  scores[1] = state_scores[1];
  cursor = state->get("cursor");
}

GameState::GameState(const GameState &other) {
  turn = other.turn;
  cursor = other.cursor;
  memcpy(map, other.map, sizeof(map));
  memcpy(scores, other.scores, sizeof(scores));
}

bool GameState::check_end() {
  int total = 0;
  if (turn == 0) {
    for (int x = 0; x < 8; x++) {
      total += (map[cursor.y][x] != 0) ? 1 : 0;
    }
  } else {
    for (int y = 0; y < 8; y++) {
      total += (map[y][cursor.x] != 0) ? 1 : 0;
    }
  }
  return total == 0;
}

void GameState::select(const Vector2i &coords) {
  cursor = coords;
  scores[turn] += map[coords.y][coords.x];
  map[coords.y][coords.x] = 0;
  turn = (turn == 0) ? 1 : 0;
}

GameState *GameState::child(int i) {
  if (this->turn == 0) {
    if (this->map[this->cursor.y][i] != 0) {
      GameState *new_state = new GameState(*this);
      new_state->select(Vector2i{i, this->cursor.y});
      return new_state;
    } else {
      return nullptr;
    }
  } else {
    if (this->map[i][this->cursor.x] != 0) {
      GameState *new_state = new GameState(*this);
      new_state->select(Vector2i{this->cursor.x, i});
      return new_state;
    } else {
      return nullptr;
    }
  }
}

int GameState::eval() { return scores[0] - scores[1]; }

Vector2i AICPP::calc(Object *state, int level) {
  int step = state->get("step");
  int depth = std::max(std::round(std::min(step / 32.0, 1.0) * level), 1.0);
  // UtilityFunctions::print("a ", depth);
  auto game_state = new GameState(state);
  auto result =
      _negamax(game_state, depth, -1000, 1000, -2 * game_state->turn + 1);
  return result.cursor;
}

Result AICPP::_negamax(GameState *state, int depth, int alpha, int beta,
                       int color) {
  if (depth == 0 || state->check_end()) {
    return Result(state->eval() * color, state->cursor);
  }
  int value = -1000;
  GameState *best_child = nullptr;
  for (int i = 0; i < 8; i++) {
    GameState *child = state->child(i);
    if (child == nullptr)
      continue;
    auto result = _negamax(child, depth - 1, -beta, -alpha, -color);
    int eval = -result.value;
    if (value < eval) {
      value = std::max({value, eval});
      alpha = std::max({alpha, value});
      best_child = child;
      if (alpha >= beta) {
        break;
      }
    } else {
      delete child;
    }
  }
  return Result(value, best_child->cursor);
}
