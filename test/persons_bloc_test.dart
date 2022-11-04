import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testingbloc_practice/bloc/bloc_actions.dart';
import 'package:testingbloc_practice/bloc/person.dart';
import 'package:testingbloc_practice/bloc/persons_bloc.dart';

const mockedPerson1 = [
  Person(
    name: 'Foo',
    age: 20,
  ),
  Person(
    name: 'Bar',
    age: 30,
  ),
];

const mockedPerson2 = [
  Person(
    name: 'Foo',
    age: 20,
  ),
  Person(
    name: 'Bar',
    age: 30,
  ),
];

Future<Iterable<Person>> mockGetPerson1(String _) =>
    Future.value(mockedPerson1);

Future<Iterable<Person>> mockGetPerson2(String _) =>
    Future.value(mockedPerson2);

void main() {
  group('Testing bloc', () {
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test initial state',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving person from first iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_1',
            loader: mockGetPerson1,
          ),
        );
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_1',
            loader: mockGetPerson1,
          ),
        );
      },
      expect: () => [
        const FetchResult(
          persons: mockedPerson1,
          isRetrievedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPerson1,
          isRetrievedFromCache: true,
        ),
      ],
    );

    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving person from second iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_2',
            loader: mockGetPerson2,
          ),
        );
        bloc.add(
          const LoadPersonAction(
            url: 'dummy_url_2',
            loader: mockGetPerson2,
          ),
        );
      },
      expect: () => [
        const FetchResult(
          persons: mockedPerson2,
          isRetrievedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPerson2,
          isRetrievedFromCache: true,
        ),
      ],
    );
  });
}
