@regression @putJobApi @positive
Feature: Update job title with valid data
  Background:
    * url baseApi
    * path endpoints.admin.jobTitles

    * def deleteIds = []
    * def randomData = Java.type('helpers.RandomData_helper')
    * def titleName = "job " + randomData.randomUUIShort()
    * def result = call read('classpath:features/Api/JobTitle/JobCreate.feature@non-image')
    * def ids = result.response.data.id

    * def payloadRequest = read('classpath:helpers/payloadUpdate_helper.js')
    * def encodeFile = read('classpath:helpers/encodeFile_helper.js')
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
    * def titleName = "job update " + randomData.randomUUIShort()
    * eval deleteIds.push(ids)

    Given path ids
    And request payloadRequest(titleName, <jobDescription>, <note>, null, null)
    When method put

    Then status <status>
    And match response.data.title == titleName
    And match response.data.description == <jobDescription>
    And match response.data.note == <note>
    And match response.data.jobSpecification ==
    """
     {"id":null,"filename":null,"fileType":null,"fileSize":null}
    """

    Examples:
    |id| description | jobDescription| note| status |
    |UD-JOB1| Update successfully without specification file|"description update v2"|"note update v2"|200|
    |UD-JOB2|Update successfully with only title|null|null|200|

  Scenario: UD-JOB3 - Update job title with upload new image
      * eval deleteIds.push(ids)
      * def file = encodeFile('classpath:files/file_test.png')
      * def spec =
      """
      {
        name: "file_test.png",
        type: "image/png",
        size: #(file.bytes.length),
        base64: "#(file.base64)"
      }
      """
      * print 'file bytes length =', file.bytes.length
      * def titleName = "job update " + randomData.randomUUIShort()

      Given path ids
      And request payloadRequest(titleName, "Job test update @123", "Note test update @123", spec, null)
      When method put
      Then status 200
      And match response.data.title == titleName
      And match response.data.description == "Job test update @123"
      And match response.data.note == "Note test update @123"
      And match response.data.jobSpecification.id == '#number'
      And match response.data.jobSpecification.filename == "file_test.png"
      And match response.data.jobSpecification.fileType == "image/png"
      And match response.data.jobSpecification.fileSize == file.bytes.length

  Scenario: UD-JOB4 - Update job title with replace image
    * def titleName = "job " + randomData.randomUUIShort()
    * def result = call read('classpath:features/Api/JobTitle/JobCreate.feature@containImage')
    * def ids = result.response.data.id
    * eval deleteIds.push(ids)
    * def file = encodeFile('classpath:files/file_test2.png')
    * def spec =
    """
      {
        name: "file_test2.png",
        type: "image/png",
        size: #(file.bytes.length),
        base64: "#(file.base64)"
      }
    """
    * def titleName = "job update " + randomData.randomUUIShort()

    Given path ids
    And request payloadRequest(titleName, "Job test update @123","Note test update @123", spec,"replaceCurrent")
    When method put

    Then status 200
    And match response.data.title == titleName
    And match response.data.description == "Job test update @123"
    And match response.data.note == "Note test update @123"
    And match response.data.jobSpecification.id == '#number'
    And match response.data.jobSpecification.filename == "file_test2.png"
    And match response.data.jobSpecification.fileType == "image/png"
    And match response.data.jobSpecification.fileSize == file.bytes.length

  Scenario: UD-JOB5 - Update job title with delete image
    * def titleName = "job " + randomData.randomUUIShort()
    * def result = call read('classpath:features/Api/JobTitle/JobCreate.feature@containImage')
    * def ids = result.response.data.id
    * print 'ids new =', ids
    * def titleName = "job update " + randomData.randomUUIShort()
    Given path ids
    And request payloadRequest(titleName, "Job test update @1234", "Note test update @1234",null, "deleteCurrent")

    When method put
    Then status 200

    * print 'data ID= ', response.data.id
    * eval deleteIds.push(response.data.id)

    And match response.data.title == titleName
    And match response.data.description == "Job test update @1234"
    And match response.data.note == "Note test update @1234"
    And match response.data.jobSpecification ==
    """
     {"id":null,"filename":null,"fileType":null,"fileSize":null}
    """




