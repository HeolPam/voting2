// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {

    enum VoterType { Donor, Hospital }

    mapping(address => uint) private donorVotes;
    mapping(address => uint) private donorWeights;

    mapping(address => uint) private hospitalVotes;
    mapping(address => uint) private hospitalWeights;

    address[] private donorAddresses;
    address[] private hospitalAddresses;

    mapping(address => bool) private hasVoted;

    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "Address has already voted");
        _;
    }

    modifier validWeight(uint weight) {
        require(weight >= 0 && weight <= 100, "Weight must be between 0 and 100");
        _;
    }

    function voteAsDonor(uint incentiveValue, uint weight) external hasNotVoted validWeight(weight) {
        donorVotes[msg.sender] = incentiveValue;
        donorWeights[msg.sender] = weight;
        donorAddresses.push(msg.sender);
        hasVoted[msg.sender] = true;
    }

    function voteAsHospital(uint incentiveValue, uint weight) external hasNotVoted validWeight(weight) {
        hospitalVotes[msg.sender] = incentiveValue;
        hospitalWeights[msg.sender] = weight;
        hospitalAddresses.push(msg.sender);
        hasVoted[msg.sender] = true;
    }

    function getWeightedMean() public view returns (uint donorWeightedMean, uint hospitalWeightedMean, uint overallWeightedMean) {
        uint donorWeightedTotal = 0;
        uint hospitalWeightedTotal = 0;

        uint totalDonorWeight = 0;
        uint totalHospitalWeight = 0;

        //  to calculate weighted total for donors
        for(uint i = 0; i < donorAddresses.length; i++) {
            address donorAddr = donorAddresses[i];
            donorWeightedTotal += donorVotes[donorAddr] * donorWeights[donorAddr];
            totalDonorWeight += donorWeights[donorAddr];
        }

        // to  calculate weighted total for hospitals
        for(uint j = 0; j < hospitalAddresses.length; j++) {
            address hospitalAddr = hospitalAddresses[j];
            hospitalWeightedTotal += hospitalVotes[hospitalAddr] * hospitalWeights[hospitalAddr];
            totalHospitalWeight += hospitalWeights[hospitalAddr];
        }

        donorWeightedMean = (totalDonorWeight == 0) ? 0 : donorWeightedTotal / totalDonorWeight;
        hospitalWeightedMean = (totalHospitalWeight == 0) ? 0 : hospitalWeightedTotal / totalHospitalWeight;

        // to calculate overall weighted mean
        uint totalWeightedValues = donorWeightedTotal + hospitalWeightedTotal;
        uint totalWeights = totalDonorWeight + totalHospitalWeight;
        overallWeightedMean = (totalWeights == 0) ? 0 : totalWeightedValues / totalWeights;

        return (donorWeightedMean, hospitalWeightedMean, overallWeightedMean);
    }
// average of donor's incentive value
    function getAverageDonorIncentive() public view returns (uint) {
        uint totalIncentive = 0;
        for(uint i = 0; i < donorAddresses.length; i++) {
            totalIncentive += donorVotes[donorAddresses[i]];
        }
        return donorAddresses.length == 0 ? 0 : totalIncentive / donorAddresses.length;
    }
// average of donor's incentive value's weight
    function getAverageDonorWeight() public view returns (uint) {
        uint totalWeight = 0;
        for(uint i = 0; i < donorAddresses.length; i++) {
            totalWeight += donorWeights[donorAddresses[i]];
        }
        return donorAddresses.length == 0 ? 0 : totalWeight / donorAddresses.length;
    }
// hospital incentive value avg
    function getAverageHospitalIncentive() public view returns (uint) {
        uint totalIncentive = 0;
        for(uint i = 0; i < hospitalAddresses.length; i++) {
            totalIncentive += hospitalVotes[hospitalAddresses[i]];
        }
        return hospitalAddresses.length == 0 ? 0 : totalIncentive / hospitalAddresses.length;
    }
// hospital avg incentive value's weight
    function getAverageHospitalWeight() public view returns (uint) {
        uint totalWeight = 0;
        for(uint i = 0; i < hospitalAddresses.length; i++) {
            totalWeight += hospitalWeights[hospitalAddresses[i]];
        }
        return hospitalAddresses.length == 0 ? 0 : totalWeight / hospitalAddresses.length;
    }
// total avg weights of donor + hospital
    function getTotalAverageWeight() public view returns (uint) {
        uint totalWeight = 0;
        for(uint i = 0; i < donorAddresses.length; i++) {
            totalWeight += donorWeights[donorAddresses[i]];
        }
        for(uint i = 0; i < hospitalAddresses.length; i++) {
            totalWeight += hospitalWeights[hospitalAddresses[i]];
        }
                uint totalCount = donorAddresses.length + hospitalAddresses.length;
        return totalCount == 0 ? 0 : totalWeight / totalCount;
    }

    /*function getTotalWeightedIncentive() public view returns (uint) {
        uint donorWeightedTotal = 0;
        uint hospitalWeightedTotal = 0;
        for(uint i = 0; i < donorAddresses.length; i++) {
            donorWeightedTotal += donorVotes[donorAddresses[i]] * donorWeights[donorAddresses[i]];
        }
        for(uint i = 0; i < hospitalAddresses.length; i++) {
            hospitalWeightedTotal += hospitalVotes[hospitalAddresses[i]] * hospitalWeights[hospitalAddresses[i]];
        }
        return donorWeightedTotal + hospitalWeightedTotal;
    }*/
// totoal no of votes donor + hospital
    function getVoterCounts() public view returns (uint donorCount, uint hospitalCount) {
        return (donorAddresses.length, hospitalAddresses.length);
    }
}

