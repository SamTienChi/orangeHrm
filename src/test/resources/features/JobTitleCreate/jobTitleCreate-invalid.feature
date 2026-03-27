@regression @postJobApi @negative

Feature: Create a new job title with invalid data
Background:
  * url baseApi
  * path endpoints.admin.jobTitles

  Scenario Outline: <id> - <description>
    Given request
    """
    {
      "title": <title>,
      "description": <jobDescription>,
      "note": <note>,
      "specification": null
    }
    """
    When method post
    Then status <status>
    And match response.error.message == <errorMessage>
    And match response.error.data.invalidParamKeys[0] == <invalidKey>

    Examples:
      |id| description |title | jobDescription | note | status |  errorMessage | invalidKey |
      |CR-JOB4|Create job title with empty title|' '|'description123'|'note 123'|422| 'Invalid Parameter'| 'title'|
      |CR-JOB5|Create job title without title|null|'description123'|'note 123'|422|'Invalid Parameter'| 'title'|

  Scenario:CR-JOB6 - Validate title max length
    * def longTitle = 'a'.repeat(101)

    Given request
    """
    {
      title: "#(longTitle)",
      description: "description123",
      jobSpecification: null,
      note: "note 123"
    }
    """
    When method post
    Then status 422
    And match response.error.message == 'Invalid Parameter'
    And match response.error.data.invalidParamKeys contains 'title'

  Scenario:CR-JOB8 - Create job title with duplicate title
    * def randomData = Java.type('helpers.RandomData_helper')
    * def titleName = "job " + randomData.randomUUIShort()
    * call read('classpath:features/Api/JobTitle/JobCreate.feature'@non-image){ title: #(titleName) }

    Given request
    """
    {
      title: "#(titleName)",
      description: "description123",
      jobSpecification: null,
      note: "note 123"
    }
    """
    When method post
    Then status 422
    And match response.error.message == 'Invalid Parameter'
    And match response.error.data.invalidParamKeys contains 'title'

  Scenario: CR-JOB9 - Create job title with Upload unsupported file type
    * def fileBytes = read('classpath:files/1mb.pdf')
    * def Base64 = Java.type('java.util.Base64')
    * def base64File = Base64.getEncoder().encodeToString(fileBytes)

    Given request
    """
    {
      title: "test file",
      "description": "",
      "specification": {
        "name": "file_test.pdf",
        "type": "application/pdf",
        "size": #(fileBytes.length),
        "base64": "#(base64File)"
      },
      "note": ""
    }
    """
    When method post
    Then status 422
    And match response.error.data.invalidParamKeys contains "specification"

  @ignore
  Scenario: CR-JOB10 - Create job title with Upload empty file
    * def emptyBytes = []
    * def Base64 = Java.type('java.util.Base64')
    * def base64File = Base64.getEncoder().encodeToString(emptyBytes)

    Given request
    """
    {
      title: "test file",
      "description": "",
      "specification": {
        "name": "emptyBytes.png",
        "type": "image/png",
        "size": 0,
        "base64": "#(base64File)"
      },
      "note": ""
    }
    """
    When method post
    Then status 422
    And match response.error.data.invalidParamKeys contains "specification"

  @test
  Scenario: CR-JOB11 - Create job title with Upload large file size
    * def fileBytes = read('classpath:files/2mb.png')
    * def Base64 = Java.type('java.util.Base64')
    * def base64File = Base64.getEncoder().encodeToString(fileBytes)

    Given request
    """
    {
      title: "test file",
      "description": "",
      "specification": {
        "name": "file_test.pdf",
        "type": "application/pdf",
        "size": #(fileBytes.length),
        "base64": "#(base64File)"
      },
      "note": ""
    }
    """
    When method post
    Then status 422
    And match response.error.data.invalidParamKeys contains "specification"

  Scenario Outline: <id> - <description>
    * configure cookies = false
    * configure headers = {}
    * header Cookie = <cookie>
    * def randomData = Java.type('helpers.RandomData_helper')
    * def titleName = "job " + randomData.randomUUIShort()
    Given request
    """
      {
        title: "#(titleName)",
        description: "description123",
        jobSpecification: null,
        note: "note 123"
      }
    """
    When method post
    Then status <status>
    And match response.error.message == <errorMessage>
    Examples:
      |id | description | cookie | status | errorMessage |
      |CR-JOB12| Create job title without cookie | null | 401 | 'Session expired' |
      |CR-JOB13| ACreate job title with invalid cookie |  'orangehrm=invalidcookies'  | 401 | 'Session expired' |





