Feature: A tester writes a feature and moves it through the workflow
  As a tester
  I want to write a feature with its Gherkin script and move it up to Implemented
  So that the team sees what I am testing

  Background:
    Given I am a logged in user with the "Tester" user

  Scenario: A tester writes a feature with a Gherkin script
    When I navigate to "/media/add/feature"
    Then I should not see "you do not have sufficient permissions"
    When I fill in "Name" with "Tester workflow feature"
     And I fill in the Ace editor with:
      """
      Feature: Sign in
        Scenario: A visitor opens the log in page
          Given I am on "/user/login"
          Then I should see "Log in"
      """
     And I press "Save"
    Then I should see "Feature Tester workflow feature has been created."
     And I should not see "You do not have access to transition"
     And I should not see "Access denied"
    When I navigate to "/features?name=Tester%20workflow%20feature"
    Then I should see "To Do" in the "Tester workflow feature" row

  Scenario Outline: A tester moves the feature to "<state>"
    When I navigate to "/features?name=Tester%20workflow%20feature"
     And I click "Edit" in the "Tester workflow feature" row
     And I select "<state>" from "Change to"
     And I press "Save"
    Then I should see "Feature Tester workflow feature has been updated."
    When I navigate to "/features?name=Tester%20workflow%20feature"
    Then I should see "<state>" in the "Tester workflow feature" row

    Examples:
      | state       |
      | In Progress |
      | Implemented |
      | To Do       |

  Scenario: Publishing a feature is not a step of a tester
    When I navigate to "/features?name=Tester%20workflow%20feature"
     And I click "Edit" in the "Tester workflow feature" row
    Then the option "Draft" should exist within the select element "#edit-moderation-state-0-state"
     And the option "In Progress" should exist within the select element "#edit-moderation-state-0-state"
     And the option "Published" should not exist within the select element "#edit-moderation-state-0-state"
