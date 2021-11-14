import 'package:http/http.dart' as http;

void main() async {
  var headers = {
    'Host': 'api.123movie.cc',
    'Connection': 'close',
    'sec-ch-ua': '\"Chromium\";v=\"89\", \";Not A Brand\";v=\"99\"',
    'sec-ch-ua-mobile': '?0',
    'Upgrade-Insecure-Requests': '1',
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.128 Safari/537.36',
    'Accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'Sec-Fetch-Site': 'same-origin',
    'Sec-Fetch-Mode': 'navigate',
    'Sec-Fetch-Dest': 'iframe',
    'Referer': 'https://api.123movie.cc/imdb.php?imdb=tt12361974&server=vcs',
    'Accept-Encoding': 'gzip, deflate',
    'Accept-Language': 'en-US,en;q=0.9',
  };

  var params = {
    'hash':
        'Z1cvV2JVa1l6QXlYL3U0eiszRXRtaCtLaFJXdzdOTVdPV3VFVHRJbFI1enVLWWZPSTY2S1RrS3pnNzNXbHRTekdneHcvdnRRMlJjOW5IYnFiNmhvajNsYWo2YmlUbytpdU5UZFM0NnJBdlVrcENqdlZHNzhpRWRMaGtqMGt0UmFHR0pZSVY5Snp4UG4rQkV2VGQxejAvbTVYLzZIb0lGbGlJbVFBWVVQMVBjc3V5RFBOeVorSVRGNU52bkJGNGdsQWowdmI0NUk2QStOYS9VZmplTGZnM1FPN3VmNkZXUndVYlBYY3RUTmZ3T0tReWF3ZGtCemxsSW1mTVVRRGtBVVp0SnRoRGp3Yzh5TnhHaGVpbUpqRzZZcWxjcTZjYmJuNDBCM3VqU1JVelk9',
  };
  var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

  var res = await http.get(
      Uri.parse('https://api.123movie.cc/al-badam/?$query'),
      headers: headers);
  if (res.statusCode != 200)
    throw Exception('http.get error: statusCode= ${res.statusCode}');
  print(res.body);
}
