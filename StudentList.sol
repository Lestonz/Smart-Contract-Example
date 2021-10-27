pragma solidity ^0.8.9;

/**
Example of student List. 
You can use for school pay or follow to student ext..
writer of @lestonz
 */

// Define of students parameters in Student Contract
// Can add more...
contract Student {

    //Address of the caller of the contract. You can customize here
    address public owner;
    // Student Name.
    string public name;
    // Student ID
    uint public id;
    //Student Address
    address public studentAddress;

    //It is used to initialize state variables of a contract.
    //*A constructor can be either public or internal.
    constructor(address _owner, string memory _name, uint _id) payable {
        owner = _owner;
        name = _name;
        id = _id;
        studentAddress = address(this);
    }
}


//Transacting data from Student Contract
contract StudentList {
    //Define list and make it visible.
    Student[] public students;

    //Add student creation function.
    function create(address _owner, string memory _name, uint _id) public {

        //Add student information
        Student student = new Student(_owner, _name, _id);
        //Adding student information to the Student[] (push)
        students.push(student);
    }


    // if students want to send ether we should use this function.
    function createAndSendEther(address _owner, string memory _name, uint _id) public payable {

        ////Add student information and define the ether sending value 
        Student student = (new Student){value: msg.value}(_owner, _name, _id);
        //Adding student information to the Student[] (push)
        students.push(student);
    }


    //Student information get function. Additionally adds balance and return all parameters
    function getStudent(uint _index)
        public
        view
        returns (
            address owner,
            string memory name,
            uint id,
            address studentAddress,
            uint balance
        )
    {   
        //Adds data to index list
        Student student = students[_index];

        //Return the data in the index
        return (student.owner(), student.name(), student.id(), student.studentAddress(), address(student).balance);
    }
}
