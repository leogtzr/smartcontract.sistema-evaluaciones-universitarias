// SPDX-License-Identifier: Apache-2.0
// Copyright 2025 Leonardo Gutiérrez Ramírez (leogutierrezramirez@gmail.com)
pragma solidity ^0.8.8;
pragma experimental ABIEncoderV2;

/*
| Alumno        |   ID   |  NOTA  |
| Marcos        | 879778 |    5   |
| Joan.         | 839421 |    9   |
| Perla         | 273778 |   10   |
| Leonardo      | 124575 |   10   |
Etc....
*/

contract NotasEscolares {
    // Teacher address, it will be the person who deploys the contract.
    address public professor;

    // Maps the identity hash of the student to the note of the exam.
    mapping (bytes32 => uint) notes;

    // The students can ask for a revision to its notes.
    string[] public studentsAskingReviews;

    event StudentEvaluated(bytes32, uint);
    event studentAskingARevision(string);

    constructor() {
        professor = msg.sender;
    }

    modifier onlyProfessor(address addrr) {
        require(addrr == professor, "Not authorized");
        _;
    }

    function evaluate(string memory _idStudent, uint _note) public onlyProfessor(msg.sender) {
        bytes32 hashStudent = keccak256(abi.encodePacked(_idStudent));
        notes[hashStudent] = _note;
        emit StudentEvaluated(hashStudent, _note);
    }

    function viewNotes(string memory _idStudent) public view returns (uint) {
        bytes32 hashStudent = keccak256(abi.encodePacked(_idStudent));

        return notes[hashStudent];
    }

    function askRevision(string memory _idStudent) public {
        studentsAskingReviews.push(_idStudent);
        emit studentAskingARevision(_idStudent);
    }

    function viewRevisionsAsked() public view onlyProfessor(msg.sender) returns (string[] memory) {
        return studentsAskingReviews;
    }

}
