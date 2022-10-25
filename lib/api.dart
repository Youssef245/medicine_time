const apiURL = "http://196.218.149.186:8095";
//const apiURL = "http://192.168.1.9:8080";

const medicinesURL = "$apiURL/medicines";
const categoriesURL = "$apiURL/medCategories";
const alarmsURL = "$apiURL/alarms";
const lastAlarmURL = "$apiURL/alarms/last";
const loginURL = "$apiURL/loginrequest";
const historyURL = "$apiURL/history";
const measuresURL = "$apiURL/measures";
const sideEffectsURL = "$apiURL/sideeffects";
const askURL = "$apiURL/ask";
const questionsURL = "$apiURL/questions";
const userEffectsURL = "$apiURL/usereffects";
const surveyURL = "$apiURL/survey";
const test1URL = "$apiURL/test1";
const test2URL = "$apiURL/test2";
const test3URL = "$apiURL/test3";
const usersURL = "$apiURL/users";

String deleteAlarmURL(String id) => "$alarmsURL/$id";
String getQuestionsURL(String id) => "$questionsURL/$id";
String getUsersInfoURL(String id) => "$usersURL/$id";
String postUsersInfoURL(String id) => "$usersURL/$id";
String getUserEffects(String id) => "$userEffectsURL/$id";
