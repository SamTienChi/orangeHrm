@regression @putJobApi @negative @update
Feature: Update job title with valid invalid data
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
    And request payloadRequest(titleName, <jobDescription>, <note>, null, <currentJobSpecification>)
    When method put
    Then status <status>
    Then match response.error.message == <errorMessage>
    * print 'response error data= ', response.error.data
    * assert response.error.data != null ? response.error.data.invalidParamKeys == <invalidKey> : true

    Examples:
      |id| description | jobDescription| note| currentJobSpecification | status | errorMessage | invalidKey |
      |UD-JOB6|Update Invalid Jobspecification without image |"description update v2"|"invalidCurrent"|"note update v2"|422|"Invalid Parameter"|"currentJobSpecification"|
      |UD-JOB7|Update successfully with only title|null|null|"keepCurrent"|400|"`currentJobSpecification` should not define if there is no job specification"|null|
      |UD-JOB8|Update successfully with only title|null|null|"deleteCurrent"|400|"`currentJobSpecification` should not define if there is no job specification"|null|
      |UD-JOB9|Update successfully with only title|null|null|"replaceCurrent"|422|"Invalid Parameter"|"specification"|