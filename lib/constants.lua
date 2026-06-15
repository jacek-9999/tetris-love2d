-- Color definitions for Tetris pieces and UI
return {
    COLORS = {
        BACKGROUND = {0.1, 0.1, 0.15, 1},
        GRID_LINE = {0.2, 0.2, 0.25, 1},
        GRID_BORDER = {0.4, 0.4, 0.5, 1},
        TEXT = {1, 1, 1, 1},
        TEXT_SHADOW = {0.3, 0.3, 0.35, 1},
        HIGHLIGHT = {0.3, 0.7, 1, 1},
    },
    
    PIECES = {
        I = {0.0, 0.8, 1.0, 1},
        O = {1.0, 0.8, 0.0, 1},
        T = {0.7, 0.0, 0.9, 1},
        S = {0.0, 0.8, 0.3, 1},
        Z = {1.0, 0.2, 0.2, 1},
        J = {0.2, 0.4, 1.0, 1},
        L = {1.0, 0.5, 0.0, 1},
    },
    
    BOARD = {
        COLS = 10,
        ROWS = 20,
        CELL_SIZE = 30,
        OFFSET_X = 20,
        OFFSET_Y = 40,
    },
    
    GAME = {
        INITIAL_DROP_INTERVAL = 0.8,
        FAST_DROP_INTERVAL = 0.05,
        LOCK_DELAY = 0.5,
        LINES_PER_LEVEL = 10,
        POINTS = {100, 300, 500, 800},
    },
}