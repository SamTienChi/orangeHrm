@api
Feature: Create Job title
Background: create new job
  * url baseApi
  * path endpoints.admin.jobTitles

  Scenario:
    Given request
    """
    {
      "title": "#(titleName)",
      "description": "",
      "specification": null,
      "note": ""
    }
    """
    When method post
    Then status 200
