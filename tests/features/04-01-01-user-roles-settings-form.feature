Feature: The Cucumber User Roles settings form
  As a site administrator
  I want the settings form to list every role from
  src/Assets/user_roles/user_roles.yml as a checkbox
  So that I can pick which roles to install, and keep that selection
  after saving

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: The settings page loads with the title from the user roles asset
    When I navigate to "/admin/config/development/cucumber-user-roles/settings"
    Then "h1.page-title" should have text "User Roles"
     And I should see "Install user roles that have separate permissions based on the role rank"
     And "#edit-user-roles" should be visible
     And "#edit-continue" should be attached

  Scenario: Every role in the user roles asset renders as a checkbox
    When I navigate to "/admin/config/development/cucumber-user-roles/settings"
    Then "#edit-user-roles input[type=checkbox]" should have a count of 7
     And "#edit-tester" should be visible
     And "#edit-developer" should be visible
     And "#edit-analyst" should be visible
     And "#edit-coordinator" should be visible
     And "#edit-designer" should be visible
     And "#edit-product-owner" should be visible
     And "#edit-admin" should be visible

  Scenario: Each role checkbox carries its title and description
    When I navigate to "/admin/config/development/cucumber-user-roles/settings"
    Then I should see "Tester" in the "#edit-user-roles" element
     And I should see "Developer" in the "#edit-user-roles" element
     And I should see "Analyst" in the "#edit-user-roles" element
     And I should see "Coordinator" in the "#edit-user-roles" element
     And I should see "Designer" in the "#edit-user-roles" element
     And I should see "Product Owner" in the "#edit-user-roles" element
     And I should see "Admin" in the "#edit-user-roles" element
     And I should see "Write and perform productive code" in the "#edit-user-roles" element

  Scenario: An already installed role is checked and locked
    When I navigate to "/admin/config/development/cucumber-user-roles/settings"
    Then the "#edit-tester" checkbox should be checked
     And "#edit-tester" should be disabled
     And the "#edit-developer" checkbox should be checked
     And "#edit-developer" should be disabled

  Scenario: Saving the form keeps the installed roles selected
    When I navigate to "/admin/config/development/cucumber-user-roles/settings"
     And I press "Install User Roles" by its "value" attribute
    Then I should see "The configuration options have been saved."
     And "#edit-user-roles input[type=checkbox]" should have a count of 7
     And the "#edit-tester" checkbox should be checked
     And the "#edit-developer" checkbox should be checked
     And the "#edit-analyst" checkbox should be checked
     And the "#edit-coordinator" checkbox should be checked
     And the "#edit-designer" checkbox should be checked
     And the "#edit-product-owner" checkbox should be checked
     And the "#edit-admin" checkbox should be checked
