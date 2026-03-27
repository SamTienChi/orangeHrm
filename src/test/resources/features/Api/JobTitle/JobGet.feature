@Api
Feature: Get list of job title
  Background:
    * url baseApi
    * path endpoints.admin.jobTitles
  Scenario:
    When method get
    Then status 200
    * def jobList = response.data
    * assert jobList.length > 0
