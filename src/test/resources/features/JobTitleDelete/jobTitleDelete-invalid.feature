@regression @deleteJobApi @negative
Feature: Delete job title with invalid
Background:
  * url baseApi
  * path endpoints.admin.jobTitles
  @testDelete
  Scenario Outline: <id> - <description>
    * def getId = call read('classpath:features/Api/JobTitle/JobGet.feature')

    Given request { "ids": <ids> }
    When method delete
    Then status <status>
    And response.error.message == <errorMessage>

    Examples:
    |id|description|ids|status|errorMessage|
    |DEL-JOB4|Delete with empty id.|[]|404|"Records Not Found"|
    |DEL-JOB6|Delete with  request are not array|12|500|"Unexpected Error Occurred"|
    |DEL-JOB7|Delete with  ids is String|["abc"]|404|"Records Not Found"|
    |DEL-JOB8|Delete with  ids is exists and other is not|[12,467]|404|"Records Not Found"|
    |DEL-JOB9|Delete with id is negative number|[-1]|404|"Records Not Found"|
    |DEL-JOB10|Delete with large number id|[999999999999]|404|"Records Not Found"|

    Scenario: DEL-JOB5 - Delete with missing ids.
      Given request {}
      When method delete
      Then status 404
      And response.error.message == "Records Not Found"