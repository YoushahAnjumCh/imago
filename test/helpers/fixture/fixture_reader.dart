import 'dart:io';

String fixture(String name) =>
    File('test/helpers/mock/json/$name').readAsStringSync();
