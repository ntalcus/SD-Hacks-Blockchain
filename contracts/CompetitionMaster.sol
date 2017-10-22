pragma solidity ^0.4.11;

contract CompetitionMaster {

	// Mapping of all competitions to access specific aspects of struct
	mapping(string => address) competitionMap;

    function createCompetition(string _competitionName, uint _submissionEnd, uint _competitionTime) 
    {
        address _competition = new Competition(msg.sender, _competitionName, _submissionEnd, _competitionTime);
        competitionMap[_competitionName] = address;
    }

    function retrieveAddress(string name) returns (address) {
        return competitionMap[name];
    }

}