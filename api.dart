Future<dynamic> getMethod() async {
  String theUrl = 'https://jsonplaceholder.typicode.com/posts';
  try {
    var res = await http.get(Uri.parse(theUrl), headers: {"Accept": "application/json"});
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Failed to load data. Status code: ${res.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
}
