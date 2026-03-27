@regression @deleteJobApi @positive
Feature: Delete job title with valid data
Background:
  * url baseApi
  * path endpoints.admin.jobTitles
  * def randomData = Java.type('helpers.RandomData_helper')

  Scenario: DEL-JOB1 - Delete job title successfully
    * def titleName = "job " + randomData.randomUUIShort()
    * def result = call read('classpath:features/Api/JobTitle/JobCreate.feature')
    * def ids = [#(result.data.id)]

    Given request { ids: #(ids) }
    When method delete
    Then status 200

    * def idString = []
    * karate.forEach(ids, function(x){ idString.push(x + '') })
    * print 'idString =', idString

    And match response.data == idString
    And match response.meta == []
    And match response.rels == []

  Scenario: DEL-JOB2 - Delete multiple job title successfully
    * def titleName = "job " + randomData.randomUUIShort()
    * def result = call read('classpath:features/Api/JobTitle/JobCreate.feature')
    * def ids = [#(result.data.id)]

    * def titleName = "job " + randomData.randomUUIShort()
    * def result2 = call read('classpath:features/Api/JobTitle/JobCreate.feature')
    * print 'result2 =', result2.data.id
    * karate.appendTo(ids, result2.data.id)

    Given request { 'ids': #(ids) }
    When method delete
    Then status 200

    * def idString = []
    * karate.forEach(ids, function(x){ idString.push(x + '') })

    And match response.data == idString
    And match response.meta == []
    And match response.rels == []

  Scenario: DEL-JOB8 - Delete with  ids is exists and other is not
    * def titleName = "job " + randomData.randomUUIShort()
    * def randomId = randomData.randomNumber()
    * def result = call read('classpath:features/Api/JobTitle/JobCreate.feature')
    * def ids = [#(result.data.id), #(randomId)]

    Given request { 'ids':#(ids) }
    When method delete
    Then status 200

    * def expectedDelete = [ '#(result.data.id + "")' ]

    And match response.data == expectedDelete
    And match response.meta == []
    And match response.rels == []

