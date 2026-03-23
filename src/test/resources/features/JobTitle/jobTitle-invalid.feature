@regression @getJobApi @negative

Feature: Get list job with happy case
  Background:
    * url baseApi
    * path endpoints.admin.jobTitles
    * def jobTitleSchema = read('classpath:schema/JobTitle_schema.json')

  Scenario Outline: <id> - <description>
    * configure cookies = false
    * configure headers = {}
    * header Cookie = <cookie>
    When method get
    Then status <status>
    And match response.error.message == <errorMessage>
    Examples:
    |id | description | cookie | status | errorMessage |
    |TC9| API when access without cookie | null | 401 | 'Session expired' |
    |TC10| API when access with invalid cookie |  'orangehrm=invalidcookies'  | 401 | 'Session expired' |

  Scenario Outline: <id> - <description>
    And param limit = <limit>
    And param offset = <offset>
    And param sortField = <sortField>
    And param sortOrder = <sortOrder>
    When method get
    Then status <status>
    And match response.error.message == <errorMessage>
    And match response.error.data.invalidParamKeys[0] == <invalidKey>

    Examples:
      |id | description | limit | offset | sortField | sortOrder | status | errorMessage | invalidKey |
      |TC11|API when limits less than 0 | -1 | 0 | 'jt.jobTitleName' | 'ASC' | 422 | 'Invalid Parameter'  | 'limit'|
      |TC12|API when limits is String| 'abc' | 0 | 'jt.jobTitleName' | 'ASC' | 422 | 'Invalid Parameter'  |'limit'|
      |TC13|API when limits is Null  | '' | 0 | 'jt.jobTitleName' | 'ASC' | 422 | 'Invalid Parameter'  |'limit'|
      |TC14|API when offset less than 0 | 5 | -1 | 'jt.jobTitleName' | 'ASC' | 422 | 'Invalid Parameter'  |'offset'|
      |TC15|API when offset is String| 5 | "abcd"| 'jt.jobTitleName' | 'ASC' | 422 | 'Invalid Parameter'  |'offset'|
      |TC16|API when offset is Null  | 5 | '' | 'jt.jobTitleName' | 'ASC' | 422 | 'Invalid Parameter'  |'offset'|
      |TC17|API when Invalid sort Field| 5 | 0 | 'un.unknow' | 'ASC' | 422 | 'Invalid Parameter'  |'sortField'|
      |TC18| API when sort Field is Null | 5 | 0 | ' ' | 'ASC' | 422 | 'Invalid Parameter'  |'sortField'|
      |TC19| API when sort Order is Invalid | 5 | 0 | 'jt.jobTitleName' | 'Unknow' | 422 | 'Invalid Parameter'  |'sortOrder'|


