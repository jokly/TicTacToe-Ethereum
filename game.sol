pragma solidity ^0.4.0;

contract TicTacToe {
    
    enum Symbol { Empty, X, O }
    
    struct Player {
        address addr;
        Symbol symbol;
    }
    
    Player public player1;
    Player public player2;
    
    Symbol public stroke;
    bool isEnd = false;
    Symbol[3][3] public field;
    
    event FieldWasChanged;
    event WasWin(Symbol winner);
    
    modifier OnlyPlayers() {
        require(player2.symbol != Symbol.Empty && (msg.sender == player1.addr || msg.sender == player2.addr));
        _;
    }
    
    function TicTacToe(uint8 _PlayerSym) public {
        require(uint(Symbol.X) <= _PlayerSym && _PlayerSym <= uint(Symbol.O));
        player1 = Player(msg.sender, Symbol(_PlayerSym));
        stroke = player1.symbol;
    }
    
    function Join() public {
        if (player1.addr != msg.sender && player2.symbol == Symbol.Empty) {
            player2.addr = msg.sender;
            player2.symbol = player1.symbol == Symbol.X ? Symbol.O : Symbol.X;
        }
    }
    
    function MakeMove(uint8 i, uint8 j) public OnlyPlayers() {
        if (isEnd) return;
            
        if (msg.sender == player1.addr && stroke == player1.symbol) {
            SetSymbol(i, j, player1.symbol);
        } else if (msg.sender == player2.addr && stroke == player2.symbol) {
            SetSymbol(i, j, player2.symbol);
        }
    }
    
    function SetSymbol(uint8 i, uint8 j, Symbol symbol) private {
        require(i >= 0 && i <= 3);
        require(j >= 0 && j <= 3);
        
        if (field[i][j] == Symbol.Empty) {
            field[i][j] = symbol;
            FieldWasChanged();
            stroke = symbol == Symbol.X ? Symbol.O : Symbol.X;
            CheckWin();
        }    
    }
    
    function CheckWin() public {
        uint size = field.length;
        bool res = true;

        for (uint i = 0; i < size; i++) {
            res = true;    
            for (uint j = 1; j < size; j++) {
                if (field[i][j] != field[i][j - 1]) {
                    res = false;
                    break;
                }
            }

            CheckResult(i, 0, res);
            if (isEnd) return;

            res = true;
            for (j = 1; j < size; j++) {
                if (field[j][i] != field[j - 1][i]) {
                    res = false;
                    break;
                }
            }

            CheckResult(0, i, res);
            if (isEnd) return;
        }

        res = true;
        for (j = 1; j < size; j++) {
            if (field[j][j] != field[j - 1][j - 1]) {
                res = false;
                break;
            }
        }
        
        CheckResult(0, 0, res);
        if (isEnd) return;

        res = true;
        for (j = 1; j < size; j++) {
            if (field[size - j - 1][j] != field[size - j][j - 1]) {
                res = false;
                break;
            }
        }

        CheckResult(0, size - 1, res);
        if (isEnd) return;
    }
    
    function CheckResult(uint i, uint j, bool res) private {
        if (res && field[i][j] != Symbol.Empty) {
            WasWin(field[i][j]);
            isEnd = true;
        }
    }
}