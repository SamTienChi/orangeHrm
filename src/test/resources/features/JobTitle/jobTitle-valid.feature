@regression @getJobApi @positive

Feature: Get list job with happy case
Background:
  * url baseApi
  * path endpoints.admin.jobTitles
  * def jobTitleSchema = read('classpath:schema/JobTitle_schema.json')

  Scenario: T1 - Check cookies header
    When method get
    Then status 200

  @setup
  Scenario: Prepare data
  * def validDataJson = read('classpath:features/jobTitle/jobTitleValid.json')

  Scenario Outline: <id> - <description>
    Given params <params>

    When method get
    Then status <status>
    And match response.data contains jobTitleSchema.data
    And match response.meta.total == '#number'
    And match response.data == '#[]'
    And assert expectedSize == null || (response.data.length) <= (expectedSize)
    Examples:
    | karate.setup().validDataJson |

  Scenario: TC7 - Handle very large offset value
    And param limit = 10
    And param offset = 99999999999999
    And param sortField = 'jt.jobTitleName'
    And param sortOrder = 'ASC'
    When method get
    Then status 200
    And match response.data == []

  Scenario: TC8 - Return data with sort in descending order
    And param limit = 5
    And param offset = 2
    And param sortField = 'jt.jobTitleName'
    And param sortOrder = 'DESC'
    When method get
    Then status 200
    * def isSortedDesc =
    """
    function(arr){
      for (var i = 0; i < arr.length - 1; i++) {
        if (arr[i].title < arr[i+1].title) return false;
      }
      return true;
    }
    """
    And assert isSortedDesc(response.data)
