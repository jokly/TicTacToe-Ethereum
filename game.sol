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
        require(uint(Symbol.X) <= _PlayerSym &&  _PlayerSym <= uint(Symbol.O));
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
        if (isEnd) {
            return;
        }
            
        if (msg.sender == player1.addr && stroke == player1.symbol) {
            SetSymbol(i, j, player1.symbol);
            stroke = player2.symbol;
        }
        else if (msg.sender == player2.addr && stroke == player2.symbol) {
            SetSymbol(i, j, player2.symbol);
            stroke = player1.symbol;
        }
    }
    
    function SetSymbol(uint8 i, uint8 j, Symbol symbol) private {
        require(i >= 0 && i <= 3);
        require(j >= 0 && j <= 3);
        
        if (field[i][j] == Symbol.Empty) {
            field[i][j] = symbol;
            FieldWasChanged();
            
            CheckWin();
        }    
    }
    
    function CheckWin() public {
        if (field[0][0] != Symbol.Empty && field[0][0] == field[1][0] && field[1][0] == field[2][0]) {
            WasWin(field[0][0]);
            isEnd = true;
        }
        if (field[0][1] != Symbol.Empty && field[0][1] == field[1][1] && field[1][1] == field[2][1]) {
            WasWin(field[0][1]);
            isEnd = true;
        }
        if (field[0][2] != Symbol.Empty && field[0][2] == field[1][2] && field[1][2] == field[2][2]) {
            WasWin(field[0][2]);
            isEnd = true;
        }
        if (field[0][0] != Symbol.Empty && field[0][0] == field[0][1] && field[0][1] == field[0][2]) {
            WasWin(field[0][0]);
            isEnd = true;
        }
        if (field[1][0] != Symbol.Empty && field[1][0] == field[1][1] && field[1][1] == field[1][2]) {
            WasWin(field[1][0]);
            isEnd = true;
        }
        if (field[2][0] != Symbol.Empty && field[2][0] == field[2][1] && field[2][1] == field[2][2]) {
            WasWin(field[2][0]);
            isEnd = true;
        }
        if (field[0][0] != Symbol.Empty && field[0][0] == field[1][1] && field[1][1] == field[2][2]) {
            WasWin(field[0][0]);
            isEnd = true;
        }
        if (field[0][2] != Symbol.Empty && field[0][2] == field[1][1] && field[1][1] == field[2][0]) {
            WasWin(field[0][2]);
            isEnd = true;
        }
    }
}
