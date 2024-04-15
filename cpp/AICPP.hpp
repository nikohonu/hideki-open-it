#ifndef AICPP_HPP
#define AICPP_HPP

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/vector2i.hpp>

namespace godot {

struct Result {
  int value;
  Vector2i cursor;
  Result(int val, Vector2i pos);
};

struct GameState {
  int map[8][8];
  int turn;
  int scores[2];
  Vector2i cursor;

  GameState(Object *state);
  GameState(const GameState &other);
  bool check_end();
  void select(const Vector2i &coords);
  int eval();
  GameState *child(int i);
};

class AICPP : public Node {
  GDCLASS(AICPP, Node)

protected:
  static void _bind_methods();

public:
  AICPP();  // constructor
  ~AICPP(); // destructor
  Vector2i calc(Object *state, int level);
  Result _negamax(GameState *state, int depth, int alpha, int beta, int color);
};

} // namespace godot

#endif // AICPP_HPP
