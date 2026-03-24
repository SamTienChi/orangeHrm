Feature: Get cookie from login
Background:
  * url baseUrl
  * def username = auth.username
  * def password = auth.password
  * configure followRedirects = false

  Scenario: Login
    Given path 'login'
    When method get
    Then status 200

    * def csrfToken = response.match(/:token="&quot;(.*?)&quot;"/)[1]
    * print 'Token' ,csrfToken

    Given path 'validate'
    And form field _token = csrfToken
    And form field username = username
    And form field password = password
    When method post
    Then status 302

#    * print 'status get', responseStatus
#    * print 'Header get', responseHeaders
#    * print 'Response get', response
    * def getCookie  = responseHeaders['Set-Cookie']
    * def cookies = getCookie.map(x => x.split(';')[0]).join('; ')

