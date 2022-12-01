// Mocks generated by Mockito 5.3.2 from annotations
// in glas_client/test/import_page_widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:glas_client/api/glas_http_client.dart' as _i4;
import 'package:http/http.dart' as _i3;
import 'package:logger/logger.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeLogger_0 extends _i1.SmartFake implements _i2.Logger {
  _FakeLogger_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeResponse_1 extends _i1.SmartFake implements _i3.Response {
  _FakeResponse_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GlasHttpClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockGlasHttpClient extends _i1.Mock implements _i4.GlasHttpClient {
  @override
  _i2.Logger get logger => (super.noSuchMethod(
        Invocation.getter(#logger),
        returnValue: _FakeLogger_0(
          this,
          Invocation.getter(#logger),
        ),
        returnValueForMissingStub: _FakeLogger_0(
          this,
          Invocation.getter(#logger),
        ),
      ) as _i2.Logger);
  @override
  _i5.Future<_i3.Response> post(
    String? path,
    Map<String, String>? body,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [
            path,
            body,
          ],
        ),
        returnValue: _i5.Future<_i3.Response>.value(_FakeResponse_1(
          this,
          Invocation.method(
            #post,
            [
              path,
              body,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Response>.value(_FakeResponse_1(
          this,
          Invocation.method(
            #post,
            [
              path,
              body,
            ],
          ),
        )),
      ) as _i5.Future<_i3.Response>);
  @override
  _i5.Future<_i3.Response> get(
    String? path, [
    Map<String, String>? params = const {},
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [
            path,
            params,
          ],
        ),
        returnValue: _i5.Future<_i3.Response>.value(_FakeResponse_1(
          this,
          Invocation.method(
            #get,
            [
              path,
              params,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Response>.value(_FakeResponse_1(
          this,
          Invocation.method(
            #get,
            [
              path,
              params,
            ],
          ),
        )),
      ) as _i5.Future<_i3.Response>);
}
