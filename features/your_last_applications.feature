Feature: Processed applications

  Background: Processed applications page
    Given I successfully sign in as a user
    And I start to process a new paper application
    And I fill in personal details of the application
    And I fill in the application details
    And I abandon the application

    Scenario: Open my last application
      Then I should see that partially processed application under your last applications

    Scenario: Opening my last application
      When I open my last application
      Then I should see the personal details populated with information
      And I should see the application details populated with information
