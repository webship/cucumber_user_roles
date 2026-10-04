Feature: The other roles take their own steps of the workflow
  As a member of the team
  I want the steps of my role on a feature, and the listings of the site
  So that I do my part of the work

  Scenario: A developer changes a feature somebody else wrote, and does not create one
    Given I am a logged in user with the "Developer" user
    When I navigate to "/media/add/feature"
    Then I should see "Access denied"
    When I navigate to "/features?name=Tester%20workflow%20feature"
     And I click "Edit" in the "Tester workflow feature" row
     And I select "In Progress" from "Change to"
     And I press "Save"
    Then I should see "Feature Tester workflow feature has been updated."
    When I navigate to "/features?name=Tester%20workflow%20feature"
    Then I should see "In Progress" in the "Tester workflow feature" row

  Scenario: An analyst writes a feature and keeps it a draft
    Given I am a logged in user with the "Analyst" user
    When I navigate to "/media/add/feature"
     And I fill in "Name" with "Analyst workflow feature"
     And I fill in the Ace editor with:
      """
      Feature: Reset a password
        Scenario: A visitor asks for a new password
          Given I am on "/user/password"
          Then I should see "Reset your password"
      """
     And I press "Save"
    Then I should see "Feature Analyst workflow feature has been created."
    When I navigate to "/features?name=Analyst%20workflow%20feature"
     And I click "Edit" in the "Analyst workflow feature" row
    Then the option "Draft" should exist within the select element "#edit-moderation-state-0-state"
     And the option "In Progress" should not exist within the select element "#edit-moderation-state-0-state"
     And the option "Published" should not exist within the select element "#edit-moderation-state-0-state"

  Scenario: A product owner publishes a feature
    Given I am a logged in user with the "Product Owner" user
    When I navigate to "/features?name=Tester%20workflow%20feature"
     And I click "Edit" in the "Tester workflow feature" row
     And I select "Published" from "Change to"
     And I press "Save"
    Then I should see "Feature Tester workflow feature has been updated."
    When I navigate to "/features?name=Tester%20workflow%20feature"
    Then I should see "Published" in the "Tester workflow feature" row

  Scenario: A tester brings the published feature back to To Do
    Given I am a logged in user with the "Tester" user
    When I navigate to "/features?name=Tester%20workflow%20feature"
     And I click "Edit" in the "Tester workflow feature" row
     And I select "To Do" from "Change to"
     And I press "Save"
    Then I should see "Feature Tester workflow feature has been updated."

  Scenario: A member without a role has the dashboard and the way out
    Given I am a logged in user with the "Authenticated user" user
    Then the path should be "/webdashboard/default_dashboard"
     And I should see "Log out"
    When I navigate to "/features"
    Then I should see "Access denied"
