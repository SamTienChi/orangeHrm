@Api
Feature: Create Job title
Background: create new job
  * url baseApi
  * path endpoints.admin.jobTitles
  * def fileBytes = read('classpath:files/file_test.png')
  * def Base64 = Java.type('java.util.Base64')
  * def base64File = Base64.getEncoder().encodeToString(fileBytes)

  @non-image
  Scenario: create with non-image
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
    * def data = response.data

  @containImage
  Scenario: create with upload image
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
    * def data = response.data