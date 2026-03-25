@regression @putJobApi @positive
Feature: Update job title with valid data
  Background:
    * url baseApi
    * path endpoints.admin.jobTitles
    * def result = call read('classpath:features/Api/JobTitle/JobGet.feature')
    * def ids = result.jobList[0].id

  Scenario:
    Given path ids
    And request
    """
      {
          "title": "This is test",
          "description": null,
          "note": null,
          "currentJobSpecification": "keepCurrent"
      }
    """
    When method put
    Then status 200