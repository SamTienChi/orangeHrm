function encodeFile(path){
  var fileBytes = karate.read(path);
  var Base64 = Java.type('java.util.Base64');
  return {
    bytes: fileBytes,
    base64: Base64.getEncoder().encodeToString(fileBytes)
  };
}