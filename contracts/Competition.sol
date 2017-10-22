pragma solidity ^0.4.11;

contract Competition {
	// Parameters related to the instantiation of the competition which will run for a certain amount of time
	// The competition 

    // various competition variables
	address host;
	string competitionName;
	uint submissionEnd;
	uint competitionEnd;
	Status compStatus;

	// Array that holds category addresses.
	address[] categories;
	

	enum status { created, accepting, voting, ended }

	// //Bool related to competition status. If competition underway, False, otherwise True;
	// bool running;

	// Modifiers that check the status
	modifier checkState(uint state) {
		require(uint(compStatus) == state);
		_;
	}

	// Events that mark certain times.
	event Commenced(address compCreator);
	event CategoryCreated(address catCreator, string catName, uint bond);

	// initiate a competition
	function Competition
	(address creator, string _competitionName, uint _submissionEnd, uint _competitionTime) 
	{
	if (submissionEnd > competitionEnd) {
		throw;
	}
	host = creator;
	competitionName = _competitionName;
	submissionEnd = now + _submissionEnd;
	competitionEnd = now + _competitionTime;
	Commenced(creator);
	return this;
	}

	// it's called during the submission phase
	function createCategory
	(address catOwner, string catName, uint bond, uint reward) 
		checkState(1)
	{
		if (bond < 0 || catName.length == 0 || reward > msg.value() || 0 <= weight || 100 >= weight) {
			throw;
		}
		_catAddress = Category.Categories(submissionEnd, bond, reward, catOwner, weight, competitionEnd);
		categories.push(_catAddress);
		CategoryCreated(catOwner, catName, bond, reward);
	}
	
	function submissionEnd() 
	checkState(1)
	{
		require(now >= submissionEnd);
		this.compStatus = status.voting;
		
	}
}