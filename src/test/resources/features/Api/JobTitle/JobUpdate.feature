@Api
Feature: Update job title with valid data
  Background:
    * url baseApi
    * path endpoints.admin.jobTitles
    * def result = call read('classpath:features/Api/JobTitle/JobGet.feature')
    * def ids = result.jobList[0].id

  Scenario: Update non-image
    Given path ids
    And request
    """
      {
          "title": "This is test",
          "description": null,
          "note": null
      }
    """
    When method put
    Then status 200
    * def response = response.data

  Scenario: Update new image
    * def data = karate.get(data)
    Given path __arg.id
    And request __arg.payload
    When method put
    Then status 200
    * def response = response.data
