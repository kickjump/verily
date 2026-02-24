// TODO: These tests require serverpod_test setup with a running test database.
// Run with: cd verily_server && dart test
//
// To run these tests, you need:
// 1. A running PostgreSQL test database
// 2. serverpod_test configured with test session support
// 3. Generated protocol code from `serverpod generate`

import 'package:test/test.dart';

// These imports will resolve once `serverpod generate` has been run:
// import 'package:verily_server/src/generated/protocol.dart';
// import 'package:verily_server/src/services/action_category_service.dart';
// import 'package:verily_server/src/exceptions/server_exceptions.dart';

void main() {
  group('ActionCategoryService', () {
    // late Session session;

    // setUp(() async {
    //   session = await createTestSession();
    // });

    // tearDown(() async {
    //   await session.close();
    // });

    // -------------------------------------------------------------------------
    // create()
    // -------------------------------------------------------------------------

    group('create()', () {
      test(
        'creates a category with required fields',
        () async {
          // final category = await ActionCategoryService.create(
          //   session,
          //   name: 'Test Category',
          //   sortOrder: 0,
          // );
          //
          // expect(category.id, isNotNull);
          // expect(category.name, equals('Test Category'));
          // expect(category.sortOrder, equals(0));
          // expect(category.description, isNull);
          // expect(category.iconName, isNull);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'creates a category with all fields',
        () async {
          // final category = await ActionCategoryService.create(
          //   session,
          //   name: 'Full Category',
          //   sortOrder: 1,
          //   description: 'A fully specified category',
          //   iconName: 'star',
          // );
          //
          // expect(category.name, equals('Full Category'));
          // expect(category.description, equals('A fully specified category'));
          // expect(category.iconName, equals('star'));
          // expect(category.sortOrder, equals(1));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException when name already exists',
        () async {
          // await ActionCategoryService.create(
          //   session,
          //   name: 'Duplicate',
          //   sortOrder: 0,
          // );
          //
          // expect(
          //   () => ActionCategoryService.create(
          //     session,
          //     name: 'Duplicate',
          //     sortOrder: 1,
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // listAll()
    // -------------------------------------------------------------------------

    group('listAll()', () {
      test(
        'returns categories ordered by sortOrder',
        () async {
          // await ActionCategoryService.create(
          //   session,
          //   name: 'Zeta',
          //   sortOrder: 2,
          // );
          // await ActionCategoryService.create(
          //   session,
          //   name: 'Alpha',
          //   sortOrder: 0,
          // );
          // await ActionCategoryService.create(
          //   session,
          //   name: 'Beta',
          //   sortOrder: 1,
          // );
          //
          // final categories = await ActionCategoryService.listAll(session);
          // expect(categories.length, greaterThanOrEqualTo(3));
          //
          // // Verify ordering.
          // for (var i = 1; i < categories.length; i++) {
          //   expect(
          //     categories[i].sortOrder,
          //     greaterThanOrEqualTo(categories[i - 1].sortOrder),
          //   );
          // }
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // findById()
    // -------------------------------------------------------------------------

    group('findById()', () {
      test(
        'returns category by primary key',
        () async {
          // final created = await ActionCategoryService.create(
          //   session,
          //   name: 'FindById Category',
          //   sortOrder: 0,
          // );
          //
          // final found = await ActionCategoryService.findById(
          //   session,
          //   created.id!,
          // );
          // expect(found.name, equals('FindById Category'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws NotFoundException for non-existent id',
        () async {
          // expect(
          //   () => ActionCategoryService.findById(session, 99999),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // findByName()
    // -------------------------------------------------------------------------

    group('findByName()', () {
      test(
        'returns category when found',
        () async {
          // await ActionCategoryService.create(
          //   session,
          //   name: 'Unique Name',
          //   sortOrder: 0,
          // );
          //
          // final found = await ActionCategoryService.findByName(
          //   session,
          //   'Unique Name',
          // );
          // expect(found, isNotNull);
          // expect(found!.name, equals('Unique Name'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'returns null when not found',
        () async {
          // final result = await ActionCategoryService.findByName(
          //   session,
          //   'NonExistent Category',
          // );
          // expect(result, isNull);
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // update()
    // -------------------------------------------------------------------------

    group('update()', () {
      test('updates category name', () async {
        // final created = await ActionCategoryService.create(
        //   session,
        //   name: 'Old Name',
        //   sortOrder: 0,
        // );
        //
        // final updated = await ActionCategoryService.update(
        //   session,
        //   id: created.id!,
        //   name: 'New Name',
        // );
        //
        // expect(updated.name, equals('New Name'));
      }, skip: 'Requires serverpod_test database session');

      test(
        'updates description and iconName',
        () async {
          // final created = await ActionCategoryService.create(
          //   session,
          //   name: 'Update Fields',
          //   sortOrder: 0,
          // );
          //
          // final updated = await ActionCategoryService.update(
          //   session,
          //   id: created.id!,
          //   description: 'Updated description',
          //   iconName: 'updated_icon',
          // );
          //
          // expect(updated.description, equals('Updated description'));
          // expect(updated.iconName, equals('updated_icon'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test('updates sortOrder', () async {
        // final created = await ActionCategoryService.create(
        //   session,
        //   name: 'Sort Order Test',
        //   sortOrder: 0,
        // );
        //
        // final updated = await ActionCategoryService.update(
        //   session,
        //   id: created.id!,
        //   sortOrder: 99,
        // );
        //
        // expect(updated.sortOrder, equals(99));
      }, skip: 'Requires serverpod_test database session');

      test(
        'throws ValidationException when renaming to existing name',
        () async {
          // await ActionCategoryService.create(
          //   session,
          //   name: 'Existing',
          //   sortOrder: 0,
          // );
          // final second = await ActionCategoryService.create(
          //   session,
          //   name: 'ToRename',
          //   sortOrder: 1,
          // );
          //
          // expect(
          //   () => ActionCategoryService.update(
          //     session,
          //     id: second.id!,
          //     name: 'Existing',
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'allows updating with the same name (no change)',
        () async {
          // final created = await ActionCategoryService.create(
          //   session,
          //   name: 'Same Name',
          //   sortOrder: 0,
          // );
          //
          // // Should not throw since the name isn't changing.
          // final updated = await ActionCategoryService.update(
          //   session,
          //   id: created.id!,
          //   name: 'Same Name',
          // );
          //
          // expect(updated.name, equals('Same Name'));
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // delete()
    // -------------------------------------------------------------------------

    group('delete()', () {
      test(
        'deletes a category by id',
        () async {
          // final created = await ActionCategoryService.create(
          //   session,
          //   name: 'Delete Me',
          //   sortOrder: 0,
          // );
          //
          // await ActionCategoryService.delete(session, created.id!);
          //
          // expect(
          //   () => ActionCategoryService.findById(session, created.id!),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws NotFoundException for non-existent id',
        () async {
          // expect(
          //   () => ActionCategoryService.delete(session, 99999),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // ensureDefaults()
    // -------------------------------------------------------------------------

    group('ensureDefaults()', () {
      test(
        'creates the four default categories',
        () async {
          // await ActionCategoryService.ensureDefaults(session);
          //
          // final categories = await ActionCategoryService.listAll(session);
          // final names = categories.map((c) => c.name).toSet();
          //
          // expect(names, contains('Fitness'));
          // expect(names, contains('Social'));
          // expect(names, contains('Creative'));
          // expect(names, contains('Wellness'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'is idempotent - calling twice does not create duplicates',
        () async {
          // await ActionCategoryService.ensureDefaults(session);
          // final countAfterFirst = (await ActionCategoryService.listAll(session)).length;
          //
          // await ActionCategoryService.ensureDefaults(session);
          // final countAfterSecond = (await ActionCategoryService.listAll(session)).length;
          //
          // expect(countAfterSecond, equals(countAfterFirst));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'default categories have correct sort order',
        () async {
          // await ActionCategoryService.ensureDefaults(session);
          //
          // final fitness = await ActionCategoryService.findByName(session, 'Fitness');
          // final social = await ActionCategoryService.findByName(session, 'Social');
          // final creative = await ActionCategoryService.findByName(session, 'Creative');
          // final wellness = await ActionCategoryService.findByName(session, 'Wellness');
          //
          // expect(fitness!.sortOrder, equals(0));
          // expect(social!.sortOrder, equals(1));
          // expect(creative!.sortOrder, equals(2));
          // expect(wellness!.sortOrder, equals(3));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'default categories have icons',
        () async {
          // await ActionCategoryService.ensureDefaults(session);
          //
          // final fitness = await ActionCategoryService.findByName(session, 'Fitness');
          // expect(fitness!.iconName, equals('fitness_center'));
          //
          // final social = await ActionCategoryService.findByName(session, 'Social');
          // expect(social!.iconName, equals('people'));
        },
        skip: 'Requires serverpod_test database session',
      );
    });
  });
}
