class Urls {
  static const String _baseUrl = "https://task-manager-api.ostad.live/api/v1";
  static const String registrationUrl = "$_baseUrl/Registration";
  static const String loginUrl = "$_baseUrl/Login";
  static const String createTaskUrl = "$_baseUrl/createTask";
  static const String taskCountUrl = "$_baseUrl/taskStatusCount";
  static const String newTaskUrl = "$_baseUrl/listTaskByStatus/New";
  static const String progressTaskUrl = "$_baseUrl/listTaskByStatus/Progress";
  static const String completedTaskUrl = "$_baseUrl/listTaskByStatus/Completed";
  static const String cancelledTaskUrl = "$_baseUrl/listTaskByStatus/Cancelled";
  static String deleteTaskUrl(String taskId) => "$_baseUrl/deleteTask/$taskId";

  //if we wanna use same url and just change the type, barbar likhte hbena.
  static String taskListUrl(String type) => "$_baseUrl/listTaskByStatus/$type";

  //change status url:
  static String changeStatus(String taskId, String status) =>
      "$_baseUrl/updateTaskStatus/$taskId/$status";

  //profile handling
  static String profileDetailsUrl = "$_baseUrl/ProfileDetails";
  static String profileUpdateUrl = "$_baseUrl/ProfileUpdate";
}
