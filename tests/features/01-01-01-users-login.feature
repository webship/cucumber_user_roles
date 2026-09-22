Feature: Login for every configured user
  As a site administrator
  I want every user defined in cucumber.js worldParameters.users to be
  able to log in
  So that the suite has known-good fixtures before any role-specific
  scenarios run

  Scenario: Webmaster can log in and provision the rest of the testing users
    Given I am a logged in user with the "Webmaster" user
    Then I should see "Log out"
    When I navigate to "/user"
    Then I should see "webmaster"
    When I add testing users
     And I navigate to "/admin/people"
    Then I should see "tester_user"
     And I should see "authenticated_user"

  Scenario: A user with the Tester role can log in
    Given I am a logged in user with the "Tester" user
    Then I should see "Log out"
    When I navigate to "/user"
    Then I should see "tester_user"

  Scenario: Authenticated user can log in
    Given I am a logged in user with the "Authenticated user" user
    Then I should see "Log out"
    When I navigate to "/user"
    Then I should see "authenticated_user"
