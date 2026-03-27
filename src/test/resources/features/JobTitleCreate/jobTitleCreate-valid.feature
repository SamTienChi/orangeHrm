@regression @postJobApi @positive

Feature: Create a new job title
  Background:
    * url baseApi
    * path endpoints.admin.jobTitles
    * def deleteIds = []
    * configure afterScenario =
    """
    function(){
      if (deleteIds.length > 0) {
        karate.call('classpath:features/Api/JobTitle/JobDelete.feature', { ids: deleteIds });
        deleteIds.length = 0;
      }
    }
    """

  Scenario Outline: <id> - <description>
    * def randomData = Java.type('helpers.RandomData_helper')
    * def titleName = "job " + randomData.randomUUIShort()
    Given request
    """
    {
      "title": "#(titleName)",
      "description": <jobDescription>,
      "note": <note>,
      "specification": null
    }
    """
    When method post
    Then status <status>

    And match response.data.id == '#number'
    And match response.data.title == titleName
    And match response.data.description == <jobDescription>
    And match response.data.note == <note>
    And match response.data.jobSpecification ==
    """
    {
      "id": null,
      "filename": null,
      "fileType": null,
      "fileSize": null
    }
    """
    * eval deleteIds.push(response.data.id)


    Examples:
      |id| description |jobDescription | note | status |
      |CR-JOB1|Create job title successfully without specification file|'description123'|'note 123'|200|
      |CR-JOB3|Create job title successfully with only title|null|null|200|

  Scenario: CR-JOB2 - Create job title with specification file
    * def randomData = Java.type('helpers.RandomData_helper')
    * def titleName = "job " + randomData.randomUUIShort()
    * def fileBytes = read('classpath:files/file_test.png')
    * def Base64 = Java.type('java.util.Base64')
    * def base64File = Base64.getEncoder().encodeToString(fileBytes)
    Given request
    """
    {
      "title": "#(titleName)",
      "description": "",
      "specification": {
        "name": "file_test.png",
        "type": "image/png",
        "size": #(fileBytes.length),
        "base64": "#(base64File)"
      },
      "note": ""
    }
    """
    When method post
    Then status 200
    And match response.data.title == titleName
    And match response.data.jobSpecification.id == '#number'
    And match response.data.jobSpecification.filename == "file_test.png"
    And match response.data.jobSpecification.fileType == "image/png"
    And match response.data.jobSpecification.fileSize == fileBytes.length

    * eval deleteIds.push(response.data.id)


