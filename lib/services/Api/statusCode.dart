
class StatusCode {
  static const Map<int, List<String>> code = {
    200: ['OK', 'The request was successful and response data was returned.'],
    201: [
      'Created',
      'The request to create a resource was successful and response data was returned. The location header contains the created resource\'s URI.'
    ],
    204: [
      'No Content',
      'The request was successful and no response data is needed.'
    ],
    400: ['Bad Request', 'The request is invalid and cannot be accepted.'],
    403: [
      'Forbidden',
      'The request is not allowed. This can happen if your API key is revoked, your token is incorrectly formatted, or if the requested operation is not allowed.'
    ],
    404: [
      'Not Found',
      'The request cannot be fulfilled because the resource does not exist.'
    ],
    405: [
      'Method Not Allowed',
      'The request cannot be accepted because the HTTP method is not appropriate for the given URI.'
    ],
    406: [
      'Not Acceptable',
      'The request cannot be accepted because the Accept header requires a media type the API does not support.\nThe response in this case is in plain text, not JSON.'
    ],
    409: [
      'Conflict',
      'The request cannot be accepted because the JSON data you have provided conflicts with rules enforced by the API.'
    ],
    410: [
      'Gone',
      'The request cannot be fulfilled because the requested resource, which is known to have previously existed, no longer exists. Usually this case results in a 404 status code, but when knowledge that a resource previously existed is important, the API returns a 410. This happens, for instance, if you request a user invitation after the user accepted the invitation.'
    ],
    415: [
      'Unsupported Media Type',
      'The request cannot be accepted because the media type of the request entity is not a format the API understands. Make sure the Content-Type header in the request is application/json.'
    ],
    422: [
      'Unprocessable Entity',
      'The request cannot be accepted because the data you provided is not valid JSON or is not expected for the request.'
    ],
    429: [
      'Too Many Requests',
      'The request cannot be accepted because you have exceeded the rate limit for your API key. You will need to wait awhile and try the request again.'
    ],
    500: [
      'Internal Server Error',
      'The request failed. This may be due to a temporary outage. Check the Apple Developer System Status Page for up to date information on the App Store Connect API.'
    ],
  };
  static String getName(int statusCode) {
    if (code.containsKey(statusCode)) {
      return code[statusCode]![0].toString();
    }
    return '';
  }

  static String getDesc(int statusCode) {
    if (code.containsKey(statusCode)) {
      return code[statusCode]![1].toString();
    }
    return '';
  }
}
