Feature: Cucumber User Roles and its sub-modules are enabled
  As a site administrator
  I want to verify that Cucumber User Roles and the six role sub-modules
  are installed
  So that every role in the product testing workflow is available

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Cucumber User Roles is listed as enabled
    When I navigate to "/admin/modules"
    Then I should see "Cucumber User Roles"
     And the element "#edit-modules-cucumber-user-roles-enable" with the attribute "checked" and the value "checked" should exist

  Scenario: The six role sub-modules are enabled
    When I navigate to "/admin/modules"
    Then the element "#edit-modules-cucumber-user-role-tester-enable" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-modules-cucumber-user-role-developer-enable" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-modules-cucumber-user-role-analyst-enable" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-modules-cucumber-user-role-coordinator-enable" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-modules-cucumber-user-role-designer-enable" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-modules-cucumber-user-role-product-owner-enable" with the attribute "checked" and the value "checked" should exist
