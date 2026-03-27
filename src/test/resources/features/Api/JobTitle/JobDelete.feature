@Api
Feature: Delete the job title
Background:
  * url baseApi
  * path endpoints.admin.jobTitles

  Scenario:
    * print 'ids =' , ids
    Given request
    """
      {
        "ids": #(ids)
      }
    """
    When method delete
    Then status 200

