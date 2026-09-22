Feature: The six user roles are created with their permissions
  As a site administrator
  I want each installed sub-module to create its role with the right
  permissions and dashboard
  So that staff members get exactly the access their job needs

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: All six roles are listed
    When I navigate to "/admin/people/roles"
    Then I should see "Tester"
     And I should see "Developer"
     And I should see "Analyst"
     And I should see "Coordinator"
     And I should see "Designer"
     And I should see "Product Owner"

  Scenario: The Tester role may create and edit features on its dashboard
    When I navigate to "/admin/people/permissions/tester"
    Then the element "#edit-tester-access-content" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-tester-can-view-tester-dashboard-dashboard" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-tester-create-feature-media" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-tester-edit-any-feature-media" with the attribute "checked" and the value "checked" should exist

  Scenario: The Developer role may view its own dashboard but not create features
    When I navigate to "/admin/people/permissions/developer"
    Then the element "#edit-developer-access-content" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-developer-can-view-developer-dashboard-dashboard" with the attribute "checked" and the value "checked" should exist
     And the "#edit-developer-create-feature-media" checkbox should not be checked

  Scenario: Every role has its own dashboard
    When I navigate to "/admin/structure/dashboards"
    Then I should see "Tester Dashboard"
     And I should see "Developer Dashboard"
     And I should see "Analyst Dashboard"
     And I should see "Coordinator Dashboard"
     And I should see "Designer Dashboard"
     And I should see "Product Owner Dashboard"
