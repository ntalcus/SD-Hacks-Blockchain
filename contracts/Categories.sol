pragma solidity ^0.4.11;

/// @title A particular categeory for a hackthon with a submission mechanism.
contract Categories {
    uint _bondAmount;
    uint _rewardAmount;
    uint _endTime;
    address _creator;
    bool isVotingTime;
    string creatorChoice;
    string[] subNameList;
    mapping(address => uint) winners;
    uint finalEndTime;

    struct Submission {
        bytes32 IPFShash; //hash of IPFS hash
        string submissionName; //body of work representing the submission (do this off the chain)
        string[] references; //references of all other work used in submissions creation
        address[] contributors; //all contributors of submission including sender (assume sender didn't input themselves)
        address[] retrieved; //list of all contributors who withdrew their bounty and/or bond amount
        uint upVotes; //amount of upvotes
        uint downVotes; //amount of downVotes
        mapping(address => bool) voted; // mapping of addresses who already voted (up or down) for this submission
    }

    mapping(string => Submission) public submissionList; // holds all submissions for this category

    modifier checkBondPaid () {
        require (msg.value >= _bondAmount);
        _;
        if (msg.value > _bondAmount) {
            uint refund = msg.value - _bondAmount;
            msg.sender.transfer(refund);
        }
    }

    /** Category constructor*/
    function Categories(uint endTime, uint bondAmount, uint rewardAmount, address creator, uint finalEndTime) public {
        _bondAmount = bondAmount;
        _rewardAmount = rewardAmount;
        _endTime = endTime;
        _creator = creator;
        _finalEndTime = finalEndTime;
        isVotingTime = false; //voting period is not open yet
    }

    function Submit(bytes32 IPFShash, string submissionName, string[] references, address[] contributors) public checkBondPaid() {
        timeToVote();
        if (!isVotingTime) {
            submissionList[submissionName].IPFShash = IPFShash;
            submissionList[submissionName].submissionName = submissionName;
            submissionList[submissionName].references = references;
            submissionList[submissionName].contributors.push(msg.sender);
            submissionList[submissionName].contributors = contributors;

            submissionList[submissionName].upVotes = 0;
            submissionList[submissionName].downVotes = 0;

            // mapping(address => bool) public votedList; 
            // submissionList[submissionName].voted = votedList; // who voted tracker
            subNameList.push(submissionName);

        }
    }

    /** Opens the voting period; submission period is over. */
    function timeToVote() private {
        if (block.timestamp >= _endTime) { //checks if current time is past the end time of the competition
            isVotingTime = true;
        }
    }

    function Vote(string subName, uint vote) public {
        require(vote == 0 || vote == 1);
        timeToVote();
        require(isVotingTime);
        if (msg.sender == _creator) {
            creatorChoice = subName;
            submissionList[subName].upVotes += subNameList.length;
        } else {
            if (!submissionList[subName].voted[msg.sender]) {
                submissionList[subName].voted[msg.sender] = true;
                if (vote == 0) {
                    submissionList[subName].downVotes += 1;
                } else {
                    submissionList[subName].upVotes += 1;
                }

            } 
        }
    }

    function Round() public returns (string winnerSubName) {
        //voting is not allowed now (do the boolean thang)
        //call superScore??, calculate popular vote, return total score and winner
        //draw??
        require(finalEndTime < now);
        isVotingTime = false; //prevents others from voting; voting period is closed
        string subWinner;
        uint trackMaxScore = 0;
        for (uint i = 0; i < subNameList.length; i++) {
            string storage tempSub = subNameList[i];
            uint ups = submissionList[tempSub].upVotes;
            uint downs = submissionList[tempSub].downVotes;
            uint net = ups - downs;
            if (net > trackMaxScore) {
                trackMaxScore = net;
                subWinner = tempSub;
            } else if (net == trackMaxScore) { //tiebreaker
                if (submissionList[subWinner].upVotes < submissionList[tempSub].upVotes) {
                    trackMaxScore = net;
                    subWinner = tempSub;
                }
            }
        }

        uint winnersAmount = submissionList[subWinner].contributors.length;

        for (uint i = 0; i < winnersAmount; i++) {
            winners[submissionList[subWinner].contributors[i]] = _rewardAmount/winnersAmount;
        }

        return subWinner;
    
    }

    function withdraw() public {
        //withdraws bounty + winnings (if applicable) AND updates retrieved list for each submission
        uint val = winners[msg.sender];
        winners[msg.sender] -= val;
        msg.sender.transfer(val);

    }
}