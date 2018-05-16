pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    uint levelUpFee = 0.001 ether;

    //函数修饰符：超过某个等级才能运行
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    function withdraw() external onlyOwner {
        // msg.sender.transfer(msg.value - levelUpFee);
        owner.transfer(this.balance);
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function levelUp(uint _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }

    function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) {
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) {
        zombies[_zombieId].dna = _newDna;
    }

    //只需要读取的函数声明view, 如果从外部调用不需要支付gas
    function getZombiesByOwner(address _owner) external view returns(uint[]) {
        //内存中创建临时数组
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        //相当于从数据里遍历数据看看哪一项等于 owner 的address？
        for(uint i = 0; i < zombies.length; i++){
            if(zombieToOwner[i] == _owner){
                result[counter] = i; //i相当于zombie的ID
                counter++;
            }
        }
        return result;
    }
}
