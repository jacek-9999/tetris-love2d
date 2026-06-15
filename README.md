# Tetris Clone

A modular Tetris game built with Lua and LÖVE2D (Love).

## Project Structure

```
├── main.lua                 # Entry point
├── conf.lua                 # LÖVE2D configuration
├── lib/
│   ├── constants.lua        # Game constants (colors, dimensions)
│   └── utils.lua            # Utility functions
├── core/
│   ├── GameLoop.lua         # Main game loop orchestrator
│   ├── GameState.lua        # State machine
│   ├── Board.lua            # Game grid/board
│   └── InputHandler.lua     # Keyboard input handling
├── entities/
│   ├── Piece.lua            # Base Tetris piece class
│   └── Pieces.lua           # Piece factory (I, O, T, S, Z, J, L)
└── states/
    ├── State.lua            # Base state class
    ├── MenuState.lua       # Main menu
    ├── PlayState.lua        # Main gameplay
    ├── PauseState.lua       # Pause menu
    └── GameOverState.lua    # Game over screen
```

## Requirements

- LÖVE2D 11.x or later

## How to Run

### Linux / macOS
```bash
love .
```

### Windows
```bash
love.exe .
```

Or drag the project folder onto the LÖVE2D executable.

## Controls

| Key | Action |
|-----|--------|
| ← → or A/D | Move piece left/right |
| ↑ or W | Rotate clockwise |
| X | Rotate counter-clockwise |
| ↓ or S | Soft drop (faster fall) |
| Space | Hard drop (instant) |
| P or Esc | Pause game |
| Enter | Select menu option |

## Features

- All 7 classic Tetris pieces (I, O, T, S, Z, J, L)
- Ghost piece showing landing position
- Score, level, and lines cleared tracking
- Increasing difficulty with levels
- Main menu, pause menu, and game over screens
- Modular architecture for easy extension

## Architecture

The game uses a state machine pattern with separate classes for:
- **Game Loop**: Orchestrates update/draw cycles
- **States**: Menu, Play, Pause, GameOver - each handles its own logic
- **Board**: Manages the game grid
- **Pieces**: Individual piece objects with rotation support
- **Input Handler**: Clean input abstraction

This makes it easy to add new features like:
- Hold piece
- Next piece preview queue
- Custom piece colors
- Sound effects
- Multiple game modes