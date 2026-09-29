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
     And I should see "developer_user"
     And I should see "analyst_user"
     And I should see "product_owner_user"
     And I should see "authenticated_user"

  Scenario: A user with the Tester role can log in, and log out by the link
    Given I am a logged in user with the "Tester" user
    Then I should see "Log out"
     And the path should be "/dashboard/tester_dashboard"
    When I navigate to "/user"
    Then I should see "tester_user"
    When I set the viewport size to 1280x900
     And I follow "Log out"
    Then the path should be "/user/login"

  Scenario: Authenticated user can log in
    Given I am a logged in user with the "Authenticated user" user
    Then I should see "Log out"
    When I navigate to "/user"
    Then I should see "authenticated_user"
