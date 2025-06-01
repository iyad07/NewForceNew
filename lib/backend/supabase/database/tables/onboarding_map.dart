import '../database.dart';

class OnboardingMapTable extends SupabaseTable<OnboardingMapRow> {
  @override
  String get tableName => 'onboardingMap';

  @override
  OnboardingMapRow createRow(Map<String, dynamic> data) =>
      OnboardingMapRow(data);
}

class OnboardingMapRow extends SupabaseDataRow {
  OnboardingMapRow(super.data);

  @override
  SupabaseTable get table => OnboardingMapTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get overview => getField<String>('overview');
  set overview(String? value) => setField<String>('overview', value);
}
