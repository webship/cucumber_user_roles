Feature: Every role holds the steps of the workflow that fit its work
  As a site administrator
  I want each role to write Gherkin scripts and to take its own steps of the automated testing workflow
  So that every member of the team can do the work of the role, and no more

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario Outline: The "<role>" role may write a Gherkin script
    When I navigate to "/admin/people/permissions/<id>"
    Then the element "#edit-<css>-use-text-format-gherkin" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-<css>-view-the-administration-theme" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-<css>-access-media-directories-ui-browser" with the attribute "checked" and the value "checked" should exist
     And the "#edit-<css>-administer-media" checkbox should not be checked
     And the "#edit-<css>-administer-workflows" checkbox should not be checked

    Examples:
      | role          | id            | css           |
      | Tester        | tester        | tester        |
      | Developer     | developer     | developer     |
      | Analyst       | analyst       | analyst       |
      | Designer      | designer      | designer      |
      | Coordinator   | coordinator   | coordinator   |
      | Product Owner | product_owner | product-owner |

  Scenario: The Tester role moves a feature up to Implemented, and does not publish
    When I navigate to "/admin/people/permissions/tester"
    Then the element "#edit-tester-use-automated-testing-transition-back-to-draft" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-tester-use-automated-testing-transition-create-new-task" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-tester-use-automated-testing-transition-to-do" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-tester-use-automated-testing-transition-in-progress" with the attribute "checked" and the value "checked" should exist
     And the "#edit-tester-use-automated-testing-transition-implemented" checkbox should not be checked

  Scenario: The Developer role moves a feature to In Progress and to Implemented
    When I navigate to "/admin/people/permissions/developer"
    Then the element "#edit-developer-use-automated-testing-transition-create-new-task" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-developer-use-automated-testing-transition-to-do" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-developer-use-automated-testing-transition-in-progress" with the attribute "checked" and the value "checked" should exist
     And the "#edit-developer-use-automated-testing-transition-implemented" checkbox should not be checked
     And the "#edit-developer-use-automated-testing-transition-back-to-draft" checkbox should not be checked

  Scenario Outline: The "<role>" role moves its features between Draft and To Do
    When I navigate to "/admin/people/permissions/<id>"
    Then the element "#edit-<id>-create-feature-media" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-<id>-edit-own-feature-media" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-<id>-use-automated-testing-transition-back-to-draft" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-<id>-use-automated-testing-transition-create-new-task" with the attribute "checked" and the value "checked" should exist
     And the "#edit-<id>-use-automated-testing-transition-to-do" checkbox should not be checked
     And the "#edit-<id>-edit-any-feature-media" checkbox should not be checked

    Examples:
      | role     | id       |
      | Analyst  | analyst  |
      | Designer | designer |

  Scenario Outline: The "<role>" role takes every step of the workflow
    When I navigate to "/admin/people/permissions/<id>"
    Then the element "#edit-<css>-use-automated-testing-transition-back-to-draft" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-<css>-use-automated-testing-transition-create-new-task" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-<css>-use-automated-testing-transition-to-do" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-<css>-use-automated-testing-transition-in-progress" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-<css>-use-automated-testing-transition-implemented" with the attribute "checked" and the value "checked" should exist
     And the element "#edit-<css>-view-any-unpublished-content" with the attribute "checked" and the value "checked" should exist

    Examples:
      | role          | id            | css           |
      | Coordinator   | coordinator   | coordinator   |
      | Product Owner | product_owner | product-owner |
