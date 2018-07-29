////
//// Copyright 2014 Google Inc. All rights reserved.
////
//// Use of this source code is governed by a BSD-style
//// license that can be found in the LICENSE file or at
//// https://developers.google.com/open-source/licenses/bsd
////
//
//library charted.tool.hop_runner;
//
//import 'package:hop/hop.dart';
//import 'dart:io';
//
//main(List<String> args) {
//  addTask('unit-test', createUnitTestsTask());
//  runHop(args);
//}
//
//Task createUnitTestsTask() =>
//  new Task((TaskContext context) {
//    context.info("Running tests...");
//    return Process.run('./content_shell',
//        ['--dump-render-tree','test/test_in_browser.html']).
//            then((ProcessResult process) =>
//                checkTestsOutput(context, process));
//  });
//
///// Reads the output from content_shell and checks for number of tests
///// passed/failed/erred. This method requires that the tests be done
///// in simple html unit test configuration - useHtmlConfiguration().
//void checkTestsOutput(TaskContext context, ProcessResult process) {
//  var output = (process.stdout as String),
//      failRegEx = new RegExp(r"^[0-9]+\s+FAIL\s"),
//      errorRegEx = new RegExp(r"^[0-9]+\s+ERROR\s"),
//      failCount = 0,
//      errorCount = 0;
//
//  context.info(output);
//
//  for (var line in output.split('\n')) {
//    if (line.contains(failRegEx)) failCount++;
//    if (line.contains(errorRegEx)) errorCount++;
//  }
//
//  if (failCount + errorCount > 0) {
//    context.fail('FAIL: $failCount\nERROR: $errorCount');
//  }
//}
