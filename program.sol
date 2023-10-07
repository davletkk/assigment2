// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RockPaperScissors {
    enum Move { Rock, Paper, Scissors }
    
    struct Game {
        address player;
        Move playerMove;
        Move randomMove;
        uint256 betAmount;
        uint256 rewardAmount;
    }
    
    Game[] public games;
    
    function play(Move _playerMove) external payable {
        require(msg.value == 0.0001 ether, "Пожалуйста, отправьте 0,0001 тBNB для участия.");
        
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 3;
        Move randomMove = Move(randomNumber);
        
        Move result = getWinner(_playerMove, randomMove);
        
        uint256 reward = result == _playerMove ? msg.value * 2 : 0;
        
        games.push(Game(msg.sender, _playerMove, randomMove, msg.value, reward));
        
        if (reward > 0) {
            payable(msg.sender).transfer(reward);
        }
    }
    
    function getWinner(Move _playerMove, Move _randomMove) private pure returns (Move) {
        if ((_playerMove == Move.Rock && _randomMove == Move.Scissors) ||
            (_playerMove == Move.Paper && _randomMove == Move.Rock) ||
            (_playerMove == Move.Scissors && _randomMove == Move.Paper)) {
            return _playerMove;
        }
        if ((_randomMove == Move.Rock && _playerMove == Move.Scissors) ||
            (_randomMove == Move.Paper && _playerMove == Move.Rock) ||
            (_randomMove == Move.Scissors && _playerMove == Move.Paper)) {
            return _randomMove;
        }
        return Move(3); // Ничья
    }
    
    function getGameCount() external view returns (uint256) {
        return games.length;
    }
    
    function getGame(uint256 index) external view returns (address, Move, Move, uint256, uint256) {
        require(index < games.length, "Недопустимый индекс.");
        Game memory game = games[index];
        return (game.player, game.playerMove, game.randomMove, game.betAmount, game.rewardAmount);
    }
}
