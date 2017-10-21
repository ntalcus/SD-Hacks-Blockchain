pragma solidity ^0.4.11;

contract Competition {
	// Parameters related to the instantiation of the comepetition which will run for a certain amount of time
	// The competition 
	address public host;
	string public competitionName;
	uint public competitionEnd;

	//Current state of competition.
	State status;

	//Bool related to competition status. If competition underway, False, otherwise True;
	bool running;

	//Events that mark certain times.
	event Commenced(address compCreator);
	event CategoryCreated(address catCreator, string catName, uint bond);
	event CategoryClosed(string catName, address winner);
	event Ended(string compName);

	function Competition(string _competitionName, uint _competitionTime) {
	host = msg.sender();
	competitionName = _competitionName;
	competitionEnd = now + _competitionTime;
	}

	
}
