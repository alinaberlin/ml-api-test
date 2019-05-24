Feature: ML Api
  As a ml api manager I would like to have tests

  Scenario: Check health end point
    Given We have a password
    When I ping the api
    Then I should receive succeful response

  Scenario: Get a room by reference 
    Given We have a password
    When I search for a room with DE-01-001-01
    Then I receive the room object with DE-01-001-01

  Scenario: Room not found 
    Given We have a password
    When I search for a room with NOTKNOWN
    Then I receive a response with status 404

  Scenario: Get all free rooms
    Given We have a password
    When I search for all free rooms
    Then I receive an array with rooms

  Scenario Outline: Get all free room in city
    Given We have a password
    When I search for free rooms in <city> 
    Then I receive an array with <nr> rooms 
  Examples: 
    |city    |nr |
    |berlin  |10 |
    |hamburg |0  |

Scenario Outline: Get all room in city
    Given We have a password
    When I search for rooms between <min> and <max> in <city>
    Then I receive an array with <nr> rooms 
  Examples: 
    |city    |nr |min |max |
    |berlin  |8  |300 |500 |
    

Scenario Outline: Get all room in city
    Given We have a password
    When  I search for sorted rooms with <sortBy> and <type> and <limit> in <city>
    Then  I receive an array with <nr> rooms
  Examples:
    |city    |nr |sortBy |type |limit |
    |berlin  |5  |price  |asc  |5     |
    |berlin  |2  |size   |desc |2     |